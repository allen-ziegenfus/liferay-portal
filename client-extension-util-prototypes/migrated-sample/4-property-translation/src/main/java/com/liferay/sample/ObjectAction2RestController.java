/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.sample;

import org.json.JSONObject;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestClient;

/**
 * Not one Liferay import. Stock Spring <code>RestClient</code>, stock
 * <code>@AuthenticationPrincipal Jwt</code> - which works because the
 * post processor derived
 * <code>spring.security.oauth2.resourceserver.jwt.jwk-set-uri</code> and Boot's
 * own auto-configuration built the resource server from it.
 *
 * <p>
 * Everything a customer needs in order to write this file is Spring Security
 * documentation. That is the strongest version of the ease-of-use argument, and
 * it is the inverse of the one the current library makes.
 * </p>
 *
 * <p>
 * The bill arrives in two places. {@link DXPUris} is fourteen lines the
 * consumer now owns, and <code>onStatus</code> below is the boilerplate that
 * <code>LiferayRestClient</code> encapsulates in Options 1 and 3. Neither is
 * hard. Both are per-project.
 * </p>
 */
@RequestMapping("/object/action/2")
@RestController
public class ObjectAction2RestController {

	public ObjectAction2RestController(
		DXPUris dxpUris, RestClient.Builder restClientBuilder) {

		_dxpUris = dxpUris;
		_restClient = restClientBuilder.build();
	}

	@PostMapping
	public ResponseEntity<String> post(
		@AuthenticationPrincipal Jwt jwt, @RequestBody String json) {

		JSONObject jsonObject = new JSONObject(json);

		JSONObject modelDTOAccountJSONObject = jsonObject.optJSONObject(
			"modelDTOAccount");

		if (modelDTOAccountJSONObject == null) {
			return new ResponseEntity<>(json, HttpStatus.OK);
		}

		return _restClient.patch(
		).uri(
			_dxpUris.resolve(
				"/o/headless-admin-user/v1.0/user-accounts/" +
					modelDTOAccountJSONObject.getLong("id"))
		).header(
			HttpHeaders.AUTHORIZATION, "Bearer " + jwt.getTokenValue()
		).body(
			new JSONObject(
			).put(
				"alternateName",
				modelDTOAccountJSONObject.getString("givenName")
			).toString()
		).retrieve(
		).onStatus(
			httpStatusCode -> true, (request, response) -> {
			}
		).toEntity(
			String.class
		);
	}

	private final DXPUris _dxpUris;
	private final RestClient _restClient;

}
