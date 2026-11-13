/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.gradle.plugins.workspace.internal.client.extension;

import com.liferay.gradle.plugins.workspace.internal.util.StringUtil;

import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.TreeMap;

import org.gradle.api.GradleException;

/**
 * @author Gregory Amerson
 */
public class ClientExtensionDescriptor {

	public static final String FILE_NAME = "client-extension-descriptor.json";

	public static final String LABEL_VERSION =
		"com.liferay.client-extension.descriptor.version";

	public static final String TYPE_BATCH = "batch";

	public static final String TYPE_CONFIGURATION = "configuration";

	public static final String TYPE_FRONTEND = "frontend";

	public static final String TYPE_SERVICE = "service";

	public static final int VERSION = 1;

	public static Map<String, Object> derive(
		String baseImage, Map<String, Object> configsMap, String imageDigest,
		String imageRepository, String imageTag) {

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

		String oAuthApplicationHeadlessServerERC =
			_getOAuthApplicationHeadlessServerERC(configsMap);

		if (oAuthApplicationHeadlessServerERC != null) {
			clientExtensionMap.put(
				"oauthApplicationHeadlessServerERC",
				oAuthApplicationHeadlessServerERC);
		}

		clientExtensionMap.put("type", type);

		return Collections.singletonMap("clientExtension", clientExtensionMap);
	}

	/**
	 * Returns the image that the last stage of a Dockerfile builds on, which
	 * is the image the client extension runs. When that stage builds on an
	 * earlier stage, as in FROM build, it returns the earlier stage's image.
	 */
	public static String getBaseImage(String dockerfileText) {
		String baseImage = "";

		Map<String, String> stageBaseImageMap = new HashMap<>();

		for (String line : dockerfileText.split("\n")) {
			String trimmedLine = line.trim();

			String[] tokens = trimmedLine.split("\\s+");

			if (!tokens[0].equalsIgnoreCase("FROM")) {
				continue;
			}

			int i = 1;

			while ((i < tokens.length) && tokens[i].startsWith("--")) {
				i++;
			}

			if (i == tokens.length) {
				continue;
			}

			baseImage = stageBaseImageMap.getOrDefault(
				StringUtil.toLowerCase(tokens[i]), tokens[i]);

			if (((i + 2) >= tokens.length) ||
				!tokens[i + 1].equalsIgnoreCase("AS")) {

				continue;
			}

			stageBaseImageMap.put(
				StringUtil.toLowerCase(tokens[i + 2]), baseImage);
		}

		return baseImage;
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

	private static String _getOAuthApplicationHeadlessServerERC(
		Map<String, Object> configsMap) {

		String oAuthApplicationHeadlessServerERC = null;

		for (String configurationKey : configsMap.keySet()) {
			int index = configurationKey.indexOf(
				_CONFIGURATION_KEY_HEADLESS_SERVER);

			if (index < 0) {
				continue;
			}

			String identifier = configurationKey.substring(
				index + _CONFIGURATION_KEY_HEADLESS_SERVER.length());

			index = identifier.indexOf('/');

			if (index >= 0) {
				identifier = identifier.substring(0, index);
			}

			if ((oAuthApplicationHeadlessServerERC != null) &&
				!oAuthApplicationHeadlessServerERC.equals(identifier)) {

				throw new GradleException(
					"Unable to choose between OAuth 2 headless server " +
						"applications \"" + oAuthApplicationHeadlessServerERC +
							"\" and \"" + identifier + "\"");
			}

			oAuthApplicationHeadlessServerERC = identifier;
		}

		return oAuthApplicationHeadlessServerERC;
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

	private static final String _CONFIGURATION_KEY_HEADLESS_SERVER =
		"com.liferay.oauth2.provider.configuration." +
			"OAuth2ProviderApplicationHeadlessServerConfiguration~";

}