# Client Extension Util: Four Prototypes

Design spikes for LPD-98098 follow-up work. Each directory is a different answer
to the same two questions: how much opinion should this library hold, and how
much Spring should it be bound to.

Nothing here is wired into the build. They sit at the repo root rather than
under `modules/util/` on purpose: `LiferaySettingsPlugin` walks `modules/` and
turns any directory containing `bnd.bnd`, `build.xml` **or**
`src/main/resources/application.properties` into a Gradle project, and the
sample customer applications need that last one.

## The Evidence These Are Responding To

`client-extension-util-spring-boot2` was removed in `0731cc47da3d0`. Diffing it
against `client-extension-util-spring-boot3` with the package name normalized
gives the real cost of a Spring major version to this library:

| Class | boot2 LOC | Real API changes |
|---|---:|---:|
| `LiferayOAuth2ClientConfiguration` | 278 | **0** |
| `BaseService` | 412 | 2 |
| `LiferayOAuth2ResourceServerEnableWebSecurity` | 188 | **1** |
| `LiferayOAuth2AccessTokenManager` | 160 | **0** |
| `LiferayOAuth2Util` | 148 | **0** |
| `LiferayWebMvcConfigurer` | 51 | **0** |
| `BaseRestController` | 16 | **0** |

Three lines: `antMatchers` to `requestMatchers`, and `HttpStatus` to
`HttpStatusCode`. Two libraries of about 1,100 lines each, maintained in
parallel, to absorb three lines. `javax` to `jakarta` never touched it, because
no class here names a servlet type in a signature.

Reproduce it with:

```bash
git show 0731cc47da3d0^:modules/util/client-extension-util-spring-boot2/src/main/java/com/liferay/client/extension/util/spring/boot2/client/LiferayOAuth2ClientConfiguration.java \
	| sed 's/spring\.boot2/spring.boot3/g' \
	| diff - modules/util/client-extension-util-spring-boot3/src/main/java/com/liferay/client/extension/util/spring/boot3/client/LiferayOAuth2ClientConfiguration.java
```

The conclusion the four options share: the version coupling is **packaging, not
code**. Putting `boot2` / `boot3` in the *package name* is what forced a fork
and a mass edit across every consumer even where zero lines needed to change.

## The Four

| | Directory | Idea | New artifacts | Consumer migration | Survives Boot 4 |
|---|---|---|---|---:|---|
| 1 | `1-spring-autoconfiguration/` | Auto-config, injected client, deprecate `BaseService`, split `-starter` | 3 | none required | yes, after the filter chain rewrite |
| 2 | `2-compile-low-provided/` | Change the build file and one method. Nothing else. | 1 | none | yes |
| 3 | `3-pure-java-core/` | Zero-Spring core, ~200-line adapter per framework generation | 2 | none required | new adapter, core untouched |
| 4 | `4-property-translation/` | Emit standard `spring.security.oauth2.*` keys instead of calling Spring APIs | 1 | opt-in rewrite | yes, by construction |

Line counts, for scale against the current module's **1,271** lines of main
source:

Non-comment, non-blank lines of library source, measured the same way across all
of them. The current module is **961**.

| | Prototype | Spring-bound | Spring-free | Total |
|---|---|---:|---:|---:|
| 1 | `1-spring-autoconfiguration` | 788 + shim | 0 | 969 |
| 2 | `2-compile-low-provided` | 961 (unchanged) | 0 | 961 |
| 3 | `3-pure-java-core` | 412 | 312 | 724 |
| 4 | `4-property-translation` | 161 | 0 | 161 |

Two caveats worth reading before using these numbers in an argument. Option 1's
`-compat` (the shim) is transitional and deletable once the 653 subclasses migrate, and
its `-core` is larger than today partly because it adds typed
`@ConfigurationProperties` — more lines in exchange for every opinion becoming a
switch. Option 4's 161 is small because it hands ~470 lines back to Spring Boot,
not because it does less; it also provides no HTTP client at all.

## Customer Examples

Every option carries a `customer-example/` showing the same fictional
`acme-inventory` client extension, so the four can be diffed against each other:

| | Application class | Controller | `application.properties` |
|---|---|---|---|
| 1 | `@Import` deleted | constructor-injected `LiferayRestClient`, returns `ResponseEntity`, plus a plain unit test | every opinion switchable |
| 2 | **unchanged** | **unchanged**, still `extends BaseRestController` | **unchanged** |
| 3 | `@Import` deleted | a `CommandLineRunner` using the Spring-free core beans | one switch for the whole adapter |
| 4 | no Liferay import at all | stock `@RegisteredOAuth2AuthorizedClient` | empty, with the seven hand-written lines it replaces recorded in comments |

Option 2's example is deliberately identical to what ships today. That is its
whole consumer-facing story: it changes the build file and one method inside the
library, and asks nobody to migrate anything.

## A Real Sample, Migrated

`migrated-sample/` takes `ObjectAction2RestController` from
`liferay-sample-workspace` — the canonical sample, JWT-secured inbound and
PATCHing back to `headless-admin-user` outbound — and shows it under all four,
alongside a verbatim `0-today/` copy. That is where to look for what actually
changes at the call site, and it is where two live bugs in the shipping sample
turned up.

## They Compose

These are not four competing proposals. Sequenced, they are one:

1. **Option 2 first.** Build file plus one method. No new artifacts, no renames,
   no consumer migration, and it removes both the CVE treadmill and the Boot 4
   cliff. Highest value per unit of review argument.
2. **Option 1 next.** Auto-config makes each piece opt-out; the injected client
   removes the inheritance coupling; the deprecated bridge means none of the 653
   subclasses move in the same commit.
3. **Option 3 or 4 as the destination.** Option 3 if the dynamic
   `/o/oauth2/application` lookup must be supported and other frameworks may
   need adapters. Option 4 if the goal is the smallest maintained surface, since
   it deletes roughly 470 lines by handing the work back to Spring Boot.

Options 3 and 4 are complementary rather than exclusive: Option 4's honest
limitation is that an `EnvironmentPostProcessor` cannot make a blocking HTTP
call, so the dynamic client-ID lookup has to come from Option 3's lazy bean.

## Naming

Every prototype drops `boot3` from the package. Encoding the framework version
in the package name is what made the boot2/boot3 duplication unavoidable, and it
guarantees the same mass edit at the next major bump. The framework generation
belongs in the artifact version, and in Option 3 in the artifact *name* of the
adapter only.

Two renames appear throughout:

- `BaseService` is not a service. It is an HTTP client, and it became a
  superclass only because its methods were `protected`, which made inheritance
  the sole way to reach them. It is `LiferayRestClient` here, injected.
- `BaseRestController` is gone. It defined no endpoints; it was an abstract
  class carrying `@RestController` so that subclasses silently became beans,
  while also inheriting twenty-four outbound HTTP methods into their scope.
