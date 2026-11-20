/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot.client;

import com.liferay.client.extension.spring.boot.LiferayDXPProperties;

import java.net.URI;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.springframework.core.env.Environment;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestClient;

/**
 * Resolves an OAuth application's client credentials from its external
 * reference code.
 *
 * <p>
 * This class holds what is arguably the only irreplaceable knowledge in the
 * whole library: the property naming convention Liferay Cloud injects, and the
 * <code>/o/oauth2/application</code> fallback for when it has not.
 * </p>
 */
public class LiferayOAuth2ApplicationResolver {

	public LiferayOAuth2ApplicationResolver(
		Environment environment, LiferayDXPProperties liferayDXPProperties,
		RestClient restClient) {

		_environment = environment;
		_liferayDXPProperties = liferayDXPProperties;
		_restClient = restClient;
	}

	public String resolveClientSecret(String externalReferenceCode) {
		return _environment.getProperty(
			externalReferenceCode + ".oauth2.headless.server.client.secret");
	}

	public String resolveHeadlessServerClientId(
		String externalReferenceCode) {

		String clientId = _environment.getProperty(
			externalReferenceCode + ".oauth2.headless.server.client.id");

		if (clientId != null) {
			return clientId;
		}

		return _fetchClientId(externalReferenceCode);
	}

	public URI resolveTokenURI(String externalReferenceCode) {
		String tokenURI = _environment.getProperty(
			externalReferenceCode + ".oauth2.token.uri", "/o/oauth2/token");

		if (tokenURI.contains("://")) {
			return URI.create(tokenURI);
		}

		return _liferayDXPProperties.getBaseURI(
		).resolve(
			tokenURI
		);
	}

	public String resolveUserAgentClientId(String externalReferenceCode) {
		String clientId = _environment.getProperty(
			externalReferenceCode + ".oauth2.user.agent.client.id");

		if (clientId != null) {
			return clientId;
		}

		return _fetchClientId(externalReferenceCode);
	}

	private String _fetchClientId(String externalReferenceCode) {
		try {
			URI uri = _liferayDXPProperties.getBaseURI(
			).resolve(
				"/o/oauth2/application?externalReferenceCode=" +
					externalReferenceCode
			);

			ResponseEntity<ApplicationInfo> responseEntity =
				_restClient.get(
				).uri(
					uri
				).retrieve(
				).toEntity(
					ApplicationInfo.class
				);

			ApplicationInfo applicationInfo = responseEntity.getBody();

			if (applicationInfo == null) {
				return null;
			}

			return applicationInfo.client_id;
		}
		catch (Exception exception) {
			if (_log.isWarnEnabled()) {
				_log.warn(
					"Unable to resolve client ID for external reference code " +
						externalReferenceCode + ": " + exception.getMessage());
			}

			return null;
		}
	}

	private static final Log _log = LogFactory.getLog(
		LiferayOAuth2ApplicationResolver.class);

	private final Environment _environment;
	private final LiferayDXPProperties _liferayDXPProperties;
	private final RestClient _restClient;

	public static class ApplicationInfo {

		public String client_id;
		public String homePageURL;

	}

}
