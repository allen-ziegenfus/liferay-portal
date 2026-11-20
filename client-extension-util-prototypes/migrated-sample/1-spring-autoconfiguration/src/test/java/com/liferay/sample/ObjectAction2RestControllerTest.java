/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.sample;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.liferay.client.extension.spring.boot.web.LiferayRestClient;

import java.net.URI;

import java.util.Map;

import org.junit.jupiter.api.Test;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.jwt.Jwt;

/**
 * This file could not exist against the shipping version.
 *
 * <p>
 * <code>ObjectAction2RestController extends BaseRestController</code>, and the
 * <code>patch</code> it calls is a <code>protected</code> method on a superclass
 * that builds its own <code>WebClient</code> from <code>@Value</code>-injected
 * fields. There is no seam. Testing the "no modelDTOAccount, do not call
 * Liferay" branch would have meant standing up a Spring context and a mock
 * server for a two-line conditional.
 * </p>
 */
public class ObjectAction2RestControllerTest {

	@Test
	public void testPostPropagatesUpstreamFailure() {
		LiferayRestClient liferayRestClient = mock(LiferayRestClient.class);

		when(
			liferayRestClient.patch(any(URI.class), any(), any(Map.class))
		).thenReturn(
			ResponseEntity.status(
				HttpStatus.UNPROCESSABLE_ENTITY
			).body(
				"{\"title\":\"givenName is required\"}"
			)
		);

		ResponseEntity<String> responseEntity = _post(
			liferayRestClient,
			"{\"modelDTOAccount\":{\"id\":1234,\"givenName\":\"Ada\"}}");

		// The shipping version returns 200 here, telling the object action
		// framework the update succeeded when it did not.

		assertEquals(
			HttpStatus.UNPROCESSABLE_ENTITY, responseEntity.getStatusCode());
	}

	@Test
	public void testPostSkipsLiferayWhenAccountIsAbsent() {
		LiferayRestClient liferayRestClient = mock(LiferayRestClient.class);

		ResponseEntity<String> responseEntity = _post(
			liferayRestClient, "{\"somethingElse\":true}");

		assertEquals(HttpStatus.OK, responseEntity.getStatusCode());

		verify(
			liferayRestClient, never()
		).patch(
			any(URI.class), any(), any(Map.class)
		);
	}

	private ResponseEntity<String> _post(
		LiferayRestClient liferayRestClient, String json) {

		ObjectAction2RestController objectAction2RestController =
			new ObjectAction2RestController(liferayRestClient);

		return objectAction2RestController.post(_jwt(), json);
	}

	private Jwt _jwt() {
		return Jwt.withTokenValue(
			"test-token"
		).header(
			"alg", "none"
		).claim(
			"client_id", "test-client"
		).build();
	}

}
