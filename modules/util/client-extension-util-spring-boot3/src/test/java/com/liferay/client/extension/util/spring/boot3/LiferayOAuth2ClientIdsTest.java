/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.util.spring.boot3;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.junit.Assert;
import org.junit.Test;

/**
 * @author Allen Ziegenfus
 */
public class LiferayOAuth2ClientIdsTest {

	@Test
	public void testHasClientId() {
		String clientId = String.valueOf(UUID.randomUUID());
		String externalReferenceCode = String.valueOf(UUID.randomUUID());

		Map<String, String> clientIds = Map.of(externalReferenceCode, clientId);

		LiferayOAuth2ClientIds liferayOAuth2ClientIds =
			new LiferayOAuth2ClientIds(
				clientIds::get,
				List.of(
					String.valueOf(UUID.randomUUID()), externalReferenceCode));

		Assert.assertTrue(liferayOAuth2ClientIds.hasClientId(clientId));

		Assert.assertFalse(
			liferayOAuth2ClientIds.hasClientId(
				String.valueOf(UUID.randomUUID())));

		Assert.assertFalse(liferayOAuth2ClientIds.hasClientId(null));
	}

	@Test
	public void testHasClientIdCachesClientId() {
		String clientId = String.valueOf(UUID.randomUUID());
		String externalReferenceCode = String.valueOf(UUID.randomUUID());

		List<String> requestedExternalReferenceCodes = new ArrayList<>();

		LiferayOAuth2ClientIds liferayOAuth2ClientIds =
			new LiferayOAuth2ClientIds(
				requestedExternalReferenceCode -> {
					requestedExternalReferenceCodes.add(
						requestedExternalReferenceCode);

					return clientId;
				},
				List.of(externalReferenceCode));

		Assert.assertTrue(liferayOAuth2ClientIds.hasClientId(clientId));
		Assert.assertTrue(liferayOAuth2ClientIds.hasClientId(clientId));

		Assert.assertEquals(
			List.of(externalReferenceCode), requestedExternalReferenceCodes);
	}

	@Test
	public void testHasClientIdDoesNotCacheNull() {
		String clientId = String.valueOf(UUID.randomUUID());
		String externalReferenceCode = String.valueOf(UUID.randomUUID());

		List<String> requestedExternalReferenceCodes = new ArrayList<>();

		LiferayOAuth2ClientIds liferayOAuth2ClientIds =
			new LiferayOAuth2ClientIds(
				requestedExternalReferenceCode -> {
					requestedExternalReferenceCodes.add(
						requestedExternalReferenceCode);

					if (requestedExternalReferenceCodes.size() == 1) {
						return null;
					}

					return clientId;
				},
				List.of(externalReferenceCode));

		Assert.assertFalse(liferayOAuth2ClientIds.hasClientId(clientId));
		Assert.assertTrue(liferayOAuth2ClientIds.hasClientId(clientId));

		Assert.assertEquals(
			List.of(externalReferenceCode, externalReferenceCode),
			requestedExternalReferenceCodes);
	}

	@Test
	public void testHasExternalReferenceCode() {
		String externalReferenceCode = String.valueOf(UUID.randomUUID());

		LiferayOAuth2ClientIds liferayOAuth2ClientIds =
			new LiferayOAuth2ClientIds(
				requestedExternalReferenceCode -> null,
				List.of(externalReferenceCode));

		Assert.assertTrue(
			liferayOAuth2ClientIds.hasExternalReferenceCode(
				externalReferenceCode));

		Assert.assertFalse(
			liferayOAuth2ClientIds.hasExternalReferenceCode(
				String.valueOf(UUID.randomUUID())));

		Assert.assertFalse(
			liferayOAuth2ClientIds.hasExternalReferenceCode(null));
	}

}