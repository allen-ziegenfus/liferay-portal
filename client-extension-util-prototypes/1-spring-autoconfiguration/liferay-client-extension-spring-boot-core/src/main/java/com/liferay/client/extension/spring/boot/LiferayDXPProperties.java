/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot;

import java.net.URI;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Binds the connection details Liferay Cloud injects into every client
 * extension container.
 *
 * <p>
 * These four values were previously read through scattered
 * <code>@Value</code> fields duplicated across five classes, which meant a
 * missing value failed at bean construction time with no indication of which
 * property was absent. Binding them once gives a single failure point and
 * makes the contract with Liferay Cloud explicit.
 * </p>
 */
@ConfigurationProperties(prefix = "com.liferay.lxc.dxp")
public class LiferayDXPProperties {

	public URI getBaseURI() {
		return URI.create(server.getProtocol() + "://" + mainDomain);
	}

	public List<String> getCorsAllowedOrigins() {
		List<String> allowedOrigins = new ArrayList<>();

		for (String domain : getDomains()) {
			allowedOrigins.add("http://" + domain);
			allowedOrigins.add("https://" + domain);
		}

		return allowedOrigins;
	}

	public List<String> getDomains() {
		if ((domains == null) || domains.isEmpty()) {
			return List.of();
		}

		return Arrays.asList(domains.split("\\s*[,\n]\\s*"));
	}

	public String getDomainsRaw() {
		return domains;
	}

	public String getMainDomain() {
		return mainDomain;
	}

	public Server getServer() {
		return server;
	}

	public void setDomains(String domains) {
		this.domains = domains;
	}

	public void setMainDomain(String mainDomain) {
		this.mainDomain = mainDomain;
	}

	public static class Server {

		public String getProtocol() {
			return protocol;
		}

		public void setProtocol(String protocol) {
			this.protocol = protocol;
		}

		private String protocol = "https";

	}

	private String domains;
	private String mainDomain;
	private final Server server = new Server();

}
