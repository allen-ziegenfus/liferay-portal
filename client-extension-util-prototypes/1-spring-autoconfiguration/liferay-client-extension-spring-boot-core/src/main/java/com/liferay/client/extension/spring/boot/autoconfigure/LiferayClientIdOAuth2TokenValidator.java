/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot.autoconfigure;

import com.liferay.client.extension.spring.boot.client.LiferayOAuth2ApplicationResolver;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.OAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2TokenValidatorResult;
import org.springframework.security.oauth2.jwt.Jwt;

/**
 * Accepts a JWT only when its <code>client_id</code> belongs to one of the
 * OAuth applications this client extension was registered against.
 *
 * <p>
 * This is one of the few rules in the library that genuinely cannot be
 * expressed as a Spring Boot property, which is a useful test of what belongs
 * in a library at all.
 * </p>
 *
 * <p>
 * The original implementation had a latent bug worth preserving a note about:
 * it seeded a <code>HashMap</code> with every external reference code up front
 * and then refreshed misses with <code>computeIfAbsent</code>, which never
 * fires because the key is always present. A stale or late-registered client
 * ID could therefore never be picked up without a restart. Here a miss
 * re-resolves explicitly.
 * </p>
 */
public class LiferayClientIdOAuth2TokenValidator
	implements OAuth2TokenValidator<Jwt> {

	public LiferayClientIdOAuth2TokenValidator(
		List<String> externalReferenceCodes,
		LiferayOAuth2ApplicationResolver liferayOAuth2ApplicationResolver) {

		_externalReferenceCodes = externalReferenceCodes;
		_liferayOAuth2ApplicationResolver = liferayOAuth2ApplicationResolver;
	}

	@Override
	public OAuth2TokenValidatorResult validate(Jwt jwt) {
		String jwtClientId = jwt.getClaimAsString("client_id");

		if (jwtClientId == null) {
			return OAuth2TokenValidatorResult.failure(_oAuth2Error);
		}

		if (_clientIds.containsValue(jwtClientId)) {
			return OAuth2TokenValidatorResult.success();
		}

		for (String externalReferenceCode : _externalReferenceCodes) {
			String clientId =
				_liferayOAuth2ApplicationResolver.resolveUserAgentClientId(
					externalReferenceCode);

			if (clientId != null) {
				_clientIds.put(externalReferenceCode, clientId);
			}
		}

		if (_clientIds.containsValue(jwtClientId)) {
			return OAuth2TokenValidatorResult.success();
		}

		return OAuth2TokenValidatorResult.failure(_oAuth2Error);
	}

	private final Map<String, String> _clientIds = new ConcurrentHashMap<>();
	private final List<String> _externalReferenceCodes;
	private final LiferayOAuth2ApplicationResolver
		_liferayOAuth2ApplicationResolver;
	private final OAuth2Error _oAuth2Error = new OAuth2Error(
		"invalid_token", "The client_id does not match", null);

}
