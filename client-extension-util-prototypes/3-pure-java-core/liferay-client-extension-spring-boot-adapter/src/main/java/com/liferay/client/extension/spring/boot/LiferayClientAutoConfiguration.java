/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot;

import com.liferay.client.extension.core.AccessTokenCache;
import com.liferay.client.extension.core.LiferayDXPConnection;

import java.time.Clock;
import java.time.Duration;

import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.oauth2.client.AuthorizedClientServiceOAuth2AuthorizedClientManager;
import org.springframework.security.oauth2.client.InMemoryOAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.OAuth2AuthorizeRequest;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientProviderBuilder;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.core.OAuth2AccessToken;
import org.springframework.web.client.RestClient;

/**
 * The outbound half of the adapter.
 *
 * <p>
 * The interesting bean here is the token cache, because it is the one place
 * where the core's generics visibly pay for themselves.
 * {@link AccessTokenCache} knows the policy - refresh a minute before expiry,
 * one token per external reference code - without knowing what a token is.
 * This method supplies the two Spring-shaped halves it is missing: how to
 * acquire an <code>OAuth2AccessToken</code>, and how to read its expiry.
 * </p>
 *
 * <p>
 * The current <code>LiferayOAuth2AccessTokenManager</code> fuses those three
 * things into one 160 line class, which is why its refresh window has no test:
 * the policy cannot be exercised without the Spring machinery. Split, the
 * policy is tested against a <code>Clock.fixed</code> and the wiring is six
 * lines that are obviously correct by inspection.
 * </p>
 */
@AutoConfiguration
@ConditionalOnClass(ClientRegistrationRepository.class)
@ConditionalOnProperty(
	name = "liferay.client.extension.oauth2.client.enabled",
	matchIfMissing = true
)
public class LiferayClientAutoConfiguration {

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
	public AccessTokenCache<OAuth2AccessToken> liferayAccessTokenCache(
		AuthorizedClientServiceOAuth2AuthorizedClientManager
			authorizedClientServiceOAuth2AuthorizedClientManager) {

		return new AccessTokenCache<>(
			Clock.systemUTC(), Duration.ofSeconds(60),
			externalReferenceCode -> {
				OAuth2AuthorizedClient oAuth2AuthorizedClient =
					authorizedClientServiceOAuth2AuthorizedClientManager.
						authorize(
							OAuth2AuthorizeRequest.withClientRegistrationId(
								externalReferenceCode
							).principal(
								externalReferenceCode
							).build());

				if (oAuth2AuthorizedClient == null) {
					return null;
				}

				return oAuth2AuthorizedClient.getAccessToken();
			},
			OAuth2AccessToken::getExpiresAt);
	}

	/**
	 * Replaces <code>LiferayOAuth2AccessTokenManager.getAuthorization</code>,
	 * with one cache read instead of three.
	 */
	@Bean
	@ConditionalOnMissingBean
	public LiferayAuthorizations liferayAuthorizations(
		AccessTokenCache<OAuth2AccessToken> accessTokenCache) {

		return externalReferenceCode -> {
			OAuth2AccessToken oAuth2AccessToken = accessTokenCache.get(
				externalReferenceCode);

			if ((oAuth2AccessToken == null) ||
				(oAuth2AccessToken.getTokenType() == null)) {

				return null;
			}

			OAuth2AccessToken.TokenType tokenType =
				oAuth2AccessToken.getTokenType();

			return tokenType.getValue() + " " +
				oAuth2AccessToken.getTokenValue();
		};
	}

	@Bean
	@ConditionalOnMissingBean
	public LiferayRestClient liferayRestClient(
		LiferayDXPConnection liferayDXPConnection,
		RestClient.Builder restClientBuilder) {

		return new LiferayRestClient(
			liferayDXPConnection,
			restClientBuilder.defaultHeader(
				HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE
			).build());
	}

	@Bean
	@ConditionalOnMissingBean
	public OAuth2AuthorizedClientService oAuth2AuthorizedClientService(
		ClientRegistrationRepository clientRegistrationRepository) {

		return new InMemoryOAuth2AuthorizedClientService(
			clientRegistrationRepository);
	}

	@FunctionalInterface
	public interface LiferayAuthorizations {

		public String getAuthorization(String externalReferenceCode);

	}

}
