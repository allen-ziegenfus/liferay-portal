/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot;

import com.liferay.client.extension.core.LiferayDXPConnection;

import java.net.URI;

import java.util.Map;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestClient;

/**
 * The <code>BaseService</code> replacement, and it lives in the adapter rather
 * than the core.
 *
 * <p>
 * That placement answers the obvious question about this option. A useful HTTP
 * client for a Spring application returns <code>ResponseEntity</code>, takes
 * <code>HttpMethod</code>, and is built from the consumer's configured
 * <code>RestClient.Builder</code> so their interceptors, timeouts and
 * observability apply. Every one of those is a Spring type. Pushing this into a
 * dependency-free core would mean inventing a parallel request and response
 * model and then translating it, which is more code and worse ergonomics for no
 * gain.
 * </p>
 *
 * <p>
 * The only Liferay knowledge involved is resolving a relative URI against the
 * bound instance, and that comes from
 * {@link LiferayDXPConnection#getBaseURI()} in the core.
 * </p>
 */
public class LiferayRestClient {

	public LiferayRestClient(
		LiferayDXPConnection liferayDXPConnection, RestClient restClient) {

		_liferayDXPConnection = liferayDXPConnection;
		_restClient = restClient;
	}

	public ResponseEntity<String> delete(
		URI uri, Map<String, String> httpHeadersMap) {

		return exchange(HttpMethod.DELETE, uri, null, httpHeadersMap);
	}

	public ResponseEntity<String> exchange(
		HttpMethod httpMethod, URI uri, Object body,
		Map<String, String> httpHeadersMap) {

		return exchange(httpMethod, uri, body, httpHeadersMap, String.class);
	}

	public <T> ResponseEntity<T> exchange(
		HttpMethod httpMethod, URI uri, Object body,
		Map<String, String> httpHeadersMap, Class<T> responseType) {

		RestClient.RequestBodySpec requestBodySpec = _restClient.method(
			httpMethod
		).uri(
			resolve(uri)
		).headers(
			httpHeaders -> _addHeaders(httpHeaders, httpHeadersMap)
		);

		if (body != null) {
			requestBodySpec.body(body);
		}

		return requestBodySpec.retrieve(
		).onStatus(
			httpStatusCode -> true, (request, response) -> {
			}
		).toEntity(
			responseType
		);
	}

	public ResponseEntity<String> get(
		URI uri, Map<String, String> httpHeadersMap) {

		return exchange(HttpMethod.GET, uri, null, httpHeadersMap);
	}

	public ResponseEntity<String> post(
		URI uri, Object body, Map<String, String> httpHeadersMap) {

		return exchange(HttpMethod.POST, uri, body, httpHeadersMap);
	}

	public ResponseEntity<String> put(
		URI uri, Object body, Map<String, String> httpHeadersMap) {

		return exchange(HttpMethod.PUT, uri, body, httpHeadersMap);
	}

	public URI resolve(URI uri) {
		if (uri.isAbsolute()) {
			return uri;
		}

		return _liferayDXPConnection.getBaseURI(
		).resolve(
			uri
		);
	}

	public RestClient restClient() {
		return _restClient;
	}

	private void _addHeaders(
		HttpHeaders httpHeaders, Map<String, String> httpHeadersMap) {

		if (httpHeadersMap == null) {
			return;
		}

		httpHeadersMap.forEach(httpHeaders::add);
	}

	private final LiferayDXPConnection _liferayDXPConnection;
	private final RestClient _restClient;

}
