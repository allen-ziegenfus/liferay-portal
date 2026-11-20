# Should The Adapter Be Versioned In The Package Name?

**No.** And for Spring Boot 4 specifically, you do not need a separate adapter
module at all yet.

## First: The Boot 4 Adapter Is The Boot 3 Adapter

Option 3's core and adapter were compiled unmodified against both stacks, using
real jars from Maven Central. This result is surprising enough that it was
re-checked three ways — see "Why This Is Not Too Good To Be True" below:

| | Boot 3.5.14 / Security 6.5.10 / FW 6.2.19 | Boot 4.1.1 / Security 7.1.1 / FW 7.0.9 |
|---|---|---|
| `liferay-client-extension-core` | **COMPILES** | **COMPILES** |
| `liferay-client-extension-spring-boot-adapter` | **COMPILES** | **COMPILES** |

Nothing the adapter touches moved across the major boundary:

| What the adapter uses | Boot 3.5.14 | Boot 4.1.1 |
|---|---|---|
| `@AutoConfiguration` | `o.s.b.autoconfigure` | same |
| `@ConditionalOnProperty` / `OnMissingBean` / `OnClass` / `OnWebApplication` | `o.s.b.autoconfigure.condition` | same |
| `@EnableConfigurationProperties`, `@ConfigurationProperties` | `o.s.b.context.properties` | same |
| `META-INF/spring/...AutoConfiguration.imports` | same filename | same filename |
| Security filter chain | lambda DSL | lambda DSL — the only form in 7 |
| JSON | never named — `RestClient.toEntity(Map.class)` | same, works with Jackson 3 |

So there is no `-boot4-adapter` in this prototype, because it would be a copy of
the `-boot3` one with a different name. Writing it would recreate the exact
mistake the boot2/boot3 fork made.

## Why This Is Not Too Good To Be True

A clean pass across a framework major deserves suspicion. Three specific ways
the first result could have been wrong, and what each check found.

**1. `-nowarn` was hiding deprecations.** The first compile suppressed warnings,
so a type could exist but be deprecated-for-removal and look fine. Recompiled
with `-Xlint:deprecation,removal`: **no deprecation or removal warnings**, only
an unrelated unchecked-cast note.

**2. Source compatibility is not binary compatibility.** `javac` proves the
source compiles *against* Boot 4. A single published jar is compiled against the
floor and *runs* on Boot 4, which is a different property — a method whose
signature changed would pass both source compiles and fail at runtime with
`NoSuchMethodError`.

Checked properly: extracted all **59** distinct Spring method references from the
Boot-3-compiled bytecode and resolved each against the Boot 4 jars. First pass
reported 14 failures; all 14 were parser artifacts (constructors and inherited
methods), confirmed present by direct `javap` inspection with exact matching
descriptors — `NimbusJwtDecoder(JWTProcessor)`,
`InMemoryClientRegistrationRepository(List)`, `OAuth2Error(String,String,String)`,
`HttpEntity.getBody()`, `AbstractSecurityBuilder.build()`,
`AbstractHttpConfigurer.disable()`. **Real unresolved references: 0.**

Note that `jdeps --missing-deps` is the wrong tool here and was tried first: it
resolves class-level references only, so it cannot see a changed method
signature, and its negative control produced identical output to the positive
one.

**3. Classpath contamination.** Verified `lib4/` contains only Boot 4.1.1,
Security 7.1.1 and Framework 7.0.9 — no 3.x or 6.x Spring artifacts.

### Why nothing broke, mechanically

- Spring Security 7's removals were deprecations announced in 6.1, and they are
  concentrated in the `HttpSecurity` DSL. The one method that used them had
  already been rewritten in the lambda form.
- The adapter otherwise uses Spring's stable, semver-protected surface:
  `ClientRegistration`, `OAuth2AccessToken`, `NimbusJwtDecoder`, the
  `@ConditionalOn*` family.
- The three genuinely disruptive Boot 4 changes — Jackson 2 to 3, auto-config
  repackaging, and `spring.factories` key moves — were either never touched or
  had already been removed for other reasons.

**The strongest evidence that the test is real is that it failed somewhere.**
The same method found a genuine, silent break in Option 4: Boot 4 moved the
`EnvironmentPostProcessor` key and no longer scans the old one. A check that
passes everything proves nothing; this one did not pass everything.

### What Is Still Not Proven

