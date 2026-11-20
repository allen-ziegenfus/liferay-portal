/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.core;

import java.net.URI;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * What makes a Liferay issued token acceptable, stated without reference to
 * any framework.
 *
 * <p>
 * Three facts and one predicate. The adapter turns them into a
 * <code>NimbusJwtDecoder</code>; a Quarkus or Micronaut adapter would turn
 * them into something else. Neither has to relearn what Liferay puts in a
 * token.
 * </p>
 */
public class LiferayJwtRules {

	/**
	 * Liferay issues access tokens with the RFC 9068 <code>typ</code> header,
	 * not the default <code>JWT</code>. Getting this wrong produces a valid
	 * looking token that every verifier rejects, and it is the single most
	 * expensive thing in this library to rediscover from scratch.
	 */
	public static final String JOSE_OBJECT_TYPE = "at+jwt";

	public LiferayJwtRules(
		LiferayDXPConnection liferayDXPConnection,
		LiferayOAuth2Applications liferayOAuth2Applications) {

		_liferayDXPConnection = liferayDXPConnection;
		_liferayOAuth2Applications = liferayOAuth2Applications;
	}

	public URI getJWKSetURI() {
		return _liferayDXPConnection.resolve("/o/oauth2/jwks");
	}

	/**
	 * True when the token was issued to one of the OAuth applications this
	 * client extension was registered against.
	 *
	 * <p>
	 * A cache miss re-reads every registered code before rejecting. The
	 * current implementation seeds a map with every external reference code up
	 * front and then refreshes with <code>computeIfAbsent</code>, which can
	 * never fire because the key is always present, so a client ID that
	 * changes after startup is rejected until the container restarts.
	 * </p>
	 */
	public boolean isAcceptableClientId(String clientId) {
		if (clientId == null) {
			return false;
		}

		if (_clientIds.containsKey(clientId)) {
			return true;
		}

		for (String externalReferenceCode :
				_liferayOAuth2Applications.getExternalReferenceCodes()) {

			_liferayOAuth2Applications.find(
				externalReferenceCode
			).map(
				LiferayOAuth2Application::userAgentClientId
			).ifPresent(
				userAgentClientId -> _clientIds.put(
					userAgentClientId, Boolean.TRUE)
			);
		}

		return _clientIds.containsKey(clientId);
	}

	private final Map<String, Boolean> _clientIds = new ConcurrentHashMap<>();
	private final LiferayDXPConnection _liferayDXPConnection;
	private final LiferayOAuth2Applications _liferayOAuth2Applications;

}
