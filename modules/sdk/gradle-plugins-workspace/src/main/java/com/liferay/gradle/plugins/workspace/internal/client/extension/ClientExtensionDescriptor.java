/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.gradle.plugins.workspace.internal.client.extension;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.TreeMap;

/**
 * @author Gregory Amerson
 */
public class ClientExtensionDescriptor {

	public static final String TYPE_BATCH = "batch";

	public static final String TYPE_CONFIGURATION = "configuration";

	public static final String TYPE_FRONTEND = "frontend";

	public static final String TYPE_SERVICE = "service";

	public static final int VERSION = 2;

	public static Map<String, Object> derive(
		String baseImage, Map<String, Object> configsMap, String imageDigest,
		String imageRepository, String imageTag, Map<String, Object> lcpMap) {

		String type = getType(baseImage);

		Map<String, Object> clientExtensionMap = new LinkedHashMap<>();

		clientExtensionMap.put("configs", new TreeMap<>(configsMap));
		clientExtensionMap.put("descriptorVersion", VERSION);

		if (!type.equals(TYPE_CONFIGURATION)) {
			Map<String, Object> imageMap = new LinkedHashMap<>();

			imageMap.put("digest", imageDigest);
			imageMap.put("repository", imageRepository);
			imageMap.put("tag", imageTag);

			clientExtensionMap.put("image", imageMap);
		}

		clientExtensionMap.put("lcp", lcpMap);
		clientExtensionMap.put("type", type);

		return Collections.singletonMap("clientExtension", clientExtensionMap);
	}

	public static String getBaseImage(String dockerfileText) {
		for (String line : dockerfileText.split("\n")) {
			String trimmedLine = line.trim();

			String[] tokens = trimmedLine.split("\\s+");

			if (!tokens[0].equalsIgnoreCase("FROM")) {
				continue;
			}

			for (int i = 1; i < tokens.length; i++) {
				if (!tokens[i].startsWith("--")) {
					return tokens[i];
				}
			}
		}

		return "";
	}

	public static String getRepository(String image) {
		int index = image.indexOf('@');

		if (index >= 0) {
			image = image.substring(0, index);
		}

		index = image.lastIndexOf(':');

		if (index > image.lastIndexOf('/')) {
			image = image.substring(0, index);
		}

		return image;
	}

	public static String getType(String baseImage) {
		String baseRepository = getRepository(baseImage);

		if (_isLiferayRepository(baseRepository, "batch")) {
			return TYPE_BATCH;
		}

		if (_isLiferayRepository(baseRepository, "caddy")) {
			return TYPE_FRONTEND;
		}

		if (_isLiferayRepository(baseRepository, "noop")) {
			return TYPE_CONFIGURATION;
		}

		return TYPE_SERVICE;
	}

	public static boolean isConfigurationOnly(String baseImage) {
		return TYPE_CONFIGURATION.equals(getType(baseImage));
	}

	private static boolean _isLiferayRepository(
		String repository, String name) {

		String liferayRepository = "liferay/" + name;

		if (repository.equals(liferayRepository) ||
			repository.endsWith("/" + liferayRepository)) {

			return true;
		}

		return false;
	}

}