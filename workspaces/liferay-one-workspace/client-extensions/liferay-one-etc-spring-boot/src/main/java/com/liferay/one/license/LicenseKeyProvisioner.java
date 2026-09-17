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
import com.liferay.one.util.KeyedLock;
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

	public void checkEntitlementAvailable(
			long accountEntryId, long entitlementId, int serverCount)
		throws Exception {

		// A key that predates entitlement tracking has nothing to charge, so
		// there is no capacity question to answer for it.

		if (entitlementId == 0) {
			return;
		}

		_keyedLock.withLock(
			String.valueOf(accountEntryId),
			() -> {
				Entitlement entitlement = null;

				for (Entitlement curEntitlement :
						_entitlementService.getActiveEntitlements(
							accountEntryId)) {

					if (curEntitlement.getEntitlementId() == entitlementId) {
						entitlement = curEntitlement;

						break;
					}
				}

				if (entitlement == null) {
					throw new ResponseStatusException(
						HttpStatus.BAD_REQUEST,
						"The account holds no active entitlement with the " +
							"requested ID");
				}

				Map<Long, Integer> consumptionCounts = _getConsumptionCounts(
					accountEntryId);

				int remaining =
					_getQuantity(entitlement) -
						_getConsumptionCount(consumptionCounts, entitlement);

				if (remaining < serverCount) {
					throw new ResponseStatusException(
						HttpStatus.CONFLICT,
						"The subscriptions have no more available licenses");
				}
			});
	}

	public List<LicenseKey> provision(
			Account account, List<JSONObject> jsonObjects)
		throws Exception {

		// Reading the consumption, checking it and creating the keys have to
		// happen together, or two requests for the same account both see the
		// same free licenses and both take them. The account's entitlements
		// and consumption are read once and the ledger is carried across the
		// requested keys, so a body asking for more than the account holds is
		// refused on the key that exhausts it rather than being approved
		// against a snapshot taken before any of them were created.

		return _keyedLock.withLock(
			String.valueOf(account.getId()),
			() -> {
				Map<Long, Integer> consumptionCounts = _getConsumptionCounts(
					account.getId());

				List<LicenseKey> licenseKeys = new ArrayList<>();

				for (JSONObject jsonObject : jsonObjects) {
					licenseKeys.add(
						_provision(account, consumptionCounts, jsonObject));
				}

				return licenseKeys;
			});
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

		// Capacity spread across several entitlements cannot back one key, so
		// asking whether the total is large enough would approve a request no
		// single entitlement can carry, and the key would be written against
		// no entitlement at all and never counted again.

		throw new ResponseStatusException(
			HttpStatus.CONFLICT,
			"The subscriptions have no more available licenses");
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

	private LicenseKey _provision(
			Account account, Map<Long, Integer> consumptionCounts,
			JSONObject jsonObject)
		throws Exception {

		String licenseType = jsonObject.optString("licenseType");
		String productVersion = jsonObject.optString("productVersion");

		LicenseEntry licenseEntry = _getLicenseEntry(
			licenseType, jsonObject.optString("productKey"), productVersion);

		List<Entitlement> entitlements = _getEntitlements(
			account.getId(),
			jsonObject.optString("productExternalReferenceCode"));

		int maxClusterNodes = jsonObject.optInt("maxClusterNodes");

		if ((maxClusterNodes < 0) || (maxClusterNodes > _MAX_CLUSTER_NODES)) {
			throw new ResponseStatusException(
				HttpStatus.BAD_REQUEST,
				"The maximum cluster nodes must be between 0 and " +
					_MAX_CLUSTER_NODES);
		}

		int serverCount = _getServerCount(maxClusterNodes);

		long entitlementId = _getEntitlementId(
			consumptionCounts, entitlements, serverCount);

		String owner = jsonObject.optString("owner");

		if (Validator.isNull(owner)) {
			owner = account.getName();
		}

		String description = jsonObject.optString("description");

		if (Validator.isNull(description)) {
			description = owner;
		}

		consumptionCounts.merge(entitlementId, serverCount, Integer::sum);

		return _licenseKeyService.addLicenseKey(
			account.getId(), account.getName(), true, StringPool.BLANK, false,
			description, StringPool.BLANK, entitlementId,
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

	private Date _toDate(JSONObject jsonObject, String key) {
		return Date.from(Instant.parse(jsonObject.getString(key)));
	}

	private static final int _LICENSE_VERSION = 3;

	private static final int _MAX_CLUSTER_NODES = 1000;

	@Autowired
	private EntitlementDefinitionService _entitlementDefinitionService;

	@Autowired
	private EntitlementService _entitlementService;

	@Autowired
	private KeyedLock _keyedLock;

	@Autowired
	private LicenseEntryService _licenseEntryService;

	@Autowired
	private LicenseKeyService _licenseKeyService;

}