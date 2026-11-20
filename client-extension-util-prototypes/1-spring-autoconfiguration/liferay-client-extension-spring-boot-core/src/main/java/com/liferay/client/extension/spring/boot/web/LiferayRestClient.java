/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot.web;

import java.net.URI;

import java.util.Map;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestClient;

/**
 * Blocking HTTP access to the DXP instance this client extension is bound to.
 *
 * <p>
 * Three deliberate departures from <code>BaseService</code>:
 * </p>
 *
 * <ul>
 * <li>It is a bean, not a superclass. Nothing has to extend anything to make
 * an HTTP call, so the class hierarchy of the consumer stays theirs.</li>
 * <li>It returns <code>ResponseEntity</code>. The status code and the response
 * headers survive the call, so callers can read <code>Location</code>,
 * <code>ETag</code> or <code>Retry-After</code>, and can tell 200 from 201
 * from 204.</li>
 * <li>It does not interpret the body. A 204 stays a 204 with a null body
 * rather than becoming the string <code>"{}"</code>, and a non-2xx status is
 * returned rather than translated into an exception. Callers who want the
 * throwing behavior compose it themselves.</li>
 * </ul>
 *
 * <p>
 * The underlying {@link RestClient} is built once by the auto-configuration
 * and shared. <code>BaseService</code> constructed a new client and a new
 * 500-connection <code>ConnectionProvider</code> on every single request.
 * </p>
 */
public class LiferayRestClient {

	public LiferayRestClient(RestClient restClient, URI baseURI) {
		_restClient = restClient;
		_baseURI = baseURI;
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

	public <T> ResponseEntity<T> get(
		URI uri, Map<String, String> httpHeadersMap, Class<T> responseType) {

		return exchange(HttpMethod.GET, uri, null, httpHeadersMap, responseType);
	}

	public ResponseEntity<String> patch(
		URI uri, Object body, Map<String, String> httpHeadersMap) {

		return exchange(HttpMethod.PATCH, uri, body, httpHeadersMap);
	}

	public ResponseEntity<String> post(
		URI uri, Object body, Map<String, String> httpHeadersMap) {

		return exchange(HttpMethod.POST, uri, body, httpHeadersMap);
	}

	public ResponseEntity<String> put(
		URI uri, Object body, Map<String, String> httpHeadersMap) {

		return exchange(HttpMethod.PUT, uri, body, httpHeadersMap);
	}

	/**
	 * Resolves a relative URI against the DXP base URI. Absolute URIs are
	 * returned untouched, so the same client can call third party APIs.
	 */
	public URI resolve(URI uri) {
		if (uri.isAbsolute()) {
			return uri;
		}

		return _baseURI.resolve(uri);
	}

	/**
	 * The escape hatch. Anything this class does not model is still reachable
	 * without giving up the configured connection pool and base URI.
	 */
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

	private final URI _baseURI;
	private final RestClient _restClient;

}
