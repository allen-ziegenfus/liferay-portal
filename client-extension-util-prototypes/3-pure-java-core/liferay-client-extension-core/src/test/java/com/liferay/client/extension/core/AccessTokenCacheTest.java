/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.core;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.time.ZoneOffset;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import org.junit.jupiter.api.Test;

/**
 * The refresh window, finally testable.
 *
 * <p>
 * There is no test for this behavior anywhere in the current module, because
 * <code>LiferayOAuth2AccessTokenManager</code> calls <code>Instant.now()</code>
 * inline. Asserting that a token refreshes 60 seconds before expiry would have
 * required waiting for real time to pass.
 * </p>
 */
public class AccessTokenCacheTest {

	@Test
	public void testTokenIsRefreshedInsideTheWindowAndCachedOutsideIt() {
		Instant instant = Instant.parse("2026-01-01T00:00:00Z");

		Map<String, Instant> expiresAtInstants = new HashMap<>();

		AtomicInteger supplierCount = new AtomicInteger();

		AccessTokenCache<String> accessTokenCache = new AccessTokenCache<>(
			Clock.fixed(instant, ZoneOffset.UTC), Duration.ofSeconds(60),
			externalReferenceCode -> {
				String token = "token-" + supplierCount.incrementAndGet();

				expiresAtInstants.put(token, instant.plusSeconds(300));

				return token;
			},
			expiresAtInstants::get);

		assertEquals("token-1", accessTokenCache.get("acme-erc"));

		// Still 300 seconds from expiry, so no new token.

		assertEquals("token-1", accessTokenCache.get("acme-erc"));
		assertEquals(1, supplierCount.get());

		// Move the recorded expiry to 30 seconds out, inside the 60 second
		// refresh window.

		expiresAtInstants.put("token-1", instant.plusSeconds(30));

		assertEquals("token-2", accessTokenCache.get("acme-erc"));
		assertEquals(2, supplierCount.get());
	}

}
