/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot.env;

import java.util.HashMap;
import java.util.Map;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.env.EnvironmentPostProcessor;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MapPropertySource;
import org.springframework.core.env.MutablePropertySources;

/**
 * Translates the properties Liferay Cloud injects into the standard Spring
 * Boot property keys that already mean the same thing.
 *
 * <p>
 * This option ships no configuration classes, no beans, and no base classes for
 * the static case. It writes property keys, and Spring Boot's own
 * auto-configuration does the rest. The consumer's application ends up being
 * ordinary Spring Boot that happens to be pointed at their DXP instance.
 * </p>
 *
 * <p>
 * The reason to prefer this over calling Spring APIs is stability of contract.
 * <code>spring.security.oauth2.resourceserver.jwt.jwk-set-uri</code> has meant
 * the same thing since Boot 2.1 and still does in 4.x.
 * <code>HttpSecurity.cors().and()</code> did not survive one major version.
 * Property keys are a far more durable interface than Java method signatures,
 * and Spring treats them as such.
 * </p>
 *
 * <p>
 * <strong>Precedence.</strong> The derived values are added with
 * <code>addLast</code>, so they sit below every other property source. Anything
 * the consumer writes in <code>application.properties</code>, passes as a
 * system property or sets in the environment wins outright. That is the whole
 * un-opinionated story in one method call: the library supplies defaults it
 * derived, and loses every argument about them.
 * </p>
 */
public class LiferayEnvironmentPostProcessor implements EnvironmentPostProcessor {

	public static final String PROPERTY_SOURCE_NAME =
		"liferayClientExtensionDerived";

	@Override
	public void postProcessEnvironment(
		ConfigurableEnvironment configurableEnvironment,
		SpringApplication springApplication) {

		String mainDomain = configurableEnvironment.getProperty(
			"com.liferay.lxc.dxp.mainDomain");

		if (mainDomain == null) {
			// Not running as a Liferay client extension. Contribute nothing
			// rather than failing, so the same jar is harmless in a local
			// test, a CI build or a plain Spring Boot app.

			return;
		}

		String baseURL =
			configurableEnvironment.getProperty(
				"com.liferay.lxc.dxp.server.protocol", "https") + "://" +
					mainDomain;

		Map<String, Object> derived = new HashMap<>();

		_addResourceServerProperties(derived, baseURL);

		_addClientProperties(configurableEnvironment, derived, baseURL);

		if (derived.isEmpty()) {
			return;
		}

		MutablePropertySources mutablePropertySources =
			configurableEnvironment.getPropertySources();

		mutablePropertySources.addLast(
			new MapPropertySource(PROPERTY_SOURCE_NAME, derived));
	}

	private void _addClientProperties(
		ConfigurableEnvironment configurableEnvironment,
		Map<String, Object> derived, String baseURL) {

		String externalReferenceCodes = configurableEnvironment.getProperty(
			"liferay.oauth.application.external.reference.codes");

		if (externalReferenceCodes == null) {
			return;
		}

		for (String externalReferenceCode :
				externalReferenceCodes.split("\\s*,\\s*")) {

			String clientId = configurableEnvironment.getProperty(
				externalReferenceCode +
					".oauth2.headless.server.client.id");
			String clientSecret = configurableEnvironment.getProperty(
				externalReferenceCode +
					".oauth2.headless.server.client.secret");

			if ((clientId == null) || (clientSecret == null)) {
				continue;
			}

			String registration =
				"spring.security.oauth2.client.registration." +
					externalReferenceCode;

			derived.put(registration + ".authorization-grant-type",
				"client_credentials");
			derived.put(registration + ".client-authentication-method",
				"client_secret_post");
			derived.put(registration + ".client-id", clientId);
			derived.put(registration + ".client-secret", clientSecret);
			derived.put(registration + ".provider", externalReferenceCode);

			String tokenURI = configurableEnvironment.getProperty(
				externalReferenceCode + ".oauth2.token.uri",
				"/o/oauth2/token");

			if (!tokenURI.contains("://")) {
				tokenURI = baseURL + tokenURI;
			}

			derived.put(
				"spring.security.oauth2.client.provider." +
					externalReferenceCode + ".token-uri",
				tokenURI);
		}
	}

	private void _addResourceServerProperties(
		Map<String, Object> derived, String baseURL) {

		// Replaces the entire jwtDecoder() bean, minus the at+jwt type
		// verifier and the client_id allowlist. Boot builds the
		// NimbusJwtDecoder, fetches the JWK set, caches it and refreshes it,
		// all of which the library currently reimplements by hand.

		derived.put(
			"spring.security.oauth2.resourceserver.jwt.jwk-set-uri",
			baseURL + "/o/oauth2/jwks");
	}

}
