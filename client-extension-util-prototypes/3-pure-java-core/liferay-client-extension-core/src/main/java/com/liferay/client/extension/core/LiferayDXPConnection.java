/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.core;

import java.net.URI;

import java.util.ArrayList;
import java.util.List;

/**
 * Where the bound DXP instance lives, derived from the four properties Liferay
 * Cloud injects into every client extension container.
 *
 * <p>
 * In the current library this arithmetic is repeated as inline
 * <code>StringBuilder</code> chains in five different classes, each with its
 * own <code>@Value</code> fields. Two of those classes declare
 * <code>_lxcDXPDomains</code> and never read it.
 * </p>
 */
public class LiferayDXPConnection {

	public static final String DOMAINS = "com.liferay.lxc.dxp.domains";

	public static final String MAIN_DOMAIN = "com.liferay.lxc.dxp.mainDomain";

	public static final String SERVER_PROTOCOL =
		"com.liferay.lxc.dxp.server.protocol";

	public LiferayDXPConnection(LiferayProperties liferayProperties) {
		_baseURI = URI.create(
			liferayProperties.get(SERVER_PROTOCOL, "https") + "://" +
				liferayProperties.require(MAIN_DOMAIN));

		_domains = liferayProperties.getList(DOMAINS);
	}

	public URI getBaseURI() {
		return _baseURI;
	}

	public List<String> getCorsAllowedOrigins() {
		List<String> corsAllowedOrigins = new ArrayList<>();

		for (String domain : _domains) {
			corsAllowedOrigins.add("http://" + domain);
			corsAllowedOrigins.add("https://" + domain);
		}

		return corsAllowedOrigins;
	}

	public List<String> getDomains() {
		return _domains;
	}

	public URI resolve(String path) {
		if (path.contains("://")) {
			return URI.create(path);
		}

		return _baseURI.resolve(path);
	}

	private final URI _baseURI;
	private final List<String> _domains;

}
