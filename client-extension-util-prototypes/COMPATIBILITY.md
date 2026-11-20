# Which Option Is Most Compatible With What We Already Ship?

## The Surface Is Six Types

Measured across `workspaces/`, the entire customer-visible API of
`client-extension-util-spring-boot3` is six types and 198 import statements:

| Fully qualified name | Imports |
|---|---:|
| `...util.spring.boot3.BaseRestController` | 104 |
| `...util.spring.boot3.client.LiferayOAuth2AccessTokenManager` | 34 |
| `...util.spring.boot3.service.BaseService` | 25 |
| `...util.spring.boot3.ClientExtensionUtilSpringBootComponentScan` | 25 |
| `...util.spring.boot3.client.ClientExtensionUtilSpringBootClientComponentScan` | 7 |
| `...util.spring.boot3.client.LiferayOAuth2Util` | 3 |

Across **20 workspaces**, including `liferay-learn-workspace` — the samples
published on learn.liferay.com. Whatever we do has to survive being the thing
the documentation tells customers to copy.

That the surface is six types and not 1,271 lines is the useful finding. A
compatibility shim is tractable.

## The Answer

**Option 2 is the most compatible, and it is not close.** Nothing at the call
site changes, and that is verified rather than argued:

```bash
diff -r migrated-sample/0-today/src migrated-sample/2-compile-low-provided/src
# (no output)
```

Same package, same coordinates, same classes, same behavior. Only `build.gradle`
changes, and only in ways that *reduce* what a consumer inherits. A customer on
1.0.9 moves to it by changing a version number.

**Option 1 is a close second, but only with the `-compat` artifact** described
below — and an earlier draft of these prototypes got this wrong.

## The Mistake Worth Recording

The first version of Option 1 shipped its deprecated `BaseService` in a *new*
package, `com.liferay.client.extension.spring.boot.legacy`, and claimed "none of
the 653 subclasses change."

That was true for behavior and false for source. All 198 imports name
`com.liferay.client.extension.util.spring.boot3.*`. A new package means every
one of them fails to compile — which is the opposite of a compatibility bridge.

The same draft also proposed **deleting `BaseRestController`** on the grounds
that it contained nothing but an annotation. It contains nothing but an
annotation *and is the single most-referenced type in the library*, at 104
imports. Both facts are true; only one of them should drive the decision.

The corrected `-compat` artifact publishes at the **original coordinates in the
original package** and carries all six types, every one `@Deprecated`:

| Type | Shim strategy |
|---|---|
| `BaseRestController` | Unchanged, deprecated |
| `BaseService` | Deprecated, delegates to the shared client, old body contract preserved exactly |
| `LiferayOAuth2AccessTokenManager` | Deprecated, forwards to the replacement bean |
| `LiferayOAuth2Util` | Deprecated, original statics, `WebClient` swapped for `RestClient` |
| Both `*ComponentScan` classes | Deprecated empty `@Configuration`. Auto-config already registered everything and every bean is `@ConditionalOnMissingBean`, so the `@Import` contributes nothing and conflicts with nothing |

The two `*ComponentScan` shims are the cheapest compatibility in the set,
because the originals were already empty classes whose only job was to anchor an
`@ComponentScan`. There is no behavior to preserve.

## Full Matrix

| Type (imports) | Opt 1 + compat | Opt 2 | Opt 3 + compat | Opt 4 |
|---|---|---|---|---|
| `BaseRestController` (104) | compiles, deprecated | **unchanged** | compiles, deprecated | **breaks** |
| `LiferayOAuth2AccessTokenManager` (34) | compiles, deprecated | **unchanged** | compiles, deprecated | **breaks** |
| `BaseService` (25) | compiles, deprecated | **unchanged** | compiles, deprecated | **breaks** |
| `ClientExtensionUtilSpringBootComponentScan` (25) | compiles, no-op | **unchanged** | compiles, no-op | **breaks** |
| `...ClientComponentScan` (7) | compiles, no-op | **unchanged** | compiles, no-op | **breaks** |
| `LiferayOAuth2Util` (3) | compiles, deprecated | **unchanged** | compiles, deprecated | **breaks** |
| **Consumer source edits required** | **0** | **0** | **0** | **all 198** |
| Artifacts a legacy consumer depends on | 2 | 1 | 3 | 1 |

Option 3 reuses Option 1's `-compat` unchanged, so its compatibility story is
identical; it just has one more artifact underneath.

**Option 4 breaks every one of the six.** It provides no HTTP client, so
`BaseService` and `BaseRestController` have no replacement at all, and Spring
Security's authorized client manager replaces `LiferayOAuth2AccessTokenManager`
with a different type and a different API. That is not a flaw in the option —
it is the option. It is a rewrite, and it should be presented as one.

## What This Means For The Published Samples

Whatever ships, versions 1.0.0 through 1.0.9 stay on Nexus forever and customer
projects keep resolving them. There is no recall.

Two consequences worth deciding deliberately:

1. **`latest.release` is how the in-repo workspaces pin this.** A consumer that
   has not been touched in a year still picks up whatever we publish next. Under
   Option 2 that is safe. Under Option 1 it is safe only if `-compat` is
   published at the same coordinates, which is exactly why it must be.
2. **The learn.liferay.com samples are the migration schedule.** Whatever those
   files show is what customers will write for the next several years. They can
   move to the new style well before the deprecated types are removed, and
   updating them is the cheapest way to shift new projects without breaking old
   ones.

## Recommended Order On Compatibility Grounds Alone

1. **Option 2**, as a patch release. Zero source impact, provable. Removes the
   CVE re-export and the Boot 4 cliff.
2. **Option 1 + `-compat`**, as a major. Existing consumers change a version;
   new consumers get the clean API. Deprecation warnings are the migration
   prompt, and nothing forces a date.
3. **Update the learn samples** to the new style, so new projects start there.
4. **Option 3 or 4 later**, if at all. Option 3 changes nothing for consumers
   over Option 1 and can be done invisibly behind the same facade. Option 4
   cannot be reached without a rewrite, so it is only a destination if the
   answer to "should the library ship an HTTP client at all" is genuinely no.
