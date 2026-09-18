/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.one.license;

import com.liferay.one.constants.EntitlementConstants;
import com.liferay.one.exception.LicenseKeyDateException;
import com.liferay.one.model.Entitlement;
import com.liferay.one.model.EntitlementDefinition;
import com.liferay.one.model.LicenseKey;
import com.liferay.one.service.LicenseKeyService;
import com.liferay.petra.string.StringBundler;
import com.liferay.portal.kernel.security.auth.PrincipalException;
import com.liferay.portal.kernel.util.ArrayUtil;

import java.time.Instant;
import java.time.temporal.ChronoUnit;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @author Allen Ziegenfus
 */
@Component
public class LicenseKeyEntitlementValidator {

	public void validateEntitlementDefinition(Entitlement entitlement)
		throws Exception {

		EntitlementDefinition entitlementDefinition =
			entitlement.getEntitlementDefinition();

		if ((entitlementDefinition == null) ||
			!ArrayUtil.contains(
				EntitlementConstants.EXTERNAL_REFERENCE_CODES_SELF_HOSTED,
				entitlementDefinition.getExternalReferenceCode())) {

			throw new PrincipalException(
				StringBundler.concat(
					"Entitlement ", entitlement.getEntitlementId(),
					" does not grant self-hosted license keys"));
		}
	}

	public void validateQuota(
			Entitlement entitlement, int maxClusterNodes,
			Map<Long, Integer> pendingServerCounts)
		throws Exception {

		if (EntitlementConstants.GRANT_TYPE_UNLIMITED.equals(
				entitlement.getGrantType())) {

			return;
		}

		long entitlementId = entitlement.getEntitlementId();

		int pendingServerCount = getServerCount(maxClusterNodes);

		Integer previousPendingServerCount = pendingServerCounts.get(
			entitlementId);

		if (previousPendingServerCount != null) {
			pendingServerCount += previousPendingServerCount;
		}

		int serverCount = pendingServerCount;

		for (LicenseKey licenseKey :
				_licenseKeyService.getLicenseKeys(true, false, entitlementId)) {

			serverCount += getServerCount(licenseKey.getMaxClusterNodes());
		}

		Double quantity = entitlement.getQuantity();

		int maxServerCount = 0;

		if (quantity != null) {
			maxServerCount = quantity.intValue();
		}

		if (serverCount > maxServerCount) {
			throw new PrincipalException(
				"Entitlement " + entitlementId +
					" has no more available licenses");
		}

		pendingServerCounts.put(entitlementId, pendingServerCount);
	}

	public void validateTerm(
			boolean allowPermanentLicenses, Entitlement entitlement,
			Instant expirationDateInstant, Instant startDateInstant)
		throws Exception {

		Instant endDateInstant = entitlement.getEndDateInstant();

		if (endDateInstant == null) {
			if (!allowPermanentLicenses) {
				throw new PrincipalException(
					StringBundler.concat(
						"Entitlement ", entitlement.getEntitlementId(),
						" is perpetual and the account does not allow ",
						"permanent licenses"));
			}
		}
		else if (expirationDateInstant.isAfter(
					endDateInstant.plus(
						_ENTITLEMENT_END_DATE_TOLERANCE_DAYS,
						ChronoUnit.DAYS))) {

			throw new LicenseKeyDateException(
				"The expiration date is after the end of entitlement " +
					entitlement.getEntitlementId());
		}

		Instant entitlementStartDateInstant = entitlement.getStartDateInstant();

		if ((entitlementStartDateInstant != null) &&
			entitlementStartDateInstant.isAfter(startDateInstant)) {

			throw new LicenseKeyDateException(
				"The start date is before the start of entitlement " +
					entitlement.getEntitlementId());
		}
	}

	protected int getServerCount(int maxClusterNodes) {
		if (maxClusterNodes > 1) {
			return maxClusterNodes;
		}

		return 1;
	}

	private static final int _ENTITLEMENT_END_DATE_TOLERANCE_DAYS = 1;

	@Autowired
	private LicenseKeyService _licenseKeyService;

}