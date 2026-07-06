/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.one.license;

import java.io.InputStream;

import java.util.Collections;
import java.util.Map;

import org.yaml.snakeyaml.Yaml;

/**
 * @author Allen Ziegenfus
 */
public class DetachedLicenseEntitlementNames {

	public static String getEntitlementName(String productKey, String sizing) {
		Map<String, String> entitlementNames = _entitlementNames.get(
			productKey);

		if (entitlementNames == null) {
			return null;
		}

		return entitlementNames.get(_normalizeSizing(sizing));
	}

	private static String _normalizeSizing(String sizing) {
		if ((sizing == null) || sizing.isEmpty()) {
			return "default";
		}

		if (sizing.startsWith("sizing-")) {
			return "Sizing " + sizing.substring(7);
		}

		return sizing;
	}

	private static final Map<String, Map<String, String>> _entitlementNames;

	static {
		Yaml yaml = new Yaml();

		try (InputStream inputStream =
				DetachedLicenseEntitlementNames.class.getResourceAsStream(
					"/detached-license-entitlement-names.yaml")) {

			Map<String, Map<String, String>> entitlementNames = yaml.load(
				inputStream);

			_entitlementNames = Collections.unmodifiableMap(entitlementNames);
		}
		catch (Exception exception) {
			throw new ExceptionInInitializerError(exception);
		}
	}

}