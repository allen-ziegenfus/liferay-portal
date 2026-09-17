/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.one.license;

import com.liferay.one.model.LicenseKey;

import java.util.Date;

/**
 * @author Allen Ziegenfus
 */
public class LicenseKeyExtension {

	public LicenseKeyExtension(
		long entitlementId, Date expirationDate, LicenseKey licenseKey,
		Date startDate) {

		_entitlementId = entitlementId;
		_expirationDate = expirationDate;
		_licenseKey = licenseKey;
		_startDate = startDate;
	}

	public long getEntitlementId() {
		return _entitlementId;
	}

	public Date getExpirationDate() {
		return _expirationDate;
	}

	public LicenseKey getLicenseKey() {
		return _licenseKey;
	}

	public Date getStartDate() {
		return _startDate;
	}

	private final long _entitlementId;
	private final Date _expirationDate;
	private final LicenseKey _licenseKey;
	private final Date _startDate;

}