**Runtime behavior.** Compiling and resolving references is not running. Not
covered here: auto-configuration ordering, conditional evaluation, Boot 4's
restructured starter modules, and whether the `.imports` file is actually read
and its classes instantiated in a live context.

Closing that gap is one Spring Boot 4 smoke application, and it is worth doing
before anyone acts on this. Everything above narrows where to look; it does not
replace running it.

Compare Option 4, where the same test found a **real** break: Boot 4 moved the
`EnvironmentPostProcessor` `spring.factories` key from
`org.springframework.boot.env.EnvironmentPostProcessor` to
`org.springframework.boot.EnvironmentPostProcessor`, and the old key is not
scanned. That is what a genuine fork trigger looks like — and notably it hit the
option that has no adapter layer to absorb it.

## Second: The Package Versioning Was Always Redundant

The boot2/boot3 split is usually described as "two packages". It was also two
artifacts, and that is the part everyone forgets:

```
com.liferay:com.liferay.client.extension.util.spring.boot2   (Bundle-SymbolicName ...boot2)
com.liferay:com.liferay.client.extension.util.spring.boot3   (Bundle-SymbolicName ...boot3)
```

**The coordinates were already distinct.** Both could be published, both could
sit in Nexus, and any workspace could pick either — entirely because of the
artifact id. The package rename added exactly one thing on top of that: it
forced all 198 import statements to change, for three lines of real API
difference.

Two separate artifacts never needed to coexist on one *classpath*. They are two
builds of one library for two runtimes, and no application is on both Spring
majors at once. Coexistence in the *repository* is an artifact-id problem, and
it was already solved.

It is also against house style. Liferay versions OSGi packages in the manifest
via `Export-Package`, not in the package name. So does Spring, Hibernate,
Micrometer and almost everything else. Jackson is the famous exception
(`com.fasterxml` → `tools.jackson`) and it did that once, for a total rewrite,
not per minor generation.

## The Rule

| Thing | Versioned? |
|---|---|
| Package name | **Never.** `com.liferay.client.extension.spring.boot` |
| Artifact id | Only if a fork actually becomes necessary |
| Artifact version | Always, normally |

There is also a middle option worth knowing about, because it sidesteps the
binary-compatibility question entirely: **one source tree, two published
artifacts**, each compiled against its own Spring generation. Source
compatibility is what has been verified above, and that is all this needs. It
costs one extra Gradle module with no `src/` of its own, and it removes the need
to prove that a single jar links correctly on both. If the smoke test in the
previous section turns up anything, this is the fallback that requires no code
changes.

If a fork is ever forced — Boot 6 removes something, say — publish
`...spring.boot.adapter` and `...spring.boot6.adapter` **at the same package**.
A consumer moving between them changes one line in `build.gradle` and zero
imports. That is the whole difference from last time.

## The Safety Property, Without The Cost

The one legitimate worry about two artifacts sharing a package is that both land
on one classpath and you get duplicate auto-configurations, resolved
arbitrarily. Versioning the package prevented that by accident.

Gradle capabilities prevent it on purpose, and it is four lines in the adapter's
`build.gradle`:

```groovy
["apiElements", "runtimeElements"].each { String name ->
	configurations.named(name) {
		outgoing {
			capability "com.liferay:liferay-client-extension-spring-boot-adapter:${project.version}"
		}
	}
}
```

Every adapter declares the same capability regardless of its artifact id. Two of
them on one graph fails the build with *"Cannot select module with conflict on
capability"* rather than silently picking one. Loud, at build time, with a
message that says what is wrong.

That is strictly better than the package rename: same protection, no consumer
edits, and it fails at the moment of the mistake rather than being prevented by
a convention nobody wrote down.

## What To Do Now

1. **Do not build a Boot 4 adapter.** The current one compiles against Boot 4
   today; adding a second is pure duplication.
2. **Add `testCompat41` to the matrix** — done, in the adapter's `build.gradle`
   alongside 3.2 and 3.5, wired into `check`. That converts "compiles on Boot 4"
   from a claim in this document into something the build re-checks forever.
3. **Add the capability declaration now**, while there is one adapter. It costs
   nothing today and it is the thing you will wish you had if a fork ever
   happens.
4. **Drop `boot3` from the package** in whatever ships. That is the change that
   makes all of the above possible, and it is a one-time coordinated edit rather
   than a recurring one.
