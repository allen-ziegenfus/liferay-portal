/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.gradle.plugins.workspace.internal.client.extension;

import java.util.LinkedHashMap;
import java.util.Map;

import org.junit.Assert;
import org.junit.Test;

/**
 * @author Gregory Amerson
 */
public class ClientExtensionDescriptorTest {

	@Test
	public void testDerive() {
		Map<String, Object> lcpMap = new LinkedHashMap<>();

		lcpMap.put("cpu", 0.5);
		lcpMap.put("env", Map.of("A", "lcp", "PORT", 58081));
		lcpMap.put("environments", Map.of("infra", Map.of("deploy", false)));
		lcpMap.put("loadBalancer", Map.of("targetPort", 58081));
		lcpMap.put("scale", 2);

		Map<String, Object> clientExtensionMap = _derive(
			Map.of("key~able", Map.of()), "liferay/jar-runner:latest", lcpMap);

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
		Assert.assertSame(lcpMap, clientExtensionMap.get("lcp"));
		Assert.assertEquals(
			ClientExtensionDescriptor.TYPE_SERVICE,
			clientExtensionMap.get("type"));
	}

	@Test
	public void testDeriveWhenIsConfigurationOnly() {
		Map<String, Object> lcpMap = Map.of("kind", "Job");

		Map<String, Object> clientExtensionMap = _derive(
			Map.of(), "liferay/noop", lcpMap);

		Assert.assertNull(clientExtensionMap.get("image"));
		Assert.assertSame(lcpMap, clientExtensionMap.get("lcp"));
		Assert.assertEquals(
			ClientExtensionDescriptor.TYPE_CONFIGURATION,
			clientExtensionMap.get("type"));
	}

	@Test
	public void testGetBaseImage() {
		Assert.assertEquals(
			"liferay/caddy:latest",
			ClientExtensionDescriptor.getBaseImage(
				"# A comment\nFROM --platform=linux/amd64 " +
					"liferay/caddy:latest AS base\nFROM other"));
		Assert.assertEquals(
			"", ClientExtensionDescriptor.getBaseImage("COPY . /public_html"));
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
		Map<String, Object> configsMap, String baseImage,
		Map<String, Object> lcpMap) {

		Map<String, Object> descriptorMap = ClientExtensionDescriptor.derive(
			baseImage, configsMap, "sha256:1", "registry/able", "1.0.0",
			lcpMap);

		Assert.assertEquals(descriptorMap.toString(), 1, descriptorMap.size());

		return (Map<String, Object>)descriptorMap.get("clientExtension");
	}

}