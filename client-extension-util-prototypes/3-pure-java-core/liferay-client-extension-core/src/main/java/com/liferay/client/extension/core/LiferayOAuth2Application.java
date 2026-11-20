/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.core;

import java.net.URI;

/**
 * One OAuth application, as Liferay describes it to a client extension.
 *
 * <p>
 * A plain record. This is what the 278 lines of
 * <code>LiferayOAuth2ClientConfiguration</code> were producing all along,
 * wrapped in a <code>ClientRegistration.Builder</code> so that the shape was
 * never visible or testable on its own.
 * </p>
 */
public record LiferayOAuth2Application(
	String externalReferenceCode, String headlessServerClientId,
	String headlessServerClientSecret, URI tokenURI, String userAgentClientId) {

	public boolean hasClientCredentials() {
		return (headlessServerClientId != null) &&
			   (headlessServerClientSecret != null);
	}

}
