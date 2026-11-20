/**
 * SPDX-FileCopyrightText: (c) 2026 Acme, Inc.
 * SPDX-License-Identifier: Apache-2.0
 */

package com.acme.inventory;

import com.liferay.client.extension.spring.boot.client.LiferayOAuth2AccessTokenManager;
import com.liferay.client.extension.spring.boot.web.LiferayRestClient;

import java.net.URI;

import java.util.Map;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

/**
 * BEFORE
 *
 * <pre>
 * public class StockLevelRestController extends BaseRestController {
 *
 *     &#64;GetMapping("/stock/{sku}")
 *     public String getStock(&#64;PathVariable String sku) {
 *
 *         // "get" is inherited. Where it came from, what it does with a 404,
 *         // and what happens on a 204 are all invisible from here.
 *         return get(
 *             _liferayOAuth2AccessTokenManager.getAuthorization("acme-erc"),
 *             URI.create("/o/c/inventoryitems?filter=sku eq '" + sku + "'"));
 *     }
 *
 * }
 * </pre>
 *
 * AFTER: an ordinary Spring controller. It extends nothing, the HTTP client
 * arrives by constructor injection, and the status code is visible to the code
 * that has to decide what it means.
 */
@RestController
public class StockLevelRestController {

	public StockLevelRestController(
		LiferayOAuth2AccessTokenManager liferayOAuth2AccessTokenManager,
		LiferayRestClient liferayRestClient) {

		_liferayOAuth2AccessTokenManager = liferayOAuth2AccessTokenManager;
		_liferayRestClient = liferayRestClient;
	}

	@GetMapping("/stock/{sku}")
	public ResponseEntity<String> getStock(
		@AuthenticationPrincipal Jwt jwt, @PathVariable String sku) {

		ResponseEntity<String> responseEntity = _liferayRestClient.get(
			URI.create("/o/c/inventoryitems?filter=sku eq '" + sku + "'"),
			Map.of(
				HttpHeaders.AUTHORIZATION,
				_liferayOAuth2AccessTokenManager.getAuthorization(_ERC)));

		// A 404 from the object endpoint is a real answer, not an exception.
		// Under BaseService this arrived as a WebClientResponseException and
		// the only way to distinguish "no such SKU" from "DXP is down" was to
		// catch the exception and re-read the status off it.

		if (responseEntity.getStatusCode() == HttpStatus.NOT_FOUND) {
			return ResponseEntity.notFound().build();
		}

		return responseEntity;
	}

	private static final String _ERC = "acme-inventory-headless-server";

	private final LiferayOAuth2AccessTokenManager
		_liferayOAuth2AccessTokenManager;
	private final LiferayRestClient _liferayRestClient;

}
