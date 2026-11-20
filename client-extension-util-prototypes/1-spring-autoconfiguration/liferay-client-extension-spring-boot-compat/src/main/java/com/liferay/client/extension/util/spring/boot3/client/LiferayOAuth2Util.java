/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.util.spring.boot3.client;

import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.springframework.security.oauth2.client.AuthorizedClientServiceOAuth2AuthorizedClientManager;
import org.springframework.security.oauth2.client.OAuth2AuthorizeRequest;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.core.OAuth2AccessToken;
import org.springframework.web.client.RestClient;

/**
 * Three consumers use this, all of them static calls, so the shim is the
 * original implementation with <code>WebClient</code> swapped for
 * <code>RestClient</code> to avoid dragging webflux back in.
 *
 * <p>
 * The signatures are unusual - every method takes
 * <code>lxcDXPMainDomain</code> and <code>lxcDXPServerProtocol</code> as
 * arguments - which is what a static utility looks like when the configuration
 * it needs lives in <code>@Value</code> fields on some other class. The
 * replacement takes those from a bean instead.
 * </p>
 *
 * @deprecated As of 2.0.0, replaced by
 *             {@link com.liferay.client.extension.spring.boot.client.LiferayOAuth2ApplicationResolver},
 *             which is injected and reads the connection details itself.
 */
@Deprecated
public class LiferayOAuth2Util {

	public static String getClientId(
		String externalReferenceCode, String lxcDXPMainDomain,
		String lxcDXPServerProtocol) {

		Map<String, String> applicationInfo = _getApplicationInfo(
			externalReferenceCode, lxcDXPMainDomain, lxcDXPServerProtocol);

		if (applicationInfo == null) {
			return null;
		}

		return applicationInfo.get("client_id");
	}

	public static String getHomePageURL(
		String externalReferenceCode, String lxcDXPMainDomain,
		String lxcDXPServerProtocol) {

		Map<String, String> applicationInfo = _getApplicationInfo(
			externalReferenceCode, lxcDXPMainDomain, lxcDXPServerProtocol);

		if (applicationInfo == null) {
			return null;
		}

		return applicationInfo.get("homePageURL");
	}

	public static OAuth2AccessToken getOAuth2AccessToken(
		AuthorizedClientServiceOAuth2AuthorizedClientManager
			authorizedClientServiceOAuth2AuthorizedClientManager,
		String externalReferenceCode) {

		OAuth2AuthorizedClient oAuth2AuthorizedClient =
			authorizedClientServiceOAuth2AuthorizedClientManager.authorize(
				OAuth2AuthorizeRequest.withClientRegistrationId(
					externalReferenceCode
				).principal(
					externalReferenceCode
				).build());

		if (oAuth2AuthorizedClient == null) {
			_log.error("Unable to get OAuth 2 authorized client");

			return null;
		}

		return oAuth2AuthorizedClient.getAccessToken();
	}

	@SuppressWarnings("unchecked")
	private static Map<String, String> _getApplicationInfo(
		String externalReferenceCode, String lxcDXPMainDomain,
		String lxcDXPServerProtocol) {

		try {
			RestClient restClient = RestClient.create();

			return restClient.get(
			).uri(
				lxcDXPServerProtocol + "://" + lxcDXPMainDomain +
					"/o/oauth2/application?externalReferenceCode=" +
						externalReferenceCode
			).retrieve(
			).body(
				Map.class
			);
		}
		catch (Exception exception) {
			if (_log.isWarnEnabled()) {
				_log.warn("Unable to get client ID: " + exception.getMessage());
			}

			return null;
		}
	}

	private static final Log _log = LogFactory.getLog(LiferayOAuth2Util.class);

}
