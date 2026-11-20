/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot.autoconfigure;

import com.liferay.client.extension.spring.boot.LiferayClientExtensionProperties;
import com.liferay.client.extension.spring.boot.LiferayDXPProperties;
import com.liferay.client.extension.spring.boot.client.LiferayOAuth2AccessTokenManager;
import com.liferay.client.extension.spring.boot.client.LiferayOAuth2ApplicationResolver;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.core.env.Environment;
import org.springframework.security.oauth2.client.AuthorizedClientServiceOAuth2AuthorizedClientManager;
import org.springframework.security.oauth2.client.InMemoryOAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientProviderBuilder;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository;
import org.springframework.security.oauth2.core.AuthorizationGrantType;
import org.springframework.security.oauth2.core.ClientAuthenticationMethod;
import org.springframework.web.client.RestClient;

/**
 * Turns the Liferay Cloud injected credentials into Spring Security client
 * registrations, one per external reference code.
 *
 * <p>
 * Behavior differences from <code>LiferayOAuth2ClientConfiguration</code>:
 * </p>
 *
 * <ul>
 * <li>A missing <code>liferay.oauth.application.external.reference.codes</code>
 * no longer throws. A client extension that only serves inbound requests has
 * no reason to hold outbound credentials, and under the old design it could
 * not import the component scan at all without inventing a value.</li>
 * <li>No <code>@Primary</code>. The old configuration marked its
 * <code>ClientRegistrationRepository</code> <code>@Primary</code> to win
 * against Boot's own auto-configuration, which meant a consumer could not
 * override it even by declaring their own bean.
 * <code>@ConditionalOnMissingBean</code> inverts that.</li>
 * <li>No <code>@Qualifier("extra")</code> injection point. Extra registrations
 * are contributed the ordinary Spring Boot way, through
 * <code>spring.security.oauth2.client.registration.*</code> or a consumer
 * supplied repository bean.</li>
 * </ul>
 */
@AutoConfiguration
@ConditionalOnClass(ClientRegistration.class)
@ConditionalOnProperty(
	name = "liferay.client.extension.oauth2.client.enabled",
	matchIfMissing = true
)
@EnableConfigurationProperties(
	{LiferayClientExtensionProperties.class, LiferayDXPProperties.class}
)
public class LiferayOAuth2ClientAutoConfiguration {

	@Bean
	@ConditionalOnMissingBean
	public AuthorizedClientServiceOAuth2AuthorizedClientManager
		authorizedClientServiceOAuth2AuthorizedClientManager(
			ClientRegistrationRepository clientRegistrationRepository,
			OAuth2AuthorizedClientService oAuth2AuthorizedClientService) {

		AuthorizedClientServiceOAuth2AuthorizedClientManager manager =
			new AuthorizedClientServiceOAuth2AuthorizedClientManager(
				clientRegistrationRepository, oAuth2AuthorizedClientService);

		manager.setAuthorizedClientProvider(
			OAuth2AuthorizedClientProviderBuilder.builder(
			).clientCredentials(
			).build());

		return manager;
	}

	@Bean
	@ConditionalOnMissingBean
	public ClientRegistrationRepository clientRegistrationRepository(
		LiferayClientExtensionProperties liferayClientExtensionProperties,
		LiferayOAuth2ApplicationResolver liferayOAuth2ApplicationResolver) {

		List<ClientRegistration> clientRegistrations = new ArrayList<>();

		for (String externalReferenceCode :
				liferayClientExtensionProperties.getExternalReferenceCodes()) {

			String clientId =
				liferayOAuth2ApplicationResolver.
					resolveHeadlessServerClientId(externalReferenceCode);
			String clientSecret =
				liferayOAuth2ApplicationResolver.resolveClientSecret(
					externalReferenceCode);

			if ((clientId == null) || (clientSecret == null)) {
				if (_log.isInfoEnabled()) {
					_log.info(
						"Skipping external reference code " +
							externalReferenceCode +
								" because it has no client credentials");
				}

				continue;
			}

			clientRegistrations.add(
				ClientRegistration.withRegistrationId(
					externalReferenceCode
				).authorizationGrantType(
					AuthorizationGrantType.CLIENT_CREDENTIALS
				).clientAuthenticationMethod(
					ClientAuthenticationMethod.CLIENT_SECRET_POST
				).clientId(
					clientId
				).clientSecret(
					clientSecret
				).tokenUri(
					String.valueOf(
						liferayOAuth2ApplicationResolver.resolveTokenURI(
							externalReferenceCode))
				).build());
		}

		return new InMemoryClientRegistrationRepository(clientRegistrations);
	}

	@Bean
	@ConditionalOnMissingBean
	public LiferayOAuth2AccessTokenManager liferayOAuth2AccessTokenManager(
		AuthorizedClientServiceOAuth2AuthorizedClientManager
			authorizedClientServiceOAuth2AuthorizedClientManager) {

		return new LiferayOAuth2AccessTokenManager(
			authorizedClientServiceOAuth2AuthorizedClientManager);
	}

	@Bean
	@ConditionalOnMissingBean
	public LiferayOAuth2ApplicationResolver liferayOAuth2ApplicationResolver(
		Environment environment, LiferayDXPProperties liferayDXPProperties,
		RestClient.Builder restClientBuilder) {

		return new LiferayOAuth2ApplicationResolver(
			environment, liferayDXPProperties, restClientBuilder.build());
	}

	@Bean
	@ConditionalOnMissingBean
	public OAuth2AuthorizedClientService oAuth2AuthorizedClientService(
		ClientRegistrationRepository clientRegistrationRepository) {

		return new InMemoryOAuth2AuthorizedClientService(
			clientRegistrationRepository);
	}

	private static final Log _log = LogFactory.getLog(
		LiferayOAuth2ClientAutoConfiguration.class);

}
