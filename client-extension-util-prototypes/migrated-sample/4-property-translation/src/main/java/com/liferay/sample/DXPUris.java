/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.sample;

import java.net.URI;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * THE COST OF OPTION 4, MADE CONCRETE.
 *
 * <p>
 * Option 4 ships no HTTP client, so it also ships no base-URI resolution. The
 * consumer writes this. Fourteen lines, and every client extension that calls
 * back into Liferay writes its own copy.
 * </p>
 *
 * <p>
 * Which is the honest objection to the option: hand enough back to Spring Boot
 * and the small Liferay-shaped remainder does not disappear, it reappears in
 * userland, uncoordinated and unversioned. Whether that trade is worth it
 * depends on whether "call the bound DXP" is a thing we want to have one
 * answer to.
 * </p>
 */
@Component
public class DXPUris {

	public URI resolve(String path) {
		if (path.contains("://")) {
			return URI.create(path);
		}

		return URI.create(
			_lxcDXPServerProtocol + "://" + _lxcDXPMainDomain
		).resolve(
			path
		);
	}

	@Value("${com.liferay.lxc.dxp.mainDomain}")
	private String _lxcDXPMainDomain;

	@Value("${com.liferay.lxc.dxp.server.protocol}")
	private String _lxcDXPServerProtocol;

}
