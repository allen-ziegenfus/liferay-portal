# Option 2: Compile Low, Depend `compileOnly`

**This option is not a new library.** It is an in-place edit to
`modules/util/client-extension-util-spring-boot3`, which is why this directory
has no `src/main/java/com/liferay/client/extension/spring/boot/...` tree like
the others. There is nothing to build; there is a patch to apply.

```
option-2.patch          the whole change, as a unified diff against the shipping module
in-place-patch/         the two modified files, at their real paths
customer-example/       proof that nothing changes at the call site
```

## The Whole Change Is Two Files

Apply and read it:

```bash
git apply --stat client-extension-util-prototypes/2-compile-low-provided/option-2.patch
```

**`build.gradle`** — four `api ... version: "3.5.14"` declarations become
`compileOnly ... version: springBootFloor`, plus three `testCompatNN` tasks
wired into `check`.

**`LiferayOAuth2ResourceServerEnableWebSecurity.java`** — one import swapped,
one method rewritten:

```diff
 		return httpSecurity.cors(
-		).and(
+			Customizer.withDefaults()
 		).csrf(
-		).disable(
+			csrfConfigurer -> csrfConfigurer.disable()
 		).sessionManagement(
-		).sessionCreationPolicy(
-			SessionCreationPolicy.STATELESS
-		).and(
+			sessionManagementConfigurer ->
+				sessionManagementConfigurer.sessionCreationPolicy(
+					SessionCreationPolicy.STATELESS)
 		).authorizeHttpRequests(
 			customizer -> customizer.requestMatchers(
 				_liferayOauthURLsExcludes
 			).permitAll(
 			).anyRequest(
 			).authenticated()
 		).oauth2ResourceServer(
-			OAuth2ResourceServerConfigurer::jwt
+			oAuth2ResourceServerConfigurer ->
+				oAuth2ResourceServerConfigurer.jwt(Customizer.withDefaults())
 		).build();
```

Same behavior, same beans, same bean names. The lambda DSL has existed since
Spring Security 5.2 and is the only form that exists in 7.

## Why It Really Is Just That Method

Verified across the whole module rather than assumed:

```bash
grep -rn "\.and(\|httpSecurity\.\|OAuth2ResourceServerConfigurer::" \
    modules/util/client-extension-util-spring-boot3/src/main/java
```

Four hits, all in lines 119–134 of that one file. And the removals that usually
bite on a Spring Security major are all absent:

| Pattern | Occurrences |
|---|---:|
| `antMatchers` | 0 |
| `WebSecurityConfigurerAdapter` | 0 |
| `authorizeRequests` | 0 |
| `javax.` | 0 |
| `EnableGlobalMethodSecurity` | 0 |
| `WebMvcConfigurerAdapter` | 0 |

## Why The Floor Is 3.1.12

The only two version-sensitive calls in the entire module are `HttpStatusCode`
(Spring 6.0) and `requestMatchers` (Spring Security 5.8). Nothing uses
`RestClient` (Boot 3.2) or `jwtProcessorCustomizer`. So the module can honestly
claim Boot 3.1 and up, and the `testCompatNN` tasks check that claim on every
`check` rather than trusting it.

Raise the floor later if a change needs a newer API — but raise it deliberately,
which is the part that is missing today.

## What This Buys, And What It Does Not

**Buys:** the CVE re-export goes away (a Spring advisory becomes the consumer's
version bump, not a 26-workspace coordination), the Boot 4 cliff goes away, and
the Boot 2 / Boot 3 classpath collision in the sample workspaces becomes
impossible because only one place declares a Spring version.

**Does not buy:** anything else. `BaseService` is still an abstract class with
`protected` methods, still builds a 500-connection pool per request, still turns
a 204 into `"{}"`, and every piece of the library is still unconditional. Those
are Options 1, 3 and 4.

## One Decision It Forces

With `compileOnly`, a consumer must declare the Spring starters themselves. Most
already do — see `customer-example/build.gradle` — but a consumer who relied on
the transitive ones gets a runtime `NoClassDefFoundError` rather than a compile
error.

Two ways to handle it, and this is the one thing about Option 2 that needs a
decision rather than a review:

1. Publish a `-starter` artifact that declares the four starters, and tell
   existing consumers to depend on it. Zero-effort migration, one new artifact.
2. Ship as a **major** version bump with a release note. No new artifact, but
   every consumer edits `build.gradle` once.

Option 1 needs the `-starter` anyway, so doing it here is not wasted work.
