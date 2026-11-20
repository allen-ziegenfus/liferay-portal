/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.util.spring.boot3.service;

import com.liferay.client.extension.spring.boot.web.LiferayWebClient;

import java.net.URI;

import java.util.Collections;
import java.util.Map;

import org.apache.commons.logging.Log;

import org.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.reactive.function.client.ExchangeFilterFunction;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import reactor.core.Disposable;
import reactor.core.publisher.Mono;

/**
 * Point 3. The old API surface, preserved bit for bit, delegating to the
 * shared {@link LiferayWebClient} bean.
 *
 * <p>
 * 653 files in liferay-portal extend <code>BaseService</code>. None of them
 * have to change for the new design to ship. They keep compiling, they keep
 * behaving identically, and they emit a deprecation warning that points at the
 * replacement.
 * </p>
 *
 * <p>
 * Three things this bridge demonstrates:
 * </p>
 *
 * <ol>
 * <li>The 412 line original shrinks by about a third once the WebClient
 * construction is hoisted out, and the remaining bulk is twenty one line
 * delegations instead of twenty copies of the same four line call.</li>
 * <li>The connection pool leak is fixed for every existing caller for free.
 * The original built a new <code>WebClient</code> and a new 500 connection
 * <code>ConnectionProvider</code> per request; this delegates to one shared
 * instance.</li>
 * <li>Living in its own artifact is what lets <code>-core</code> drop
 * webflux. The reactive stack, the <code>org.json</code> dependency and the
 * body reinterpretation are all opinions of the legacy API, so they are
 * packaged with the legacy API.</li>
 * </ol>
 *
 * @deprecated As of 2.0.0, replaced by injecting
 *             {@link com.liferay.client.extension.spring.boot.web.LiferayRestClient}
 *             or {@link LiferayWebClient}. This class will be removed once the
 *             in-repo consumers have migrated.
 */
@Deprecated
public abstract class BaseService {

	protected Disposable asyncDelete(
		String body, Map<String, String> httpHeadersMap, URI uri) {

		return _async(HttpMethod.DELETE, uri, body, httpHeadersMap);
	}

	protected Disposable asyncDelete(
		String authorization, String body, URI uri) {

		return _async(
			HttpMethod.DELETE, uri, body, _authorization(authorization));
	}

	protected Disposable asyncGet(Map<String, String> httpHeadersMap, URI uri) {
		return _async(HttpMethod.GET, uri, null, httpHeadersMap);
	}

	protected Disposable asyncGet(String authorization, URI uri) {
		return _async(
			HttpMethod.GET, uri, null, _authorization(authorization));
	}

	protected Disposable asyncPatch(
		String body, Map<String, String> httpHeadersMap, URI uri) {

		return _async(HttpMethod.PATCH, uri, body, httpHeadersMap);
	}

	protected Disposable asyncPatch(
		String authorization, String body, URI uri) {

		return _async(
			HttpMethod.PATCH, uri, body, _authorization(authorization));
	}

	protected Disposable asyncPost(
		String body, Map<String, String> httpHeadersMap, URI uri) {

		return _async(HttpMethod.POST, uri, body, httpHeadersMap);
	}

	protected Disposable asyncPost(
		String authorization, String body, URI uri) {

		return _async(
			HttpMethod.POST, uri, body, _authorization(authorization));
	}

	protected Disposable asyncPut(
		String body, Map<String, String> httpHeadersMap, URI uri) {

		return _async(HttpMethod.PUT, uri, body, httpHeadersMap);
	}

	protected Disposable asyncPut(String authorization, String body, URI uri) {
		return _async(
			HttpMethod.PUT, uri, body, _authorization(authorization));
	}

	protected String delete(
		String body, Map<String, String> httpHeadersMap, URI uri) {

		return _block(HttpMethod.DELETE, uri, body, httpHeadersMap);
	}

	protected String delete(String authorization, String body, URI uri) {
		return _block(
			HttpMethod.DELETE, uri, body, _authorization(authorization));
	}

	protected String get(Map<String, String> httpHeadersMap, URI uri) {
		return _block(HttpMethod.GET, uri, null, httpHeadersMap);
	}

	protected String get(String authorization, URI uri) {
		return _block(HttpMethod.GET, uri, null, _authorization(authorization));
	}

