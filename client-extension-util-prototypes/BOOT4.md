# Can Any Of These Run 1:1 On Spring Boot 4?

Short answer: **yes for the security chain, verified by compiling it. For a
whole single-jar library, probably — and Option 3 is the only one where the
answer stops mattering.**

Spring Boot 4 is not hypothetical. **4.1.1** is current on Maven Central, on
Spring Security **7.1.1**.

## Verified, Not Argued

Compiled the shipping filter chain and the Option 2 rewrite against real jars
from Maven Central:

| | Security 6.5.10 / Framework 6.2.19 | Security 7.1.1 / Framework 7.0.9 |
|---|---|---|
| Shipping `securityFilterChain` | compiles | **fails** |
| Option 2 rewrite | compiles | **compiles** |

The failure is exactly the predicted one:

```
error: method cors in class HttpSecurity cannot be applied to given types;
  required: Customizer<CorsConfigurer<HttpSecurity>>
  found:    no arguments
```

**One source, both majors.** That is the single-codebase question answered
empirically for the piece that was going to break.

## Three Different Things "Single Codebase" Can Mean

Worth separating, because the options score differently on each.

| | Meaning | Who gets it |
|---|---|---|
| **A** | One source tree that compiles for both | Any option, if it only uses intersection APIs |
| **B** | One published jar that runs on both | A, plus binary compatibility |
| **C** | One body of Liferay knowledge, never duplicated | **Option 3, unconditionally** |

The boot2/boot3 fork failed at **C**, which is why it cost 1,100 duplicated
lines to absorb three lines of change. A and B are nice; C is the one that
actually caused the pain.

## What Would Break A Single Jar, And Where It Stands

Audited across all four prototypes.

**1. Non-lambda Security DSL** — the known blocker. Fixed and verified above.
Zero occurrences remain anywhere.

**2. Repackaged auto-configuration classes.** Boot 4 moved auto-config classes
out of `org.springframework.boot.autoconfigure.*` into per-module packages.
Referencing one by name — typically in `@AutoConfiguration(before = ...)` — is a
break.

```bash
grep -rn "org.springframework.boot.autoconfigure\.[a-z]" --include=*.java .
# (no output)
```

**Zero references across all four prototypes.** An earlier draft of Option 4 had
one, `OAuth2ResourceServerAutoConfiguration`, which came out when that class was
rewritten for unrelated reasons. Worth adding as a lint rule regardless of which
option ships.

**3. Jackson 2 to Jackson 3.** This is the one that was actually still broken.
Boot 4 auto-configures `tools.jackson.databind.ObjectMapper`, not
`com.fasterxml.jackson.databind.ObjectMapper`, so a bean injecting the latter
simply stops resolving.

Option 3's adapter was doing exactly that. Now fixed, and the fix is instructive:
the lookup is built on `RestClient` and calls `toEntity(Map.class)`, so
deserialization runs through whatever message converters the application
configured. The same source works on Jackson 2 and Jackson 3 because **it names
neither**. The compat shim's `LiferayOAuth2Util` had the same problem via
`@JsonIgnoreProperties` and got the same treatment.

```bash
grep -rn "^import com.fasterxml\|fasterxml.*version" --include=*.java --include=build.gradle .
# (no output)
```

No prototype now names a Jackson type or declares a Jackson dependency.

**4. `spring.factories` — VERIFIED BROKEN for Option 4.**

Checked against the released `spring-boot-4.1.1.jar`. `spring.factories` still
exists in Boot 4, but the `EnvironmentPostProcessor` key **moved package**:

| | Interface | `spring.factories` key |
|---|---|---|
| Boot 3.5.14 | `org.springframework.boot.env.EnvironmentPostProcessor` (only one that exists) | `org.springframework.boot.env.EnvironmentPostProcessor` |
| Boot 4.1.1 | `org.springframework.boot.EnvironmentPostProcessor` (new) — the `env` one still exists but is **`@Deprecated`** | `org.springframework.boot.EnvironmentPostProcessor` |

And Boot 4's loader reads only the new one:

```
javap -p -c org.springframework.boot.support.EnvironmentPostProcessorApplicationListener
  ldc  #101   // class org/springframework/boot/EnvironmentPostProcessor
```

No class anywhere in `spring-boot-4.1.1.jar` carries the legacy FQN as a string
constant, so there is no back-compat scan of the old key.

**The failure mode is silent.** On Boot 4 the post-processor is simply never
invoked. No error, no warning — the seven derived properties just are not there,
and the application fails later and obscurely, with a resource server that has
no `jwk-set-uri`. That is materially worse than a compile error.

Registering under both keys does not obviously fix it either: the class has to
*implement* whichever interface the loader instantiates, and
`org.springframework.boot.EnvironmentPostProcessor` does not exist on Boot 3, so
it cannot be implemented from a source set compiled against a 3.x floor.

**Conclusion: Option 4 cannot be a single jar spanning Boot 3 and Boot 4**
without a multi-release jar, reflection, or two artifacts. Option 4's headline —
"the most version-agnostic by construction" — turns out to be true of its
*property keys* and false of its *registration mechanism*. That is worth
correcting in the approaches page.

