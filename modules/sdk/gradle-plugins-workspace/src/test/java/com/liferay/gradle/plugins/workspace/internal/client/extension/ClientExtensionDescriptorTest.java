/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.gradle.plugins.workspace.internal.client.extension;

import com.liferay.gradle.plugins.workspace.internal.util.StringUtil;

import java.util.Map;

import org.gradle.api.GradleException;

import org.junit.Assert;
import org.junit.Test;

/**
 * @author Gregory Amerson
 */
public class ClientExtensionDescriptorTest {

	@Test
	public void testDerive() {
		Map<String, Object> clientExtensionMap = _derive(
			Map.of("key~able", Map.of()), "liferay/jar-runner:latest");

		Assert.assertEquals(
			Map.of("key~able", Map.of()), clientExtensionMap.get("configs"));
		Assert.assertEquals(
			ClientExtensionDescriptor.VERSION,
			clientExtensionMap.get("descriptorVersion"));
		Assert.assertEquals(
			Map.of(
				"digest", "sha256:1", "repository", "registry/able", "tag",
				"1.0.0"),
			clientExtensionMap.get("image"));
		Assert.assertNull(
			clientExtensionMap.get("oauthApplicationHeadlessServerERC"));
		Assert.assertNull(clientExtensionMap.get("serviceId"));
		Assert.assertEquals(
			ClientExtensionDescriptor.TYPE_SERVICE,
			clientExtensionMap.get("type"));
		Assert.assertNull(clientExtensionMap.get("workload"));
	}

	@Test
	public void testDeriveWhenIsBatch() {
		Map<String, Object> clientExtensionMap = _derive(
			Map.of(
				"com.liferay.oauth2.provider.configuration." +
					"OAuth2ProviderApplicationHeadlessServerConfiguration~" +
						"able-batch/liferay.com",
				Map.of()),
			"liferay/batch:latest");

		Assert.assertEquals(
			"able-batch",
			clientExtensionMap.get("oauthApplicationHeadlessServerERC"));
		Assert.assertEquals(
			ClientExtensionDescriptor.TYPE_BATCH,
			clientExtensionMap.get("type"));

		clientExtensionMap = _derive(
			Map.of(
				_CONFIGURATION_KEY_HEADLESS_SERVER + "able-batch/able.com",
				Map.of(),
				_CONFIGURATION_KEY_HEADLESS_SERVER + "able-batch/liferay.com",
				Map.of()),
			"liferay/batch:latest");

		Assert.assertEquals(
			"able-batch",
			clientExtensionMap.get("oauthApplicationHeadlessServerERC"));

		try {
			_derive(
				Map.of(
					_CONFIGURATION_KEY_HEADLESS_SERVER +
						"able-batch/liferay.com",
					Map.of(),
					_CONFIGURATION_KEY_HEADLESS_SERVER +
						"baker-batch/liferay.com",
					Map.of()),
				"liferay/batch:latest");

			Assert.fail();
		}
		catch (GradleException gradleException) {
			String message = gradleException.getMessage();

			Assert.assertTrue(message, message.contains("able-batch"));
			Assert.assertTrue(message, message.contains("baker-batch"));
		}
	}

	@Test
	public void testDeriveWhenIsConfigurationOnly() {
		Map<String, Object> clientExtensionMap = _derive(
			Map.of(), "liferay/noop");

		Assert.assertNull(clientExtensionMap.get("image"));
		Assert.assertEquals(
			ClientExtensionDescriptor.TYPE_CONFIGURATION,
			clientExtensionMap.get("type"));
		Assert.assertNull(clientExtensionMap.get("workload"));
	}

	@Test
	public void testGetBaseImage() {
		Assert.assertEquals(
			"liferay/caddy:latest",
			ClientExtensionDescriptor.getBaseImage(
				"# A comment\nFROM --platform=linux/amd64 " +
					"liferay/caddy:latest\nCOPY . /public_html"));
		Assert.assertEquals(
			"", ClientExtensionDescriptor.getBaseImage("COPY . /public_html"));
	}

	@Test
	public void testGetBaseImageWhenIsMultiStage() {
		String dockerfileText = StringUtil.concat(
			"FROM gradle:8-jdk21 AS build\n", "RUN gradle bootJar\n",
			"FROM liferay/caddy:latest\n",
			"COPY --from=build /out /public_html");

		Assert.assertEquals(
			"liferay/caddy:latest",
			ClientExtensionDescriptor.getBaseImage(dockerfileText));
		Assert.assertEquals(
			ClientExtensionDescriptor.TYPE_FRONTEND,
			ClientExtensionDescriptor.getType(
				ClientExtensionDescriptor.getBaseImage(dockerfileText)));

		Assert.assertEquals(
			"liferay/jar-runner:latest",
			ClientExtensionDescriptor.getBaseImage(
				StringUtil.concat(
					"FROM liferay/jar-runner:latest AS runtime\n",
					"from --platform=linux/amd64 gradle:8-jdk21 as Build\n",
					"RUN gradle bootJar\n", "FROM RUNTIME\n",
					"COPY --from=build /out /opt/liferay")));
	}

	@Test
	public void testGetRepository() {
		Assert.assertEquals(
			"localhost:5001/able",
			ClientExtensionDescriptor.getRepository(
				"localhost:5001/able:1.0.0@sha256:1"));
		Assert.assertEquals(
			"localhost:5001/able",
			ClientExtensionDescriptor.getRepository("localhost:5001/able"));
	}

	@Test
	public void testGetType() {
		Assert.assertEquals(
			ClientExtensionDescriptor.TYPE_FRONTEND,
			ClientExtensionDescriptor.getType("liferay/caddy:latest"));
		Assert.assertEquals(
			ClientExtensionDescriptor.TYPE_FRONTEND,
			ClientExtensionDescriptor.getType(
				"registry.example.com/liferay/caddy:latest"));
		Assert.assertEquals(
			ClientExtensionDescriptor.TYPE_SERVICE,
			ClientExtensionDescriptor.getType("myliferay/caddy:latest"));
	}

	private Map<String, Object> _derive(
		Map<String, Object> configsMap, String baseImage) {

		Map<String, Object> descriptorMap = ClientExtensionDescriptor.derive(
			baseImage, configsMap, "sha256:1", "registry/able", "1.0.0");

		Assert.assertEquals(descriptorMap.toString(), 1, descriptorMap.size());

		return (Map<String, Object>)descriptorMap.get("clientExtension");
	}

	private static final String _CONFIGURATION_KEY_HEADLESS_SERVER =
		"com.liferay.oauth2.provider.configuration." +
			"OAuth2ProviderApplicationHeadlessServerConfiguration~";

}