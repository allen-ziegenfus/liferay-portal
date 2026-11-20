/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.sample;

import com.liferay.client.extension.core.LiferayDXPConnection;
import com.liferay.client.extension.core.LiferayOAuth2Application;
import com.liferay.client.extension.core.LiferayOAuth2Applications;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * Where the split does become visible to a consumer.
 *
 * <p>
 * A cron-style client extension - the shape of
 * <code>liferay-ticket-etc-cron</code> and <code>liferay-partner-etc-cron</code>
 * in this repo - needs the resolved DXP base URI and the registered external
 * reference codes, and has no HTTP request to hang them off.
 * </p>
 *
 * <p>
 * Against the shipping library there are two ways to get them, and both are
 * bad. Either extend <code>BaseService</code>, inheriting twenty-four HTTP
 * methods and an <code>@RestController</code> ancestor in order to read two
 * <code>protected</code> <code>@Value</code> fields, or re-derive the base URL
 * from the raw properties by hand and duplicate the string concatenation the
 * library already does in five places.
 * </p>
 *
 * <p>
 * Here they are ordinary beans with no Spring in their own type hierarchy.
 * </p>
 */
@Component
public class SampleCronRunner implements CommandLineRunner {

	public SampleCronRunner(
		LiferayDXPConnection liferayDXPConnection,
		LiferayOAuth2Applications liferayOAuth2Applications) {

		_liferayDXPConnection = liferayDXPConnection;
		_liferayOAuth2Applications = liferayOAuth2Applications;
	}

	@Override
	public void run(String... args) {
		if (!_log.isInfoEnabled()) {
			return;
		}

		_log.info("Bound DXP: " + _liferayDXPConnection.getBaseURI());

		for (LiferayOAuth2Application liferayOAuth2Application :
				_liferayOAuth2Applications.list()) {

			_log.info(
				liferayOAuth2Application.externalReferenceCode() + " token: " +
					liferayOAuth2Application.tokenURI());
		}
	}

	private static final Log _log = LogFactory.getLog(SampleCronRunner.class);

	private final LiferayDXPConnection _liferayDXPConnection;
	private final LiferayOAuth2Applications _liferayOAuth2Applications;

}
