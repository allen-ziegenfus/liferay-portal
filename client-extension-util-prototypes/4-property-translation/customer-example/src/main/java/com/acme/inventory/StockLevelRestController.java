/**
 * SPDX-FileCopyrightText: (c) 2026 Acme, Inc.
 * SPDX-License-Identifier: Apache-2.0
 */

package com.acme.inventory;

import java.util.Map;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.annotation.RegisteredOAuth2AuthorizedClient;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestClient;

/**
 * Stock Spring Security, top to bottom.
 *
 * <p>
 * <code>&#64;RegisteredOAuth2AuthorizedClient</code> is a Spring Security
 * annotation. It works here because the post processor wrote a client
 * registration named <code>acme-erc</code> into the environment, so Spring's
 * own machinery acquires, caches and refreshes the client credentials token.
 * <code>LiferayOAuth2AccessTokenManager</code> has no counterpart in this
 * option because Spring Security already implements it.
 * </p>
 *
 * <p>
 * Everything a customer needs to know to write this is Spring Security
 * documentation, not Liferay documentation. That is the real ease-of-use
 * argument, and it is the opposite of the one the current library makes.
 * </p>
 */
@RestController
public class StockLevelRestController {

	public StockLevelRestController(RestClient.Builder restClientBuilder) {
		_restClient = restClientBuilder.build();
	}

	@GetMapping("/stock/{sku}")
	public String getStock(
		@AuthenticationPrincipal Jwt jwt,
		@RegisteredOAuth2AuthorizedClient("acme-erc")
			OAuth2AuthorizedClient oAuth2AuthorizedClient,
		@PathVariable String sku) {

		return _restClient.get(
		).uri(
			"{base}/o/c/inventoryitems?filter=sku eq '{sku}'",
			Map.of("base", _baseURL, "sku", sku)
		).header(
			"Authorization",
			"Bearer " + oAuth2AuthorizedClient.getAccessToken(
			).getTokenValue()
		).retrieve(
		).body(
			String.class
		);
	}

	private final String _baseURL = System.getProperty(
		"com.liferay.lxc.dxp.mainDomain", "");
	private final RestClient _restClient;

}
