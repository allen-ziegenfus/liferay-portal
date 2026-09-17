/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.one.license;

import com.liferay.headless.admin.user.client.dto.v1_0.Account;
import com.liferay.one.constants.EntitlementConstants;
import com.liferay.one.model.Entitlement;
import com.liferay.one.model.EntitlementDefinition;
import com.liferay.one.model.LicenseKey;
import com.liferay.one.service.EntitlementDefinitionService;
import com.liferay.one.service.EntitlementService;
import com.liferay.one.service.LicenseKeyService;
import com.liferay.petra.string.StringPool;
import com.liferay.portal.ee.license.shared.LicenseConstants;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;

import java.time.Instant;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;

/**
 * @author Allen Ziegenfus
 */
@Component
public class LicenseKeyProvisioner {

	public LicenseKey provision(Account account, JSONObject jsonObject)
		throws Exception {

		String licenseType = jsonObject.optString("licenseType");
		String productVersion = jsonObject.optString("productVersion");

		LicenseEntry licenseEntry = _getLicenseEntry(
			licenseType, jsonObject.optString("productKey"), productVersion);

		List<Entitlement> entitlements = _getEntitlements(
			account.getId(),
			jsonObject.optString("productExternalReferenceCode"));

		int maxClusterNodes = jsonObject.optInt("maxClusterNodes");

		int serverCount = _getServerCount(maxClusterNodes);

		Map<Long, Integer> consumptionCounts = _getConsumptionCounts(
			account.getId());

		_checkAvailability(consumptionCounts, entitlements, serverCount);

		String owner = jsonObject.optString("owner");

		if (Validator.isNull(owner)) {
			owner = account.getName();
		}

		String description = jsonObject.optString("description");

		if (Validator.isNull(description)) {
			description = owner;
		}

		return _licenseKeyService.addLicenseKey(
			account.getId(), account.getName(), true, StringPool.BLANK, false,
			description, StringPool.BLANK,
			_getEntitlementId(consumptionCounts, entitlements, serverCount),
			_toDate(jsonObject, "expirationDate"),
			jsonObject.optString("hostName"),
			jsonObject.optString("ipAddresses"), licenseEntry.getName(),
			licenseType, _LICENSE_VERSION, jsonObject.optString("macAddresses"),
			maxClusterNodes, 0L, 0, 0, 0L, jsonObject.optString("name"),
			jsonObject.optString("orderId"), owner,
			jsonObject.optString("productExternalId"),
			jsonObject.optString("productName"), productVersion,
			StringPool.BLANK, jsonObject.optString("sizing"),
			_toDate(jsonObject, "startDate"));
	}

	private void _checkAvailability(
		Map<Long, Integer> consumptionCounts, List<Entitlement> entitlements,
		int serverCount) {

		int consumptionCount = 0;
		int totalQuantity = 0;

		for (Entitlement entitlement : entitlements) {
			consumptionCount += _getConsumptionCount(
				consumptionCounts, entitlement);

			totalQuantity += _getQuantity(entitlement);
		}

		if ((consumptionCount + serverCount) > totalQuantity) {
			throw new ResponseStatusException(
				HttpStatus.CONFLICT,
				"The subscriptions have no more available licenses");
		}
	}

	private int _getConsumptionCount(
		Map<Long, Integer> consumptionCounts, Entitlement entitlement) {

		Integer consumptionCount = consumptionCounts.get(
			entitlement.getEntitlementId());

		if (consumptionCount == null) {
			return 0;
		}

		return consumptionCount;
	}

	private Map<Long, Integer> _getConsumptionCounts(long accountEntryId)
		throws Exception {

		Map<Long, Integer> consumptionCounts = new HashMap<>();

		Instant instant = Instant.now();

		for (LicenseKey licenseKey :
				_licenseKeyService.getLicenseKeysByAccountEntryId(
					accountEntryId)) {

			long entitlementId = licenseKey.getEntitlementId();

			if ((entitlementId == 0) || !licenseKey.isActive()) {
				continue;
			}

			Instant customExpirationDateInstant =
				licenseKey.getCustomExpirationDateInstant();

			if ((customExpirationDateInstant != null) &&
				customExpirationDateInstant.isBefore(instant)) {

				continue;
			}

			consumptionCounts.merge(
				entitlementId, _getServerCount(licenseKey.getMaxClusterNodes()),
				Integer::sum);
		}

		return consumptionCounts;
	}

	private long _getEntitlementId(
		Map<Long, Integer> consumptionCounts, List<Entitlement> entitlements,
		int serverCount) {

		for (Entitlement entitlement : entitlements) {
			int remaining =
				_getQuantity(entitlement) -
					_getConsumptionCount(consumptionCounts, entitlement);

			if (remaining >= serverCount) {
				return entitlement.getEntitlementId();
			}
		}

		return 0;
	}

	private List<Entitlement> _getEntitlements(
			long accountEntryId, String productExternalReferenceCode)
		throws Exception {

		EntitlementDefinition entitlementDefinition =
			_entitlementDefinitionService.fetchEntitlementDefinition(
				productExternalReferenceCode);

		if (entitlementDefinition == null) {
			throw new ResponseStatusException(
				HttpStatus.BAD_REQUEST,
				"No entitlement definition exists with the external " +
					"reference code");
		}

		if (!StringUtil.equals(
				entitlementDefinition.getName(),
				EntitlementConstants.NAME_LICENSE_GENERATION)) {

			throw new ResponseStatusException(
				HttpStatus.BAD_REQUEST,
				"The entitlement definition does not grant license generation");
		}

		List<Entitlement> entitlements = new ArrayList<>();

		for (Entitlement entitlement :
				_entitlementService.getActiveEntitlements(accountEntryId)) {

			if (entitlement.getEntitlementDefinitionId() ==
					entitlementDefinition.getEntitlementDefinitionId()) {

				entitlements.add(entitlement);
			}
		}

		if (entitlements.isEmpty()) {
			throw new ResponseStatusException(
				HttpStatus.CONFLICT,
				"The account holds no entitlement for the product");
		}

		return entitlements;
	}

	private LicenseEntry _getLicenseEntry(
		String licenseType, String productKey, String productVersion) {

		for (LicenseEntry licenseEntry :
				_licenseEntryService.getLicenseEntriesByProductKeyVersion(
					productKey, productVersion)) {

			String type = licenseEntry.getType();

			if (StringUtil.equals(type, LicenseConstants.TYPE_FREE)) {
				continue;
			}

			if (StringUtil.equals(type, licenseType)) {
				return licenseEntry;
			}
		}

		throw new ResponseStatusException(
			HttpStatus.BAD_REQUEST, "Invalid license entry type");
	}

	private int _getQuantity(Entitlement entitlement) {
		Double quantity = entitlement.getQuantity();

		if (quantity == null) {
			return 0;
		}

		return quantity.intValue();
	}

	private int _getServerCount(int maxClusterNodes) {
		if (maxClusterNodes > 1) {
			return maxClusterNodes;
		}

		return 1;
	}

	private Date _toDate(JSONObject jsonObject, String key) {
		return Date.from(Instant.parse(jsonObject.getString(key)));
	}

	private static final int _LICENSE_VERSION = 3;

	@Autowired
	private EntitlementDefinitionService _entitlementDefinitionService;

	@Autowired
	private EntitlementService _entitlementService;

	@Autowired
	private LicenseEntryService _licenseEntryService;

	@Autowired
	private LicenseKeyService _licenseKeyService;

}