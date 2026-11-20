# One Real Sample, Migrated Four Ways

`liferay-sample-workspace/client-extensions/liferay-sample-etc-spring-boot`,
`ObjectAction2RestController` — the canonical sample customers copy. It was
chosen because it exercises both halves of the library in 40 lines:

- **inbound** — a JWT-secured `@PostMapping` receiving an object-action callback
- **outbound** — a `PATCH` back to `headless-admin-user` using the caller's token

`0-today/` is a verbatim copy of what ships. The other four directories are the
same file under each prototype.

## The Consumer-Facing Diff

| | App class | Controller | Extra files consumer writes | Controller code lines |
|---|---|---|---|---:|
| **today** | `@Import(...ComponentScan)` | `extends BaseRestController` | — | 40 |
| **1** | `@Import` deleted | injected `LiferayRestClient` | — | 45 |
| **2** | **unchanged** | **unchanged** | — | 40 |
| **3** | `@Import` deleted | injected `LiferayRestClient` | — | 45 |
| **4** | no Liferay import | no Liferay import | `DXPUris` (21), `SampleSecurityConfiguration` (31) | 53 |

## What Each One Actually Shows

### 0-today

Two things this file does that are worth having in front of you before reading
the rest.

`extends BaseRestController` — so `@RestController` is inherited rather than
written, and 24 outbound HTTP methods are in scope inside a controller.

And two defects, both in the file we hand to customers as the reference
implementation.

**1. The upstream status is discarded and replaced with a hardcoded 200.**

```java
return new ResponseEntity<>(
    patch("Bearer " + jwt.getTokenValue(), ..., uri),
    HttpStatus.OK);
```

If `headless-admin-user` returns 422 because `givenName` was rejected, Liferay's
object-action framework is told the update succeeded. The sample *cannot* do
better: `patch` returns a bare `String`, and a non-2xx arrives as a
`WebClientResponseException` that nothing catches. This one is caused by the
library's API shape, and Options 1, 3 and 4 fix it for free.

**2. The null guard is unreachable, and the payload it guards against throws.**

```java
JSONObject modelDTOAccountJSONObject = jsonObject.getJSONObject("modelDTOAccount");

if (modelDTOAccountJSONObject == null) {   // never true
    return new ResponseEntity<>(json, HttpStatus.OK);
}
```

`org.json`'s `getJSONObject` throws when the key is absent; it never returns
null. Verified against `json-20231013.jar`:

```
optJSONObject -> null
getJSONObject THREW -> JSONException: JSONObject["modelDTOAccount"] not found.
```

So an object-action payload without `modelDTOAccount` produces a 500 rather than
the intended pass-through. This one is **not** the library's fault — it is an
`org.json` usage error — but it is worth noting that it has sat in the canonical
sample undetected, which is what happens when a class cannot be unit tested. The
migrated versions use `optJSONObject`.

### 1 — Auto-configuration

`@Import` deleted from the application class. The controller extends nothing and
takes `LiferayRestClient` by constructor. Five lines longer, and it returns the
real `ResponseEntity` from the PATCH, so the 422 propagates.

`build.gradle` loses two dependencies: `spring-boot-starter-webflux` (declared
today only so `BaseService` can call `block()`) and
`org.apache.commons.logging` (needed today only for `BaseService.log`).

`src/test/` contains the file that could not previously exist —
`ObjectAction2RestControllerTest`, which asserts the "no `modelDTOAccount`, don't
call Liferay" branch and the 422 propagation with a mocked client, no Spring
context and no mock server.

### 2 — Compile low

`diff -r 0-today/src 2-compile-low-provided/src` produces no output. That is the
whole point of the option, and it is verified rather than asserted.

Only `build.gradle` changes — and the shipping one is worth reading, because the
canonical sample has the Boot 2 / Boot 3 classpath clash in it:

```groovy
classpath group: "org.springframework.boot",
    name: "spring-boot-gradle-plugin", version: "2.7.18"
...
implementation group: "com.liferay",
    name: "com.liferay.client.extension.util.spring.boot3",  // exports Boot 3.5.14
    version: "latest.release"
implementation group: "org.springframework.boot",
    name: "spring-boot-starter-web", version: "2.7.18"
```

Spring Boot 2.7.18 declared three times next to a library declaring 3.5.14 as
`api`. Both majors on one classpath, Gradle picks a winner. Once the library
stops re-exporting Spring the conflict is not possible, because there is only
one place a Spring version is declared.

### 3 — Pure-Java core

**The controller is character-for-character identical to Option 1's, except for
one import path.** Worth stating rather than dressing up: for a controller like
this, choosing Option 3 over Option 1 buys the consumer nothing. The payoff is
entirely on the maintenance side, and it appears on exactly two days — when
Spring Boot 5 ships, and when someone writes a test.

`SampleCronRunner` (33 lines, not counted above since it has no equivalent in
the other versions) is where the split does become visible. A cron-style client
extension needs the resolved DXP base URI and the registered external reference
codes with no HTTP request to hang them off. Against the shipping library the
options are to extend `BaseService` — inheriting 24 HTTP methods and an
`@RestController` ancestor to read two `protected` `@Value` fields — or to
re-derive the base URL by hand. Here they are ordinary injected beans.

### 4 — Property translation

The application class and the controller contain **no Liferay import at all**,
and `build.gradle` declares the library `runtimeOnly` because no source file
names a type from it.

Then the bill arrives, and this is the most useful output of the exercise:

- **`DXPUris`, 21 lines.** Option 4 ships no HTTP client, so it ships no
  base-URI resolution. Every client extension that calls back into Liferay
  writes its own copy of this.
- **`SampleSecurityConfiguration`, 31 lines.** Option 4 ships no filter chain,
  so Boot's default resource-server chain applies — which authenticates
  requests but leaves CSRF enabled and sessions creatable. This endpoint is a
  stateless bearer-token POST, so under the default it starts returning **403**.

So the maintained library drops to roughly fifty lines, but **52 lines did not
disappear — they crossed the support boundary to the customer**, uncoordinated
and unversioned. And the security filter chain in particular is the kind of code
where getting it subtly wrong is a vulnerability rather than a compile error,
which is the strongest single argument for keeping it in a library.

## What The Exercise Settles

1. **Options 1 and 3 are indistinguishable to consumers.** The choice between
   them is purely about who rewrites what on the next Spring major, and should
   be argued on that basis rather than on developer experience.
2. **Option 2 really is free at the call site**, and `diff -r` proves it.
3. **Option 4's line count is misleading.** "Fifty-line library" is true and
   incomplete; the honest framing is that it relocates the HTTP client and the
   filter chain to every consumer. That is a defensible trade for the client,
   and a much harder one for the filter chain.
4. **The shipping sample has two live bugs**, found by transcribing 40 lines
   four times. The hardcoded `HttpStatus.OK` is caused by the library's API
   shape and is fixed for free by Options 1, 3 and 4. The unreachable null guard
   is an independent `org.json` misuse — but it survived in the reference sample
   because nothing about that class was testable, which is the library's fault.
   Both are worth filing regardless of which option wins.
