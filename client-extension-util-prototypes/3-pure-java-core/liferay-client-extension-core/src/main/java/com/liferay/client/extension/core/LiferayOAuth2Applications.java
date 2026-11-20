/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.core;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * The property naming convention Liferay Cloud injects, and nothing else.
 *
 * <p>
 * This class is the answer to "what does this library actually know that a
 * customer could not write themselves in ten minutes". It is a hundred lines,
 * it has no dependencies, and it survives every Spring release ever made
 * because it does not import Spring.
 * </p>
 */
public class LiferayOAuth2Applications {

	public static final String EXTERNAL_REFERENCE_CODES =
		"liferay.oauth.application.external.reference.codes";

	public LiferayOAuth2Applications(
		LiferayDXPConnection liferayDXPConnection,
		LiferayProperties liferayProperties,
		LiferayOAuth2ApplicationLookup liferayOAuth2ApplicationLookup) {

		_liferayDXPConnection = liferayDXPConnection;
		_liferayProperties = liferayProperties;
		_liferayOAuth2ApplicationLookup = liferayOAuth2ApplicationLookup;
	}

	public Optional<LiferayOAuth2Application> find(
		String externalReferenceCode) {

		String headlessServerClientId = _resolve(
			externalReferenceCode, ".oauth2.headless.server.client.id");
		String userAgentClientId = _resolve(
			externalReferenceCode, ".oauth2.user.agent.client.id");

		if ((headlessServerClientId == null) && (userAgentClientId == null)) {
			return Optional.empty();
		}

		return Optional.of(
			new LiferayOAuth2Application(
				externalReferenceCode, headlessServerClientId,
				_liferayProperties.get(
					externalReferenceCode +
						".oauth2.headless.server.client.secret"),
				_liferayDXPConnection.resolve(
					_liferayProperties.get(
						externalReferenceCode + ".oauth2.token.uri",
						"/o/oauth2/token")),
				userAgentClientId));
	}

	/**
	 * The external reference codes this client extension was registered
	 * against.
	 *
	 * <p>
	 * Returns an empty list when the property is absent, rather than throwing.
	 * The current library throws <code>IllegalArgumentException</code> from
	 * two separate places, which means a client extension that only serves
	 * inbound requests cannot use the library at all without inventing a value
	 * for a property it has no use for.
	 * </p>
	 */
	public List<String> getExternalReferenceCodes() {
		return _liferayProperties.getList(EXTERNAL_REFERENCE_CODES);
	}

	public List<LiferayOAuth2Application> list() {
		List<LiferayOAuth2Application> liferayOAuth2Applications =
			new ArrayList<>();

		for (String externalReferenceCode : getExternalReferenceCodes()) {
			find(externalReferenceCode).ifPresent(
				liferayOAuth2Applications::add);
		}

		return liferayOAuth2Applications;
	}

	private String _resolve(String externalReferenceCode, String suffix) {
		String clientId = _liferayProperties.get(
			externalReferenceCode + suffix);

		if (clientId != null) {
			return clientId;
		}

		// Liferay Cloud did not inject it, so ask DXP. This is the only part
		// of the class that touches the network, and it is behind an
		// interface so that a unit test never does.

		return _liferayOAuth2ApplicationLookup.lookupClientId(
			externalReferenceCode);
	}

	private final LiferayDXPConnection _liferayDXPConnection;
	private final LiferayOAuth2ApplicationLookup
		_liferayOAuth2ApplicationLookup;
	private final LiferayProperties _liferayProperties;

}
