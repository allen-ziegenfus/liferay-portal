/**
 * SPDX-FileCopyrightText: (c) 2026 Acme, Inc.
 * SPDX-License-Identifier: Apache-2.0
 */

package com.acme.inventory;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import com.liferay.client.extension.spring.boot.client.LiferayOAuth2AccessTokenManager;
import com.liferay.client.extension.spring.boot.web.LiferayRestClient;

import java.net.URI;

import java.util.Map;

import org.junit.jupiter.api.Test;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

/**
 * The point of this file is that it exists.
 *
 * A controller extending BaseRestController could not be unit tested without a
 * Spring context: the HTTP call was a protected method on a superclass that
 * built its own WebClient from &#64;Value injected fields, so there was no seam
 * to substitute. The only options were to stand up the whole application
 * context with a mock server, which is what
 * LiferayOAuth2ResourceServerEnableWebSecurityTest does, or not to test.
 *
 * With the client injected, the seam is the constructor.
 */
public class StockLevelRestControllerTest {

	@Test
	public void testGetStockReturnsNotFoundWhenSkuIsUnknown() {
		LiferayRestClient liferayRestClient = mock(LiferayRestClient.class);

		when(
			liferayRestClient.get(any(URI.class), any(Map.class))
		).thenReturn(
			ResponseEntity.status(HttpStatus.NOT_FOUND).build()
		);

		LiferayOAuth2AccessTokenManager liferayOAuth2AccessTokenManager = mock(
			LiferayOAuth2AccessTokenManager.class);

		StockLevelRestController stockLevelRestController =
			new StockLevelRestController(
				liferayOAuth2AccessTokenManager, liferayRestClient);

		ResponseEntity<String> responseEntity =
			stockLevelRestController.getStock(null, "NO-SUCH-SKU");

		assertEquals(HttpStatus.NOT_FOUND, responseEntity.getStatusCode());
	}

}
