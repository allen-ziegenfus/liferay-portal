/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot.env;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;

import java.util.Map;

import org.junit.jupiter.api.Test;

import org.springframework.core.env.MapPropertySource;
import org.springframework.mock.env.MockEnvironment;

/**
 * A unit test against a MockEnvironment. No context, no mock server, no
 * running DXP.
 */
public class LiferayEnvironmentPostProcessorTest {

	@Test
	public void testConsumerPropertiesWinOverDerivedOnes() {
		MockEnvironment mockEnvironment = _mockEnvironment();

		mockEnvironment.getPropertySources(
		).addFirst(
			new MapPropertySource(
				"application",
				Map.of(
					"spring.security.oauth2.client.provider.acme-erc.token-uri",
					"https://auth.example.com/oauth2/token"))
		);

		_liferayEnvironmentPostProcessor.postProcessEnvironment(
			mockEnvironment, null);

		assertEquals(
			"https://auth.example.com/oauth2/token",
			mockEnvironment.getProperty(
				"spring.security.oauth2.client.provider.acme-erc.token-uri"));
	}

	@Test
	public void testContributesNothingOutsideLiferayCloud() {
		MockEnvironment mockEnvironment = new MockEnvironment();

		_liferayEnvironmentPostProcessor.postProcessEnvironment(
			mockEnvironment, null);

		assertFalse(
			mockEnvironment.getPropertySources(
			).contains(
				LiferayEnvironmentPostProcessor.PROPERTY_SOURCE_NAME
			));
	}

	@Test
	public void testDerivesStandardSpringSecurityProperties() {
		MockEnvironment mockEnvironment = _mockEnvironment();

		_liferayEnvironmentPostProcessor.postProcessEnvironment(
			mockEnvironment, null);

		assertEquals(
			"https://acme.lxc.liferay.com/o/oauth2/jwks",
			mockEnvironment.getProperty(
				"spring.security.oauth2.resourceserver.jwt.jwk-set-uri"));
		assertEquals(
			"id-123",
			mockEnvironment.getProperty(
				"spring.security.oauth2.client.registration.acme-erc." +
					"client-id"));
		assertEquals(
			"client_credentials",
			mockEnvironment.getProperty(
				"spring.security.oauth2.client.registration.acme-erc." +
					"authorization-grant-type"));
		assertEquals(
			"https://acme.lxc.liferay.com/o/oauth2/token",
			mockEnvironment.getProperty(
				"spring.security.oauth2.client.provider.acme-erc.token-uri"));
	}

	@Test
	public void testSkipsExternalReferenceCodesWithoutCredentials() {
		MockEnvironment mockEnvironment = new MockEnvironment();

		mockEnvironment.setProperty(
			"com.liferay.lxc.dxp.mainDomain", "acme.lxc.liferay.com");
		mockEnvironment.setProperty(
			"liferay.oauth.application.external.reference.codes",
			"inbound-only-erc");

		_liferayEnvironmentPostProcessor.postProcessEnvironment(
			mockEnvironment, null);

		// The resource server still gets configured; the client half simply
		// does not appear. The current library throws IllegalArgumentException
		// in this situation.

		assertEquals(
			"https://acme.lxc.liferay.com/o/oauth2/jwks",
			mockEnvironment.getProperty(
				"spring.security.oauth2.resourceserver.jwt.jwk-set-uri"));
		assertNull(
			mockEnvironment.getProperty(
				"spring.security.oauth2.client.registration.inbound-only-erc." +
					"client-id"));
	}

	private MockEnvironment _mockEnvironment() {
		MockEnvironment mockEnvironment = new MockEnvironment();

		mockEnvironment.setProperty(
			"com.liferay.lxc.dxp.mainDomain", "acme.lxc.liferay.com");
		mockEnvironment.setProperty(
			"com.liferay.lxc.dxp.server.protocol", "https");
		mockEnvironment.setProperty(
			"liferay.oauth.application.external.reference.codes", "acme-erc");
		mockEnvironment.setProperty(
			"acme-erc.oauth2.headless.server.client.id", "id-123");
		mockEnvironment.setProperty(
			"acme-erc.oauth2.headless.server.client.secret", "secret-456");

		return mockEnvironment;
	}

	private final LiferayEnvironmentPostProcessor
		_liferayEnvironmentPostProcessor =
			new LiferayEnvironmentPostProcessor();

}
