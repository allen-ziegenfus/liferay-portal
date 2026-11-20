# Option 4: Translate To Properties, Don't Call APIs

The most version-agnostic option available, and the one with the smallest
maintained surface. Instead of calling Spring APIs, set Spring's **standard**
property keys and let Boot's own auto-configuration do the work.

The insight: property keys are a far more durable contract than Java method
signatures, and Spring treats them that way.
`spring.security.oauth2.resourceserver.jwt.jwk-set-uri` has meant the same thing
since Boot 2.1 and still does in 4.x. `HttpSecurity.cors().and()` did not survive
one major version.

## What The Post-Processor Emits

`LiferayEnvironmentPostProcessor` reads what Liferay Cloud injected and derives:

```
spring.security.oauth2.resourceserver.jwt.jwk-set-uri
spring.security.oauth2.client.registration.<erc>.authorization-grant-type
spring.security.oauth2.client.registration.<erc>.client-authentication-method
spring.security.oauth2.client.registration.<erc>.client-id
spring.security.oauth2.client.registration.<erc>.client-secret
spring.security.oauth2.client.registration.<erc>.provider
spring.security.oauth2.client.provider.<erc>.token-uri
```

Seven keys. Those replace, in the current library:

- the entire `jwtDecoder()` bean, minus the type verifier
- the entire `clientRegistrationRepository()` and `clientRegistrations()` beans
- `oAuth2AuthorizedClientService()`, `webClient()`,
  `authorizedClientServiceOAuth2AuthorizedClientManager()`
- `LiferayOAuth2AccessTokenManager` in full, because Spring Security's authorized
  client manager already caches and refreshes client-credentials tokens

Roughly 470 of the module's 1,100 lines, handed back to the framework that ships
it.

Registered through `META-INF/spring.factories`, which is still the mechanism for
`EnvironmentPostProcessor` in Boot 3 — it has to run before the context exists,
earlier than `AutoConfiguration.imports` is read.

**Precedence matters.** Derived values are added with `addLast`, so they sit
below every other property source. Anything the consumer writes in
`application.properties`, passes as a system property or sets in the environment
wins outright. That is the un-opinionated story in one method call: the library
supplies defaults it derived, and loses every argument about them.

## The Residue

`LiferayJwtResidualAutoConfiguration` is what cannot be a property. Exactly two
things:

1. **The `at+jwt` type verifier.** Liferay issues RFC 9068 access tokens; Nimbus
   defaults to `JWT` and `null`. Get this wrong and every token Liferay issues is
   rejected. This is the single most expensive fact in the library to rediscover
   from scratch. Applied through `withJwkSetUri(...).jwtProcessorCustomizer(...)`, so Spring
   Security keeps ownership of building the decoder and the standard validator
   chain. The current library hand-builds a `DefaultJWTProcessor` and a
   `JWSAlgorithmFamilyJWSKeySelector` to reach the same place. Both cache the
   remote key set, so this is about how much machinery is owned and has to be
   kept working, not a behavioral gap.
2. **The `client_id` allowlist.** A rule about which OAuth applications may call
   this client extension. Worth shipping precisely because a customer writing it
   themselves is writing security code.

That is the argument for the whole option: if the maintained library is fifty
lines, the questions of who owns its CVEs and how it survives a Spring major
version stop being interesting.

## The Honest Limitation

An `EnvironmentPostProcessor` runs before the application context exists, so it
cannot make a blocking HTTP call without stalling startup on a round trip to a
DXP that may not be up. The dynamic `/o/oauth2/application` fallback therefore is
not available here.

In practice Liferay Cloud injects `<erc>.oauth2.user.agent.client.id` for every
registered client extension, so the fallback matters in local development and
when a client extension is deployed before its OAuth application exists. If that
has to be supported, this option wants Option 3's small lazy lookup bean beside
it — which is a fair reason to treat 3 and 4 as complementary rather than
competing.

## Customer Impact

`customer-example/InventorySpringBootApplication.java` contains nothing Liferay,
and that is the deliverable. `StockLevelRestController` uses
`@RegisteredOAuth2AuthorizedClient("acme-erc")` — a Spring Security annotation
that works because the post-processor wrote that registration into the
environment.

Everything a customer needs in order to write it is Spring Security
documentation, not Liferay documentation. That is the real ease-of-use argument,
and it is the opposite of the one the current library makes.

`application.properties` records what they would have hand-written without the
library: seven lines. Worth keeping in view when deciding how much of the current
1,100 belongs in a maintained artifact.
