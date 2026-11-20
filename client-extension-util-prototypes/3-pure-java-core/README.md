# Option 3: Pure-Java Core, Thin Adapter

Push everything that is *Liferay knowledge* into a jar with no Spring on its
classpath, and keep the Spring-bound surface small enough that a framework
generation costs one file instead of one library.

```
liferay-client-extension-core/                  zero runtime dependencies, 312 code lines
liferay-client-extension-spring-boot-adapter/   all the Spring, 412 code lines
```

Counts are non-comment, non-blank lines, measured the same way for the current
module (961) so they compare.

Verify the claim:

```bash
grep -rn "springframework\|reactor\|org.json" \
	liferay-client-extension-core/src/main/java/
# (no output)
```

## Why This Is The Structural Answer

`LiferayOAuth2ClientConfiguration` is 278 lines and needed **zero** changes across
Spring Boot 2 to 3. That is not luck. Almost all of it is string manipulation of
Liferay property names, with a `ClientRegistration.Builder` at the end. The
Spring-bound part was always tiny; it was just spread through 278 lines of
Liferay-specific logic so that nothing could be separated, tested, or reused.

This option makes the split explicit. Core holds:

| Class | What it knows |
|---|---|
| `LiferayProperties` | The one seam to any configuration source |
| `LiferayDXPConnection` | `com.liferay.lxc.dxp.*` and how to build a base URI from it |
| `LiferayOAuth2Applications` | `<erc>.oauth2.headless.server.client.{id,secret}`, `<erc>.oauth2.user.agent.client.id`, `<erc>.oauth2.token.uri` |
| `LiferayOAuth2ApplicationLookup` | `GET /o/oauth2/application?externalReferenceCode=` |
| `LiferayJwtRules` | `/o/oauth2/jwks`, `at+jwt`, the `client_id` allowlist |
| `AccessTokenCache` | Refresh a minute before expiry |

That is the whole of what a customer could not write themselves in an afternoon.

## Zero Runtime Dependencies, Literally

- HTTP is `java.net.http.HttpClient`, in the JDK since 11. The current
  `LiferayOAuth2Util` calls `WebClient.create(baseURL)` per invocation, dragging
  Spring WebFlux and Reactor Netty into every consumer's dependency graph in
  order to make one unauthenticated GET.
- JSON parsing is injected as a `Function<String, Map<String, String>>`. The
  adapter passes Jackson, which every Spring Boot web app already has; a test
  passes a lambda. Core never picks a JSON library for anyone.
- Logging is `java.util.logging`, so the jar does not choose a logging facade
  for the consumer either.

Three consequences worth stating plainly:

1. This artifact can never appear in a Spring CVE advisory.
2. Its version does not have to move when Spring's does.
3. Its tests need a JUnit jar and nothing else — so they cannot be broken by the
   repo-wide test dependency injection. **That is exactly what killed the boot2
   module.** Its own removal commit says so: *"The module's unit tests cannot pass
   on master, where the repo-wide test dependency injection forces Spring 6 and
   Mockito 5 onto it."* A core with no Spring in it is structurally immune to
   that failure.

## What Testing Looks Like

`LiferayOAuth2ApplicationsTest` asserts the property conventions against a
`Map.of(...)`. No Spring context, no `mockserver-netty`, no Mockito, no
`.properties` file on the test classpath.

Compare `LiferayOAuth2ClientConfigurationDefaultTest`: 237 lines booting a
`@SpringBootTest` with an accompanying properties file, needing
`mockserver-netty`, `mockito-core`, `spring-test` and
`spring-boot-test-autoconfigure`, plus a `configurations.all { exclude ... }`
block in `build.gradle` to keep the portal's Spring off its classpath.

`AccessTokenCacheTest` asserts the 60-second refresh window against a
`Clock.fixed`. There is no test for that behavior anywhere in the current module,
because `LiferayOAuth2AccessTokenManager` calls `Instant.now()` inline — you
would have had to wait for real time to pass.

## What Does NOT Go In The Core

This is the question the split has to answer honestly, because the core is not
where most of the work ends up.

**Anything whose value *is* a Spring type stays in the adapter.** A
`SecurityFilterChain` is not a fact about Liferay that happens to be written in
Spring — it *is* Spring, and there is nothing to extract. The same goes for
`WebMvcConfigurer`, `ClientRegistrationRepository`, `JwtDecoder`, and an HTTP
client that returns `ResponseEntity` and is built from the consumer's configured
`RestClient.Builder`. Pushing those into a dependency-free core would mean
inventing a parallel request/response model and translating it: more code, worse
ergonomics, no gain.

So the adapter is four configurations, not one:

| File | Code lines | Holds |
|---|---:|---|
| `LiferayCoreAutoConfiguration` | 149 | `JwtDecoder`, `ClientRegistrationRepository`, core bean wiring |
| `LiferayClientAutoConfiguration` | 106 | Authorized client manager, token cache wiring, `LiferayRestClient` |
| `LiferaySecurityAutoConfiguration` | 79 | `SecurityFilterChain` (lambda DSL) + CORS |
| `LiferayRestClient` | 78 | The `BaseService` replacement |

**412 lines of Spring, not 215.** An earlier draft of this README undercounted by
omitting the filter chain, CORS, the outbound client and the token-manager
wiring — all of which the current library provides and all of which a consumer
would notice missing immediately.

The filter chain in particular is load bearing. Declaring a `JwtDecoder` and
nothing else leaves Spring Boot's `OAuth2ResourceServerJwtConfiguration` to
supply a default chain, which authenticates every request but leaves CSRF
enabled and sessions creatable. For a stateless bearer-token API that means
POST, PUT and DELETE start returning 403.

## What The Core Buys, Then

Not "almost no Spring code". The honest claim is narrower and still worth having:

- **312 lines carry every Liferay-specific decision, and zero of them import
  Spring.** The property conventions, the endpoints, the `at+jwt` fact, the
  `client_id` rule, the refresh window. A framework port cannot get any of them
  wrong, because it does not touch them.
- **The 412 Spring lines are all mechanism.** Porting them to Boot 5 is a
  rewrite of wiring against a changed API, which is a bounded, mechanical job.
  Porting boot2 to boot3 meant re-transcribing 1,100 lines in which the
  conventions and the wiring were interleaved.
- **The split makes the policy testable.** `AccessTokenCache` knows *refresh a
  minute before expiry* without knowing what a token is; the adapter supplies
  how to acquire an `OAuth2AccessToken` and how to read its expiry. That is why
  a `Clock.fixed` test is possible here and impossible in the 160-line
  `LiferayOAuth2AccessTokenManager` where the three concerns are fused.

Where the line falls is visible in one pair: **CORS policy is core**
(`LiferayDXPConnection.getCorsAllowedOrigins()` knows the origins are the
`com.liferay.lxc.dxp.domains` list crossed with http and https); **CORS
mechanism is adapter** (`WebMvcConfigurer`). Policy up, mechanism down.

## The Adapter Seam

`liferayProperties(Environment)` is the whole configuration seam:

```java
return LiferayProperties.from(environment::getProperty);
```

When Boot 5 lands, the four adapter files are what get rewritten. Core is
untouched. One adapter per framework generation, forever, instead of one copy of
the library per framework generation — which is precisely the trade that produced
boot2 and boot3.

It also opens a door the current design cannot: a Quarkus or Micronaut client
extension becomes a second adapter over the same core, rather than a third
transcription of the Liferay conventions.
