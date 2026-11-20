/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.core;

import java.util.Map;

/**
 * Reads <code>/o/oauth2/application</code> for the cases where Liferay Cloud
 * did not inject the client ID.
 *
 * <p>
 * An interface rather than a class, because <em>how</em> to make one
 * unauthenticated GET and parse a flat JSON object is exactly the kind of thing
 * that should be the host framework's problem. Core ships
 * {@link JdkLiferayOAuth2ApplicationLookup} so it works standalone; the Spring
 * adapter supplies a <code>RestClient</code> implementation instead.
 * </p>
 *
 * <p>
 * That indirection is load bearing for Spring Boot 4. Boot 4 auto-configures
 * Jackson 3 (<code>tools.jackson</code>), not Jackson 2
 * (<code>com.fasterxml.jackson</code>), so any bean that injects a
 * <code>com.fasterxml.jackson.databind.ObjectMapper</code> stops resolving. An
 * implementation built on <code>RestClient</code> names no Jackson type at all
 * and works on either, because the message converters are the application's.
 * </p>
 */
public interface LiferayOAuth2ApplicationLookup {

	public static final LiferayOAuth2ApplicationLookup NONE =
		externalReferenceCode -> Map.of();

	public Map<String, String> lookup(String externalReferenceCode);

	public default String lookupClientId(String externalReferenceCode) {
		Map<String, String> applicationInfo = lookup(externalReferenceCode);

		if (applicationInfo == null) {
			return null;
		}

		return applicationInfo.get("client_id");
	}

	public default String lookupHomePageURL(String externalReferenceCode) {
		Map<String, String> applicationInfo = lookup(externalReferenceCode);

		if (applicationInfo == null) {
			return null;
		}

		return applicationInfo.get("homePageURL");
	}

}
