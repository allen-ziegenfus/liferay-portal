/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.sample;

import com.liferay.client.extension.spring.boot.web.LiferayRestClient;

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
 * Three changes from the shipping version.
 *
 * <ol>
 * <li><code>extends BaseRestController</code> is gone. The class extends
 * nothing, so <code>@RestController</code> is written here rather than
 * inherited from a superclass, and the twenty-four outbound HTTP methods are no
 * longer in scope.</li>
 * <li><code>patch</code> is a call on an injected collaborator instead of an
 * inherited <code>protected</code> method.</li>
 * <li><strong>The upstream status code is no longer thrown away.</strong> The
 * shipping version wraps the response body in a hardcoded
 * <code>HttpStatus.OK</code>, so a 403 or 422 from
 * <code>headless-admin-user</code> is reported to Liferay's object-action
 * framework as a success. It cannot do better: <code>patch</code> returns a
 * bare <code>String</code>, and a non-2xx arrives as a
 * <code>WebClientResponseException</code> that nothing here catches.</li>
 * </ol>
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
