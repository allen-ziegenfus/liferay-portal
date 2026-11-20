/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot.autoconfigure;

import com.nimbusds.jose.JOSEObjectType;
import com.nimbusds.jose.proc.DefaultJOSEObjectTypeVerifier;

import java.util.Set;

import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.PropertyMapper;
import org.springframework.context.annotation.Bean;
import org.springframework.core.env.Environment;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.OAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2TokenValidatorResult;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtValidators;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;

/**
 * The residue: everything the property translation cannot express.
 *
 * <p>
 * There are exactly two things, and the size of this file is the argument for
 * the whole option. If the library is fifty lines, the questions of who owns
 * its CVEs, who maintains it and how it survives a Spring major version stop
 * being interesting.
 * </p>
 *
 * <ol>
 * <li><strong>The <code>at+jwt</code> type verifier.</strong> Liferay issues
 * RFC 9068 access tokens. Nimbus defaults to accepting <code>JWT</code> and
 * <code>null</code>, so <code>at+jwt</code> has to be declared or every token
 * Liferay issues is rejected.</li>
 * <li><strong>The <code>client_id</code> allowlist.</strong> A rule about which
 * OAuth applications may call this client extension. Not expressible as a
 * property, and worth shipping precisely because a customer writing it
 * themselves is writing security code.</li>
 * </ol>
 *
 * <p>
 * Note what this still delegates. The JWK set URI comes from the property the
 * post processor derived, and <code>withJwkSetUri</code> gives Spring Security
 * ownership of building the decoder and the standard validator chain via
 * {@link JwtValidators}. The current library hand builds a
 * <code>DefaultJWTProcessor</code> and a
 * <code>JWSAlgorithmFamilyJWSKeySelector</code> to arrive at the same place.
 * Both cache the remote key set, so the difference is how much machinery the
 * library owns and has to keep working, not a behavioral gap.
 * </p>
 *
 * <p>
 * What is NOT here, because the property translation covered it: JWK set URI
 * construction, the client registration repository, the authorized client
 * manager, the authorized client service, the token endpoint, the grant type
 * and the client authentication method. Those account for roughly 470 of the
 * current module's 1,100 lines.
 * </p>
 */
@AutoConfiguration
@ConditionalOnProperty(
	name = "spring.security.oauth2.resourceserver.jwt.jwk-set-uri"
)
public class LiferayJwtResidualAutoConfiguration {

	@Bean
	@ConditionalOnMissingBean
	public JwtDecoder jwtDecoder(Environment environment) {
		NimbusJwtDecoder nimbusJwtDecoder = NimbusJwtDecoder.withJwkSetUri(
			environment.getRequiredProperty(
				"spring.security.oauth2.resourceserver.jwt.jwk-set-uri")
		).jwtProcessorCustomizer(
			configurableJWTProcessor ->
				configurableJWTProcessor.setJWSTypeVerifier(
					new DefaultJOSEObjectTypeVerifier<>(
						new JOSEObjectType("at+jwt")))
		).build();

		nimbusJwtDecoder.setJwtValidator(
			_createOAuth2TokenValidator(environment));

		return nimbusJwtDecoder;
	}

	private OAuth2TokenValidator<Jwt> _createOAuth2TokenValidator(
		Environment environment) {

		Set<String> clientIds = LiferayClientIds.of(environment);

		OAuth2Error oAuth2Error = new OAuth2Error(
			"invalid_token", "The client_id does not match", null);

		OAuth2TokenValidator<Jwt> clientIdOAuth2TokenValidator =
			jwt -> {
				if (clientIds.contains(jwt.getClaimAsString("client_id"))) {
					return OAuth2TokenValidatorResult.success();
				}

				return OAuth2TokenValidatorResult.failure(oAuth2Error);
			};

		// Compose explicitly with the standard validators.
		//
		// The current library calls setJwtValidator with only its client_id
		// check wrapped in a DelegatingOAuth2TokenValidator, which replaces
		// Spring's default validator chain. That is not a hole today: it hand
		// builds a DefaultJWTProcessor, and Nimbus installs a
		// DefaultJWTClaimsVerifier that checks exp and nbf before Spring's
		// validator ever runs. It is however load bearing behavior resting on
		// a third party default that nothing asserts, and the single element
		// DelegatingOAuth2TokenValidator wrapper suggests the intent was to
		// compose rather than replace.

		return new org.springframework.security.oauth2.core.
			DelegatingOAuth2TokenValidator<>(
				JwtValidators.createDefault(), clientIdOAuth2TokenValidator);
	}

}
