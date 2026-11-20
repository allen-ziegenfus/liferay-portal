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
import org.springframework.web.reactive.function.client.WebClient;

import reactor.core.publisher.Mono;

/**
 * The reactive counterpart to {@link LiferayRestClient}, registered only when
 * <code>spring-webflux</code> is on the consumer's classpath.
 *
 * <p>
 * This is the reason the split matters. <code>BaseService</code> was built on
 * <code>WebClient</code> and then called <code>block()</code> on every method,
 * so every consumer paid for the entire reactive stack in order to make
 * blocking calls. Making the reactive client conditional lets an ordinary MVC
 * client extension drop <code>spring-boot-starter-webflux</code> and Reactor
 * Netty from its runtime entirely.
 * </p>
 */
public class LiferayWebClient {

	public LiferayWebClient(WebClient webClient, URI baseURI) {
		_webClient = webClient;
		_baseURI = baseURI;
	}

	public Mono<ResponseEntity<String>> exchange(
		HttpMethod httpMethod, URI uri, Object body,
		Map<String, String> httpHeadersMap) {

		WebClient.RequestBodySpec requestBodySpec = _webClient.method(
			httpMethod
		).uri(
			resolve(uri)
		).headers(
			httpHeaders -> _addHeaders(httpHeaders, httpHeadersMap)
		);

		if (body != null) {
			requestBodySpec.bodyValue(body);
		}

		return requestBodySpec.retrieve(
		).toEntity(
			String.class
		);
	}

	public Mono<ResponseEntity<String>> get(
		URI uri, Map<String, String> httpHeadersMap) {

		return exchange(HttpMethod.GET, uri, null, httpHeadersMap);
	}

	public URI resolve(URI uri) {
		if (uri.isAbsolute()) {
			return uri;
		}

		return _baseURI.resolve(uri);
	}

	public WebClient webClient() {
		return _webClient;
	}

	private void _addHeaders(
		HttpHeaders httpHeaders, Map<String, String> httpHeadersMap) {

		if (httpHeadersMap == null) {
			return;
		}

		httpHeadersMap.forEach(httpHeaders::add);
	}

	private final URI _baseURI;
	private final WebClient _webClient;

}