Method note: this is verified by inspecting the released jar's bytecode and
resources, not by running a Boot 4 application. A runtime test would make it
airtight.

**5. Java baseline.** Boot 4 requires Java 17. The module already targets 17.
Not an issue.

## Per-Option Verdict

**Option 2 — closest to a single jar today.** The one blocking API is fixed and
verified on both majors. Nothing else in the module touches anything that moved:
no auto-config class references, no Jackson, no `javax`, no
`WebSecurityConfigurerAdapter`. The remaining API surface — `WebClient`,
`ClientRegistration`, `NimbusJwtDecoder`, `@Value`, `Environment` — is stable
across the boundary.

So the honest claim is "very likely one jar for 3.1 through 4.x", and the patch
now includes a **`testCompat40`** task alongside 31/33/35, wired into `check`.
That converts the claim into something the build asserts on every run. Expect it
to be the first row to fail, which is the reason to have it.

**Option 1 — same, plus a dependency on auto-config infrastructure.**
`@AutoConfiguration`, `@ConditionalOnProperty`, `@ConditionalOnMissingBean` and
the `AutoConfiguration.imports` file are the most stable parts of Boot's
extension model, and the prototype references no repackaged auto-config class.
Likely 1:1; same `testCompat40` answers it.

**Option 3 — the only one where the question dissolves.** Core has no Spring on
its classpath, so "is it Boot 4 compatible" is not a meaningful question about
it. It cannot break, because there is nothing to break against.

That matters more than it first sounds. Options 1, 2 and 4 are betting that a
single jar keeps working, and that bet has to be re-won at every Spring major
forever. Option 3 does not take the bet. If the adapter ever cannot span both,
you ship `-adapter-boot3` and `-adapter-boot4` **over one unchanged core** — and
what you duplicate is 412 lines of wiring, not the Liferay conventions. Compare
the actual boot2/boot3 fork: 1,100 lines duplicated, of which the conventions
were the overwhelming majority and the wiring was three lines.

**Option 4 — most durable contract, and the only one with a verified single-jar
blocker.** The property keys it emits are as version-proof as anything gets:
`spring.security.oauth2.resourceserver.jwt.jwk-set-uri` has been stable since
Boot 2.1 and carries into 4.x. The residual `JwtDecoder` uses
`NimbusJwtDecoder.withJwkSetUri(...).jwtProcessorCustomizer(...)`, also stable.

But its *delivery mechanism* is the one thing here that provably does not span
both majors, per the finding above — and it fails silently. Ironically the
option that leans hardest on stable contracts is the one that breaks, because it
depends on Boot's own extension registry rather than on Java API.

If Option 4 is the destination, budget for two artifacts or a multi-release jar,
and treat the single-codebase question as answered "no" rather than open.

## So: Limited Update Area, Or Single Codebase?

Both, and they are different wins.

**The update area shrank to almost nothing.** The Boot 3 to 4 move for this
library is one method, verified. That alone is worth doing this week — it is a
150-line patch and it retires a known cliff.

**A single codebase for 3.x and 4.x looks achievable**, and after this pass
there is no known blocker in any prototype. But it is a property that has to be
maintained rather than achieved: every future change can reintroduce a
version-bound API without anyone noticing, which is what `testCompat40` is for.

**The distinction that actually matters** is C. Options 1, 2 and 4 give a single
codebase *as long as the bet holds*. Option 3 makes losing the bet cheap, by
ensuring that the thing you would have to duplicate is the part that does not
carry any Liferay knowledge. Given that the last time this bet was lost it cost
two parallel libraries for three lines of API change, that is worth pricing
honestly.

## Reproducing All Of This

```bash
# 1. The security chain, both majors
#    (fetch spring-security-config/web/core/oauth2-* and spring-core/beans/context/web
#     at 6.5.10/6.2.19 and 7.1.1/7.0.9, then compile the two variants)
javac -cp "$SEC6_JARS" Before.java   # compiles
javac -cp "$SEC7_JARS" Before.java   # FAILS: cors() requires a Customizer
javac -cp "$SEC6_JARS" After.java    # compiles
javac -cp "$SEC7_JARS" After.java    # compiles

# 2. The EnvironmentPostProcessor key move
curl -sL https://repo1.maven.org/maven2/org/springframework/boot/spring-boot/4.1.1/spring-boot-4.1.1.jar -o sb41.jar
unzip -p sb41.jar META-INF/spring.factories | grep EnvironmentPostProcessor
javap -p -c -cp sb41.jar \
  org.springframework.boot.support.EnvironmentPostProcessorApplicationListener | grep ldc
```

## Summary Of Verified Facts

| Claim | Status |
|---|---|
| Shipping filter chain fails on Spring Security 7 | **verified by compilation** |
| Option 2 rewrite compiles on both 6.5.10 and 7.1.1 | **verified by compilation** |
| No prototype references a repackaged auto-config class | **verified by grep** |
| No prototype names a Jackson type or declares Jackson | **verified by grep** (after fixes) |
| Boot 4 moved the `EnvironmentPostProcessor` key, breaking Option 4's registration silently | **verified by jar inspection** |
| Options 1/2/3 are otherwise single-jar capable across 3.1–4.x | **plausible, not proven** — that is what `testCompat40` is for |
