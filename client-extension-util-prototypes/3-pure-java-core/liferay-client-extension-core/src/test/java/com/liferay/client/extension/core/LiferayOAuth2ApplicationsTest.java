/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.core;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.Test;

/**
 * No Spring context. No mock HTTP server. No properties file on the test
 * classpath. No Mockito.
 *
 * <p>
 * Compare with what the current module needs to assert the same behavior:
 * <code>LiferayOAuth2ClientConfigurationDefaultTest</code> is 237 lines that
 * boot a <code>SpringBootTest</code> context with an accompanying
 * <code>.properties</code> file, plus <code>mockserver-netty</code>,
 * <code>mockito-core</code>, <code>spring-test</code> and
 * <code>spring-boot-test-autoconfigure</code> as test dependencies. It also
 * required a <code>configurations.all { exclude ... }</code> block in
 * build.gradle to keep the portal's repo-wide Spring version off its
 * classpath, and it is the reason the boot2 module had to be deleted rather
 * than kept: its tests could not pass on master once the repo forced Spring 6
 * and Mockito 5 onto them.
 * </p>
 */
public class LiferayOAuth2ApplicationsTest {

	@Test
	public void testExternalReferenceCodesAreEmptyWhenPropertyIsAbsent() {
		LiferayOAuth2Applications liferayOAuth2Applications = _build(
			Map.of(
				LiferayDXPConnection.MAIN_DOMAIN, "acme.lxc.liferay.com",
				LiferayDXPConnection.SERVER_PROTOCOL, "https"));

		// The current library throws IllegalArgumentException here, from two
		// separate classes, which is why an inbound-only client extension
		// cannot import the component scan without inventing a value.

		assertEquals(
			List.of(), liferayOAuth2Applications.getExternalReferenceCodes());
		assertEquals(List.of(), liferayOAuth2Applications.list());
	}

	@Test
	public void testTokenURIDefaultsToTheBoundInstance() {
		LiferayOAuth2Applications liferayOAuth2Applications = _build(
			Map.of(
				LiferayDXPConnection.MAIN_DOMAIN, "acme.lxc.liferay.com",
				LiferayDXPConnection.SERVER_PROTOCOL, "https",
				LiferayOAuth2Applications.EXTERNAL_REFERENCE_CODES, "acme-erc",
				"acme-erc.oauth2.headless.server.client.id", "id-123",
				"acme-erc.oauth2.headless.server.client.secret", "secret-456"));

		List<LiferayOAuth2Application> liferayOAuth2Applications2 =
			liferayOAuth2Applications.list();

		assertEquals(1, liferayOAuth2Applications2.size());

		LiferayOAuth2Application liferayOAuth2Application =
			liferayOAuth2Applications2.get(0);

		assertEquals(
			"https://acme.lxc.liferay.com/o/oauth2/token",
			String.valueOf(liferayOAuth2Application.tokenURI()));
		assertTrue(liferayOAuth2Application.hasClientCredentials());
	}

	@Test
	public void testTokenURIIsAbsoluteWhenOverriddenWithAFullURL() {
		LiferayOAuth2Applications liferayOAuth2Applications = _build(
			Map.of(
				LiferayDXPConnection.MAIN_DOMAIN, "acme.lxc.liferay.com",
				LiferayDXPConnection.SERVER_PROTOCOL, "https",
				LiferayOAuth2Applications.EXTERNAL_REFERENCE_CODES, "acme-erc",
				"acme-erc.oauth2.headless.server.client.id", "id-123",
				"acme-erc.oauth2.headless.server.client.secret", "secret-456",
				"acme-erc.oauth2.token.uri",
				"https://auth.example.com/oauth2/token"));

		assertEquals(
			"https://auth.example.com/oauth2/token",
			String.valueOf(
				liferayOAuth2Applications.list(
				).get(
					0
				).tokenURI()));
	}

	private LiferayOAuth2Applications _build(Map<String, String> properties) {
		LiferayProperties liferayProperties = LiferayProperties.from(
			properties);

		return new LiferayOAuth2Applications(
			new LiferayDXPConnection(liferayProperties), liferayProperties,
			LiferayOAuth2ApplicationLookup.NONE);
	}

}
