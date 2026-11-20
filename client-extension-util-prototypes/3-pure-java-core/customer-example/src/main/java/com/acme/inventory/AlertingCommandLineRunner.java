/**
 * SPDX-FileCopyrightText: (c) 2026 Acme, Inc.
 * SPDX-License-Identifier: Apache-2.0
 */

package com.acme.inventory;

import com.liferay.client.extension.core.LiferayDXPConnection;
import com.liferay.client.extension.core.LiferayOAuth2Application;
import com.liferay.client.extension.core.LiferayOAuth2Applications;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * The second reason to want a Spring-free core: consumers can use it outside a
 * web request too, and they can reason about it without knowing Spring.
 *
 * <p>
 * This is a cron-style client extension - the shape of
 * <code>liferay-ticket-etc-cron</code> and <code>liferay-partner-etc-cron</code>
 * in this repo. Under the current library, reaching the resolved DXP base URI or
 * the registered external reference codes from a
 * <code>CommandLineRunner</code> means either extending <code>BaseService</code>
 * (inheriting twenty-four HTTP methods and an <code>@RestController</code>
 * ancestor to get at two <code>@Value</code> fields) or re-deriving the URL from
 * the raw properties by hand. Here they are ordinary beans.
 * </p>
 */
@Component
public class AlertingCommandLineRunner implements CommandLineRunner {

	public AlertingCommandLineRunner(
		LiferayDXPConnection liferayDXPConnection,
		LiferayOAuth2Applications liferayOAuth2Applications) {

		_liferayDXPConnection = liferayDXPConnection;
		_liferayOAuth2Applications = liferayOAuth2Applications;
	}

	@Override
	public void run(String... args) {
		System.out.println("Bound DXP: " + _liferayDXPConnection.getBaseURI());

		for (LiferayOAuth2Application liferayOAuth2Application :
				_liferayOAuth2Applications.list()) {

			System.out.println(
				liferayOAuth2Application.externalReferenceCode() +
					" -> " + liferayOAuth2Application.tokenURI());
		}
	}

	private final LiferayDXPConnection _liferayDXPConnection;
	private final LiferayOAuth2Applications _liferayOAuth2Applications;

}
