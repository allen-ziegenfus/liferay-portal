/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot;

import java.util.ArrayList;
import java.util.List;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Every opinion this library holds, expressed as a property the consumer can
 * turn off.
 *
 * <p>
 * The previous design exposed no switches at all: importing
 * <code>ClientExtensionUtilSpringBootComponentScan</code> registered the CORS
 * configurer, the resource server, the client registrations and the web MVC
 * configuration as one indivisible unit.
 * </p>
 */
@ConfigurationProperties(prefix = "liferay.client.extension")
public class LiferayClientExtensionProperties {

	public Cors getCors() {
		return cors;
	}

	public List<String> getExternalReferenceCodes() {
		return externalReferenceCodes;
	}

	public OAuth2 getOAuth2() {
		return oAuth2;
	}

	public void setExternalReferenceCodes(
		List<String> externalReferenceCodes) {

		this.externalReferenceCodes = externalReferenceCodes;
	}

	public static class Client {

		public boolean isEnabled() {
			return enabled;
		}

		public void setEnabled(boolean enabled) {
			this.enabled = enabled;
		}

		private boolean enabled = true;

	}

	public static class Cors {

		public List<String> getAllowedHeaders() {
			return allowedHeaders;
		}

		public List<String> getAllowedMethods() {
			return allowedMethods;
		}

		public String getPathPattern() {
			return pathPattern;
		}

		public boolean isEnabled() {
			return enabled;
		}

		public void setAllowedHeaders(List<String> allowedHeaders) {
			this.allowedHeaders = allowedHeaders;
		}

		public void setAllowedMethods(List<String> allowedMethods) {
			this.allowedMethods = allowedMethods;
		}

		public void setEnabled(boolean enabled) {
			this.enabled = enabled;
		}

		public void setPathPattern(String pathPattern) {
			this.pathPattern = pathPattern;
		}

		private List<String> allowedHeaders = List.of(
			"Authorization", "Content-Type");
		private List<String> allowedMethods = List.of(
			"DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT");
		private boolean enabled = true;
		private String pathPattern = "/**";

	}

	public static class OAuth2 {

		public Client getClient() {
			return client;
		}

		public ResourceServer getResourceServer() {
			return resourceServer;
		}

		private final Client client = new Client();
		private final ResourceServer resourceServer = new ResourceServer();

	}

	public static class ResourceServer {

		public List<String> getPermitAllPatterns() {
			return permitAllPatterns;
		}

		public boolean isEnabled() {
			return enabled;
		}

		public void setEnabled(boolean enabled) {
			this.enabled = enabled;
		}

		public void setPermitAllPatterns(List<String> permitAllPatterns) {
			this.permitAllPatterns = permitAllPatterns;
		}

		private boolean enabled = true;
		private List<String> permitAllPatterns = new ArrayList<>();

	}

	private final Cors cors = new Cors();
	private List<String> externalReferenceCodes = new ArrayList<>();
	private final OAuth2 oAuth2 = new OAuth2();

}
