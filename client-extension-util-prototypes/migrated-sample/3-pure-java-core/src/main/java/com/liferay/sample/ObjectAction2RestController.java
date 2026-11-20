/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.sample;

import com.liferay.client.extension.spring.boot.LiferayRestClient;

import java.util.Map;

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
import org.springframework.web.util.UriComponentsBuilder;

/**
 * Character for character the same as the Option 1 controller, except for one
 * import: <code>...spring.boot.LiferayRestClient</code> rather than
 * <code>...spring.boot.web.LiferayRestClient</code>.
 *
 * <p>
 * This is the honest finding of the exercise. For a controller like this one,
 * choosing Option 3 over Option 1 buys the consumer nothing at all. The payoff
 * is entirely on our side of the line, and it shows up in exactly two places:
 * on the day Spring Boot 5 ships, and in what a unit test costs.
 * </p>
 *
 * <p>
 * See {@link SampleCronRunner} in this directory for the case where the split
 * <em>is</em> visible to a consumer.
 * </p>
 */
@RequestMapping("/object/action/2")
@RestController
public class ObjectAction2RestController {

	public ObjectAction2RestController(LiferayRestClient liferayRestClient) {
		_liferayRestClient = liferayRestClient;
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

		return _liferayRestClient.patch(
			UriComponentsBuilder.fromPath(
				"/o/headless-admin-user/v1.0/user-accounts/" +
					modelDTOAccountJSONObject.getLong("id")
			).build(
			).toUri(),
			new JSONObject(
			).put(
				"alternateName",
				modelDTOAccountJSONObject.getString("givenName")
			).toString(),
			Map.of(
				HttpHeaders.AUTHORIZATION, "Bearer " + jwt.getTokenValue()));
	}

	private final LiferayRestClient _liferayRestClient;

}
