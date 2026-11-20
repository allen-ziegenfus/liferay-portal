/**
 * SPDX-FileCopyrightText: (c) 2026 Acme, Inc.
 * SPDX-License-Identifier: Apache-2.0
 */

package com.acme.inventory;

import com.liferay.client.extension.util.spring.boot3.BaseRestController;
import com.liferay.client.extension.util.spring.boot3.client.LiferayOAuth2AccessTokenManager;

import java.net.URI;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

/**
 * Also unchanged. Still extends <code>BaseRestController</code>, still calls the
 * inherited <code>get</code>, still gets a <code>String</code> back with the
 * status code discarded.
 *
 * <p>
 * Option 2 fixes none of that. It is worth being explicit about the boundary:
 * this option addresses only the dependency posture and the Spring Security 7
 * removals. The naming, the inheritance coupling, the per-request connection
 * pool and the body reinterpretation are Options 1, 3 and 4.
 * </p>
 *
 * <p>
 * What changes for this consumer is invisible from the source and visible in
 * the dependency tree: the library stops exporting Spring, so
 * <code>build.gradle</code> can move to Spring Boot 4 the day it ships without
 * waiting on a library release, and a Spring CVE bump stops being a
 * cross-workspace coordination problem.
 * </p>
 */
public class StockLevelRestController extends BaseRestController {

	@GetMapping("/stock/{sku}")
	public String getStock(@PathVariable String sku) {
		return get(
			_liferayOAuth2AccessTokenManager.getAuthorization(_ERC),
			URI.create("/o/c/inventoryitems?filter=sku eq '" + sku + "'"));
	}

	private static final String _ERC = "acme-inventory-headless-server";

	@Autowired
	private LiferayOAuth2AccessTokenManager _liferayOAuth2AccessTokenManager;

}
