/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.core;

import java.io.IOException;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import java.time.Duration;

import java.util.Map;
import java.util.function.Function;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * The dependency-free implementation, on <code>java.net.http.HttpClient</code>
 * (in the JDK since 11).
 *
 * <p>
 * JSON parsing is still injected as a
 * <code>Function&lt;String, Map&lt;String, String&gt;&gt;</code>, so this class
 * picks no JSON library either. It exists so that core is usable on its own -
 * in a test, in a plain Java process, in a framework that has no HTTP client
 * worth borrowing. Inside a Spring application the adapter supplies a
 * <code>RestClient</code> implementation instead, which reuses the
 * application's own connection settings, interceptors and observability.
 * </p>
 */
public class JdkLiferayOAuth2ApplicationLookup
	implements LiferayOAuth2ApplicationLookup {

	public JdkLiferayOAuth2ApplicationLookup(
		HttpClient httpClient, Function<String, Map<String, String>> jsonParser,
		LiferayDXPConnection liferayDXPConnection) {

		_httpClient = httpClient;
		_jsonParser = jsonParser;
		_liferayDXPConnection = liferayDXPConnection;
	}

	@Override
	public Map<String, String> lookup(String externalReferenceCode) {
		URI uri = _liferayDXPConnection.resolve(
			"/o/oauth2/application?externalReferenceCode=" +
				externalReferenceCode);

		try {
			HttpResponse<String> httpResponse = _httpClient.send(
				HttpRequest.newBuilder(
					uri
				).header(
					"Accept", "application/json"
				).timeout(
					Duration.ofSeconds(10)
				).GET(
				).build(),
				HttpResponse.BodyHandlers.ofString());

			if (httpResponse.statusCode() != 200) {
				_logger.log(
					Level.WARNING,
					() -> uri + " returned " + httpResponse.statusCode());

				return null;
			}

			return _jsonParser.apply(httpResponse.body());
		}
		catch (InterruptedException interruptedException) {
			Thread.currentThread().interrupt();

			return null;
		}
		catch (IOException | RuntimeException exception) {
			_logger.log(
				Level.WARNING,
				() -> "Unable to read " + uri + ": " + exception.getMessage());

			return null;
		}
	}

	private static final Logger _logger = Logger.getLogger(
		JdkLiferayOAuth2ApplicationLookup.class.getName());

	private final HttpClient _httpClient;
	private final Function<String, Map<String, String>> _jsonParser;
	private final LiferayDXPConnection _liferayDXPConnection;

}
