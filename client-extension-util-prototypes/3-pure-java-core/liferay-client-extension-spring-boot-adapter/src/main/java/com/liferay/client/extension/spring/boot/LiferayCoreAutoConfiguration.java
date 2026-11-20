/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot;

import com.liferay.client.extension.core.LiferayDXPConnection;
import com.liferay.client.extension.core.LiferayJwtRules;
import com.liferay.client.extension.core.LiferayOAuth2Application;
import com.liferay.client.extension.core.LiferayOAuth2ApplicationLookup;
import com.liferay.client.extension.core.LiferayOAuth2Applications;
import com.liferay.client.extension.core.LiferayProperties;

import com.nimbusds.jose.JOSEObjectType;
import com.nimbusds.jose.proc.DefaultJOSEObjectTypeVerifier;
import com.nimbusds.jose.proc.JWSAlgorithmFamilyJWSKeySelector;
import com.nimbusds.jose.proc.SecurityContext;
import com.nimbusds.jwt.proc.DefaultJWTProcessor;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.core.env.Environment;
import org.springframework.web.client.RestClient;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository;
import org.springframework.security.oauth2.core.AuthorizationGrantType;
import org.springframework.security.oauth2.core.ClientAuthenticationMethod;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.OAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2TokenValidatorResult;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;

/**
 * The entire Spring-specific surface of the library.
 *
 * <p>
 * Every method here is a translation, not a decision. The decisions live in
 * <code>liferay-client-extension-core</code>, which has no Spring on its
 * classpath at all.
 * </p>
 *
 * <p>
 * This is what makes the option worth the split. When the boot2 module was
 * deleted, the real API delta between it and boot3 across 1,100 duplicated
 * lines was three lines: <code>antMatchers</code> to
 * <code>requestMatchers</code>, and <code>HttpStatus</code> to
 * <code>HttpStatusCode</code>. Under this layout those three lines are all in
 * this file and its sibling, so a Spring Boot 5 adapter is a new file of about
 * this size rather than a second copy of the library.
 * </p>
 */
@AutoConfiguration
@ConditionalOnProperty(
	name = "liferay.client.extension.enabled", matchIfMissing = true
)
public class LiferayCoreAutoConfiguration {

	@Bean
	@ConditionalOnMissingBean
	public ClientRegistrationRepository clientRegistrationRepository(
		LiferayOAuth2Applications liferayOAuth2Applications) {

		List<ClientRegistration> clientRegistrations = new ArrayList<>();

		for (LiferayOAuth2Application liferayOAuth2Application :
				liferayOAuth2Applications.list()) {

			if (!liferayOAuth2Application.hasClientCredentials()) {
				continue;
			}

			clientRegistrations.add(
				ClientRegistration.withRegistrationId(
					liferayOAuth2Application.externalReferenceCode()
				).authorizationGrantType(
					AuthorizationGrantType.CLIENT_CREDENTIALS
				).clientAuthenticationMethod(
					ClientAuthenticationMethod.CLIENT_SECRET_POST
				).clientId(
					liferayOAuth2Application.headlessServerClientId()
				).clientSecret(
					liferayOAuth2Application.headlessServerClientSecret()
				).tokenUri(
					String.valueOf(liferayOAuth2Application.tokenURI())
				).build());
		}

		return new InMemoryClientRegistrationRepository(clientRegistrations);
	}

	@Bean
	@ConditionalOnMissingBean
	public JwtDecoder jwtDecoder(LiferayJwtRules liferayJwtRules)
		throws Exception {

		DefaultJWTProcessor<SecurityContext> defaultJWTProcessor =
			new DefaultJWTProcessor<>();

		defaultJWTProcessor.setJWSKeySelector(
			JWSAlgorithmFamilyJWSKeySelector.fromJWKSetURL(
				liferayJwtRules.getJWKSetURI().toURL()));
		defaultJWTProcessor.setJWSTypeVerifier(
			new DefaultJOSEObjectTypeVerifier<>(
				new JOSEObjectType(LiferayJwtRules.JOSE_OBJECT_TYPE)));

		NimbusJwtDecoder nimbusJwtDecoder = new NimbusJwtDecoder(
			defaultJWTProcessor);

		nimbusJwtDecoder.setJwtValidator(
			_toOAuth2TokenValidator(liferayJwtRules));

		return nimbusJwtDecoder;
	}

	@Bean
	@ConditionalOnMissingBean
	public LiferayDXPConnection liferayDXPConnection(
		LiferayProperties liferayProperties) {

		return new LiferayDXPConnection(liferayProperties);
	}

	@Bean
	@ConditionalOnMissingBean
	public LiferayJwtRules liferayJwtRules(
		LiferayDXPConnection liferayDXPConnection,
		LiferayOAuth2Applications liferayOAuth2Applications) {

		return new LiferayJwtRules(
			liferayDXPConnection, liferayOAuth2Applications);
	}

	/**
	 * Deliberately built on <code>RestClient</code> rather than on the core's
	 * JDK implementation, and deliberately naming no JSON type.
	 *
	 * <p>
	 * <code>toEntity(Map.class)</code> is deserialized by whichever message
	 * converters the application configured, so this same source works against
	 * Jackson 2 on Spring Boot 3 and Jackson 3 on Spring Boot 4. An earlier
	 * draft injected a <code>com.fasterxml.jackson.databind.ObjectMapper</code>
	 * here, which would simply fail to resolve on Boot 4, where the
	 * auto-configured mapper is <code>tools.jackson.databind.ObjectMapper</code>.
	 * </p>
	 */
	@Bean
	@ConditionalOnMissingBean
	public LiferayOAuth2ApplicationLookup liferayOAuth2ApplicationLookup(
		LiferayDXPConnection liferayDXPConnection,
		RestClient.Builder restClientBuilder) {

		RestClient restClient = restClientBuilder.build();

		return externalReferenceCode -> {
			try {
				ResponseEntity<Map> responseEntity = restClient.get(
				).uri(
					liferayDXPConnection.resolve(
						"/o/oauth2/application?externalReferenceCode=" +
							externalReferenceCode)
				).retrieve(
				).toEntity(
					Map.class
				);

				return responseEntity.getBody();
			}
			catch (Exception exception) {
				return null;
			}
		};
	}

	@Bean
	@ConditionalOnMissingBean
	public LiferayOAuth2Applications liferayOAuth2Applications(
		LiferayDXPConnection liferayDXPConnection,
		LiferayOAuth2ApplicationLookup liferayOAuth2ApplicationLookup,
		LiferayProperties liferayProperties) {

		return new LiferayOAuth2Applications(
			liferayDXPConnection, liferayProperties,
			liferayOAuth2ApplicationLookup);
	}

	/**
	 * The whole adapter, in one line. Spring's Environment satisfies the core's
	 * only configuration seam directly.
	 */
	@Bean
	@ConditionalOnMissingBean
	public LiferayProperties liferayProperties(Environment environment) {
		return LiferayProperties.from(environment::getProperty);
	}

	private OAuth2TokenValidator<Jwt> _toOAuth2TokenValidator(
		LiferayJwtRules liferayJwtRules) {

		OAuth2Error oAuth2Error = new OAuth2Error(
			"invalid_token", "The client_id does not match", null);

		return jwt -> {
			if (liferayJwtRules.isAcceptableClientId(
					jwt.getClaimAsString("client_id"))) {

				return OAuth2TokenValidatorResult.success();
			}

			return OAuth2TokenValidatorResult.failure(oAuth2Error);
		};
	}

}
