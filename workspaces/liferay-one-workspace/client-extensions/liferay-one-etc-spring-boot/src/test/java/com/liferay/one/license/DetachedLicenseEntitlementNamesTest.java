/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.one.license;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

/**
 * @author Allen Ziegenfus
 */
public class DetachedLicenseEntitlementNamesTest {

	@Test
	public void testGetEntitlementNameWithLegacySizingEncoding() {
		Assertions.assertEquals(
			"Liferay Self-Hosted Prod Sizing 2",
			DetachedLicenseEntitlementNames.getEntitlementName(
				"KOR-36354", "sizing-2"));
	}

	@Test
	public void testGetEntitlementNameWithNullSizing() {
		Assertions.assertEquals(
			"Liferay Self-Hosted Prod",
			DetachedLicenseEntitlementNames.getEntitlementName(
				"KOR-36354", null));
	}

	@Test
	public void testGetEntitlementNameWithSizing() {
		Assertions.assertEquals(
			"Liferay Self-Hosted Prod Sizing 2",
			DetachedLicenseEntitlementNames.getEntitlementName(
				"KOR-36354", "Sizing 2"));
	}

	@Test
	public void testGetEntitlementNameWithUnknownProductKey() {
		Assertions.assertNull(
			DetachedLicenseEntitlementNames.getEntitlementName(
				"KOR-00000", null));
	}

}