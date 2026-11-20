/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.core;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;

/**
 * Holds a token per external reference code until it is close to expiring.
 *
 * <p>
 * Generic over the token type, so the caller decides what a token is. The
 * Spring adapter instantiates it as
 * <code>AccessTokenCache&lt;OAuth2AccessToken&gt;</code>; a different adapter
 * uses its own type; a test uses <code>String</code>.
 * </p>
 *
 * <p>
 * The <code>Clock</code> is injected. The current implementation calls
 * <code>Instant.now()</code> directly, which is why there is no test anywhere
 * for the refresh window - you cannot assert on expiry behavior without waiting
 * for real time to pass.
 * </p>
 */
public class AccessTokenCache<T> {

	public AccessTokenCache(
		Clock clock, Duration refreshWindow,
		Function<String, T> tokenSupplier,
		Function<T, Instant> expiresAtFunction) {

		_clock = clock;
		_refreshWindow = refreshWindow;
		_tokenSupplier = tokenSupplier;
		_expiresAtFunction = expiresAtFunction;
	}

	public T get(String externalReferenceCode) {
		return _tokens.compute(
			externalReferenceCode,
			(key, token) -> {
				if (_isValid(token)) {
					return token;
				}

				return _tokenSupplier.apply(key);
			});
	}

	public void refresh(String externalReferenceCode) {
		_tokens.put(
			externalReferenceCode,
			_tokenSupplier.apply(externalReferenceCode));
	}

	private boolean _isValid(T token) {
		if (token == null) {
			return false;
		}

		Instant expiresAtInstant = _expiresAtFunction.apply(token);

		if (expiresAtInstant == null) {
			return false;
		}

		return expiresAtInstant.isAfter(_clock.instant().plus(_refreshWindow));
	}

	private final Clock _clock;
	private final Function<T, Instant> _expiresAtFunction;
	private final Duration _refreshWindow;
	private final Function<String, T> _tokenSupplier;
	private final Map<String, T> _tokens = new ConcurrentHashMap<>();

}