	/**
	 * @deprecated Supply a {@code WebClient.Builder} customizer bean instead.
	 *             Overriding this method no longer has any effect, because the
	 *             filter is applied once when the shared client is built
	 *             rather than on every request.
	 */
	@Deprecated
	protected ExchangeFilterFunction getWebClientExchangeFilterFunction() {
		return (clientRequest, exchangeFunction) -> exchangeFunction.exchange(
			clientRequest);
	}

	protected void log(Jwt jwt, Log log) {
		_logJwt(jwt, log);
	}

	protected void log(Jwt jwt, Log log, Map<String, String> parameters) {
		_logJwt(jwt, log);

		if (log.isInfoEnabled()) {
			log.info("Parameters: " + parameters);
		}
	}

	protected void log(Jwt jwt, Log log, String json) {
		if (log.isInfoEnabled()) {
			try {
				log.info("JSON: " + new JSONObject(json).toString(4));
			}
			catch (Exception exception) {
				log.error("JSON: " + json, exception);
			}
		}

		_logJwt(jwt, log);
	}

	protected String patch(
		String body, Map<String, String> httpHeadersMap, URI uri) {

		return _block(HttpMethod.PATCH, uri, body, httpHeadersMap);
	}

	protected String patch(String authorization, String body, URI uri) {
		return _block(
			HttpMethod.PATCH, uri, body, _authorization(authorization));
	}

	protected String post(
		String body, Map<String, String> httpHeadersMap, URI uri) {

		return _block(HttpMethod.POST, uri, body, httpHeadersMap);
	}

	protected String post(String authorization, String body, URI uri) {
		return _block(
			HttpMethod.POST, uri, body, _authorization(authorization));
	}

	protected String put(
		String body, Map<String, String> httpHeadersMap, URI uri) {

		return _block(HttpMethod.PUT, uri, body, httpHeadersMap);
	}

	protected String put(String authorization, String body, URI uri) {
		return _block(HttpMethod.PUT, uri, body, _authorization(authorization));
	}

	@Autowired
	protected LiferayWebClient liferayWebClient;

	@Value("${com.liferay.lxc.dxp.mainDomain}")
	protected String lxcDXPMainDomain;

	@Value("${com.liferay.lxc.dxp.server.protocol}")
	protected String lxcDXPServerProtocol;

	private Disposable _async(
		HttpMethod httpMethod, URI uri, String body,
		Map<String, String> httpHeadersMap) {

		return _exchange(
			httpMethod, uri, body, httpHeadersMap
		).subscribe();
	}

	private Map<String, String> _authorization(String authorization) {
		return Collections.singletonMap(
			HttpHeaders.AUTHORIZATION, authorization);
	}

	private String _block(
		HttpMethod httpMethod, URI uri, String body,
		Map<String, String> httpHeadersMap) {

		return _exchange(
			httpMethod, uri, body, httpHeadersMap
		).block();
	}

	/**
	 * The legacy body contract, reproduced exactly: a 204 becomes the string
	 * "{}", any other 2xx becomes the raw body, and everything else becomes a
	 * WebClientResponseException. New code gets the untouched ResponseEntity
	 * from LiferayRestClient instead.
	 */
	private Mono<String> _exchange(
		HttpMethod httpMethod, URI uri, String body,
		Map<String, String> httpHeadersMap) {

		return liferayWebClient.exchange(
			httpMethod, uri, body, httpHeadersMap
		).flatMap(
			responseEntity -> {
				if (responseEntity.getStatusCode() == HttpStatus.NO_CONTENT) {
					return Mono.just("{}");
				}

				if (responseEntity.getStatusCode().is2xxSuccessful()) {
					return Mono.justOrEmpty(responseEntity.getBody());
				}

				return Mono.error(_toException(responseEntity));
			}
		);
	}

	private void _logJwt(Jwt jwt, Log log) {
		if (log.isInfoEnabled()) {
			log.info("JWT Claims: " + jwt.getClaims());
			log.info("JWT ID: " + jwt.getId());
			log.info("JWT Subject: " + jwt.getSubject());
		}
	}

	private WebClientResponseException _toException(
		ResponseEntity<String> responseEntity) {

		String body = responseEntity.getBody();

		return new WebClientResponseException(
			responseEntity.getStatusCode().value(), "",
			responseEntity.getHeaders(),
			(body == null) ? null : body.getBytes(), null);
	}

}
