/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot.autoconfigure;

import java.util.LinkedHashSet;
import java.util.Set;

import org.springframework.core.env.Environment;

/**
 * The user agent client IDs this client extension will accept tokens from.
 *
 * <p>
 * Static resolution only, from the properties Liferay Cloud injected. The
 * <code>/o/oauth2/application</code> fallback is deliberately absent from this
 * option, and that is the honest limitation of the approach: an
 * <code>EnvironmentPostProcessor</code> runs before the application context
 * exists, so it cannot make a blocking HTTP call without stalling startup on a
 * network round trip to a DXP that may not be up yet.
 * </p>
 *
 * <p>
 * In practice Liferay Cloud injects
 * <code>&lt;erc&gt;.oauth2.user.agent.client.id</code> for every registered
 * client extension, so the fallback fires only in local development and in the
 * case where a client extension is deployed before its OAuth application
 * exists. If that case has to be supported, this option needs the small lazy
 * lookup bean from Option 3 alongside it, which is a fair reason to treat the
 * two as complementary rather than competing.
 * </p>
 */
public class LiferayClientIds {

	public static Set<String> of(Environment environment) {
		Set<String> clientIds = new LinkedHashSet<>();

		String externalReferenceCodes = environment.getProperty(
			"liferay.oauth.application.external.reference.codes", "");

		for (String externalReferenceCode :
				externalReferenceCodes.split("\\s*,\\s*")) {

			if (externalReferenceCode.isBlank()) {
				continue;
			}

			String clientId = environment.getProperty(
				externalReferenceCode + ".oauth2.user.agent.client.id");

			if (clientId != null) {
				clientIds.add(clientId);
			}
		}

		return clientIds;
	}

}
