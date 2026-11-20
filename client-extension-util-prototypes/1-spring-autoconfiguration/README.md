# Option 1: Spring Auto-Configuration

Keeps the library Spring-native and fixes the thing that makes it feel
opinionated. The cause is specific: `@ComponentScan` marker classes are
all-or-nothing and unconditional. Spring Boot's answer to "opinionated but
overridable" is auto-configuration, and this library never used it.

## Layout

```
liferay-client-extension-spring-boot-core/      no Spring declared, all compileOnly
liferay-client-extension-spring-boot-starter/   build file only, declares the starters
liferay-client-extension-spring-boot-compat/    all 6 legacy types, ORIGINAL package
customer-example/                               before/after, plus a unit test
```

## The Five Changes

**1. Auto-configuration instead of `@ComponentScan`.**
`META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports`
lists four independent configurations, each `@ConditionalOnProperty(matchIfMissing = true)`
and `@ConditionalOnMissingBean`. This deletes `@Import(ClientExtensionUtilSpringBootComponentScan.class)`
from all 26 in-repo consumers and makes every piece individually switchable —
the "different little libraries" idea without the artifacts, the releng entries,
the `modules.properties` lines or the version matrix.

`@ConditionalOnMissingBean` is what removes the need for escape hatches. The
current `LiferayOAuth2ClientConfiguration` carries two
`@Autowired(required = false) @Qualifier("extra")` injection points, which is
the shape a library takes when it is too opinionated and users needed a way out.
It also marks its `ClientRegistrationRepository` `@Primary`, which means a
consumer cannot override it even by declaring their own bean.

**2. `LiferayRestClient`, injected.**
`BaseService`'s twenty-four HTTP methods are `protected`, so inheritance was the
only way to reach them. That is inheritance used as dependency injection, and it
is why 653 files in this repo extend it. As a bean:

- The status code and headers survive, in a `ResponseEntity`. A 404 from an
  object endpoint is a real answer rather than an exception you catch to read the
  status back off.
- A 204 stays a 204 instead of becoming the string `"{}"`.
- The connection pool is built **once**. `BaseService._getWebClient()` constructs
  a new `WebClient` and a new 500-connection `ConnectionProvider` with background
  eviction on *every single request*.
- Backed by `RestClient`, not `WebClient`, so an MVC client extension no longer
  ships Reactor Netty in order to call `block()` on it. `LiferayWebClient` is
  still there, `@ConditionalOnClass`, for consumers who actually want reactive.

**3. `BaseService` stays, deprecated.**
`legacy/BaseService.java` reproduces the old surface exactly — all twenty
overloads, the `Disposable` async variants, the three `log(Jwt, ...)` methods,
the `protected` `lxcDXP*` fields, and the 204-to-`"{}"` body contract. None of
the 653 subclasses change. Delegating to the shared client fixes the pool leak
for all of them for free.

It lives in its own artifact because the legacy opinions are what require
webflux, `org.json` and `WebClientResponseException`. Packaging them with the
legacy API is what lets `-core` drop all three.

**4. Starters are `compileOnly`; a `-starter` artifact declares them.**
Today all four starters are `api`, so the library's classpath *is* every
consumer's classpath — which is why a 3.5.12 to 3.5.14 CVE bump is a coordinated
event across 26 workspaces and every customer, and why the library shows up in
advisories for code it does not contain. `-core` compiles against **3.2.12**, the
floor, not the ceiling; see Option 2 for why that direction matters.

**5. CORS behind a property; `BaseRestController` deleted.**
CORS is `liferay.client.extension.cors.enabled`, with the allowed headers and
methods as properties rather than constants in the jar.
`BaseRestController` had no content other than `@RestController` — an annotation
inherited onto every subclass, silently making it a bean.

## Also Fixed In Passing

- `LiferayOAuth2ResourceServerAutoConfiguration` writes the filter chain in the
  lambda DSL. The current `cors().and().csrf().disable()` form was deprecated in
  Spring Security 6.1 and removed in 7, which is what Boot 4 ships. That one
  method is the library's whole Boot 4 blast radius.
- A missing `liferay.oauth.application.external.reference.codes` no longer
  throws. Two classes currently throw `IllegalArgumentException` for it, so an
  inbound-only client extension cannot import the component scan at all without
  inventing a value.
- `LiferayClientIdOAuth2TokenValidator` re-resolves on a cache miss. The current
  validator seeds a map with every external reference code and then refreshes
  misses with `computeIfAbsent`, which can never fire because the key is always
  present — so a client ID that changes after startup is rejected until restart.
- `LiferayOAuth2AccessTokenManager` is no longer `@Configuration`. It is a
  stateful collaborator, not a source of bean definitions. Its `getAuthorization`
  also no longer makes three separate cache lookups to build one header value,
  each able to trigger its own refresh.

## Customer Impact

`customer-example/` shows the whole diff on the consumer side: delete one
`@Import`, and `extends BaseRestController` becomes constructor injection.
`StockLevelRestControllerTest` is the point — a controller extending
`BaseRestController` could not be unit tested at all, because the HTTP call was a
`protected` method on a superclass that built its own client from `@Value`
fields. There was no seam. Now the seam is the constructor.
