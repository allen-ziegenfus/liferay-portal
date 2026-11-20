/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot.client;

import java.time.Instant;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.security.oauth2.client.AuthorizedClientServiceOAuth2AuthorizedClientManager;
import org.springframework.security.oauth2.client.OAuth2AuthorizeRequest;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.core.OAuth2AccessToken;

/**
 * Caches client credentials access tokens until they are within a minute of
 * expiring.
 *
 * <p>
 * Functionally the same as before, with two corrections. It is no longer
 * annotated <code>@Configuration</code> - it is a stateful collaborator, not a
 * source of bean definitions, and annotating it that way made it eligible for
 * CGLIB proxying for no reason. And <code>getAuthorization</code> no longer
 * makes three separate cache lookups to assemble one header value, each of
 * which could independently trigger a token refresh.
 * </p>
 */
public class LiferayOAuth2AccessTokenManager {

	public LiferayOAuth2AccessTokenManager(
		AuthorizedClientServiceOAuth2AuthorizedClientManager
			authorizedClientServiceOAuth2AuthorizedClientManager) {

		_authorizedClientServiceOAuth2AuthorizedClientManager =
			authorizedClientServiceOAuth2AuthorizedClientManager;
	}

	public String getAuthorization(String externalReferenceCode) {
		OAuth2AccessToken oAuth2AccessToken = getOAuth2AccessToken(
			externalReferenceCode);

		if (oAuth2AccessToken == null) {
			return null;
		}

		OAuth2AccessToken.TokenType tokenType =
			oAuth2AccessToken.getTokenType();

		if (tokenType == null) {
			return null;
		}

		return tokenType.getValue() + " " + oAuth2AccessToken.getTokenValue();
	}

	public OAuth2AccessToken getOAuth2AccessToken(
		String externalReferenceCode) {

		return _oAuth2AccessTokens.compute(
			externalReferenceCode,
			(key, oAuth2AccessToken) -> {
				if (_isValid(oAuth2AccessToken)) {
					return oAuth2AccessToken;
				}

				return _authorize(key);
			});
	}

	public void refresh(String externalReferenceCode) {
		_oAuth2AccessTokens.put(
			externalReferenceCode, _authorize(externalReferenceCode));
	}

	private OAuth2AccessToken _authorize(String externalReferenceCode) {
		OAuth2AuthorizedClient oAuth2AuthorizedClient =
			_authorizedClientServiceOAuth2AuthorizedClientManager.authorize(
				OAuth2AuthorizeRequest.withClientRegistrationId(
					externalReferenceCode
				).principal(
					externalReferenceCode
				).build());

		if (oAuth2AuthorizedClient == null) {
			return null;
		}

		return oAuth2AuthorizedClient.getAccessToken();
	}

	private boolean _isValid(OAuth2AccessToken oAuth2AccessToken) {
		if (oAuth2AccessToken == null) {
			return false;
		}

		Instant expiresAtInstant = oAuth2AccessToken.getExpiresAt();

		if (expiresAtInstant == null) {
			return false;
		}

		return expiresAtInstant.isAfter(Instant.now().plusSeconds(60));
	}

	private final AuthorizedClientServiceOAuth2AuthorizedClientManager
		_authorizedClientServiceOAuth2AuthorizedClientManager;
	private final Map<String, OAuth2AccessToken> _oAuth2AccessTokens =
		new ConcurrentHashMap<>();

}
