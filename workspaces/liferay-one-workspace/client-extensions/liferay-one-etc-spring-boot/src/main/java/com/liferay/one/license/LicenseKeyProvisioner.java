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

	public void activate(long accountEntryId, long[] licenseKeyIds)
		throws Exception {

		_keyedLock.withLock(
			String.valueOf(accountEntryId),
			() -> {

				// The account's keys are read inside the lock, so whether a
				// key is already active is decided on the same rows the ledger
				// is built from rather than on a snapshot taken before it.

				List<LicenseKey> licenseKeys =
					_licenseKeyService.getLicenseKeysByAccountEntryId(
						accountEntryId);

				Map<Long, Integer> consumptionCounts = _getConsumptionCounts(
					licenseKeys);

				List<Entitlement> entitlements =
					_entitlementService.getActiveEntitlements(accountEntryId);

				List<LicenseKey> inactiveLicenseKeys = new ArrayList<>();

				for (long licenseKeyId : licenseKeyIds) {
					LicenseKey licenseKey = _getLicenseKey(
						licenseKeys, licenseKeyId);

					if (licenseKey.isActive()) {
						continue;
					}

					int serverCount = _getServerCount(
						licenseKey.getMaxClusterNodes());

					_checkEntitlement(
						consumptionCounts, entitlements,
						licenseKey.getEntitlementId(),
						licenseKey.getEntitlementId(), serverCount);

					consumptionCounts.merge(
						licenseKey.getEntitlementId(), serverCount,
						Integer::sum);

					inactiveLicenseKeys.add(licenseKey);
				}

				for (LicenseKey licenseKey : inactiveLicenseKeys) {
					_licenseKeyService.updateLicenseKeyActive(
						true, licenseKey.getLicenseKeyId());
				}
			});
	}

	public void deactivate(long accountEntryId, long[] licenseKeyIds)
		throws Exception {

		// Releasing licenses cannot exhaust anything, but it moves the ledger,
		// so it is serialized with the operations that read it.

		_keyedLock.withLock(
			String.valueOf(accountEntryId),
			() -> {
				for (long licenseKeyId : licenseKeyIds) {
					_licenseKeyService.updateLicenseKeyActive(
						false, licenseKeyId);
				}
			});
	}

	public List<LicenseKey> extend(
			long accountEntryId, List<LicenseKeyExtension> licenseKeyExtensions)
		throws Exception {

		return _keyedLock.withLock(
			String.valueOf(accountEntryId),
			() -> {
				Map<Long, Integer> consumptionCounts = _getConsumptionCounts(
					_licenseKeyService.getLicenseKeysByAccountEntryId(
						accountEntryId));

				List<Entitlement> entitlements =
					_entitlementService.getActiveEntitlements(accountEntryId);

				for (LicenseKeyExtension licenseKeyExtension :
						licenseKeyExtensions) {

					LicenseKey licenseKey = licenseKeyExtension.getLicenseKey();

					int serverCount = _getServerCount(
						licenseKey.getMaxClusterNodes());

					_checkEntitlement(
						consumptionCounts, entitlements,
						licenseKeyExtension.getEntitlementId(),
						licenseKey.getEntitlementId(), serverCount);

					consumptionCounts.merge(
						licenseKeyExtension.getEntitlementId(), serverCount,
						Integer::sum);
				}

				List<LicenseKey> newLicenseKeys = new ArrayList<>();

				for (LicenseKeyExtension licenseKeyExtension :
						licenseKeyExtensions) {

					LicenseKey licenseKey = licenseKeyExtension.getLicenseKey();

					newLicenseKeys.add(
						_licenseKeyService.extendLicenseKey(
							licenseKeyExtension.getEntitlementId(),
							licenseKeyExtension.getExpirationDate(),
							licenseKey.getLicenseKeyId(),
							licenseKeyExtension.getStartDate()));
				}

				return newLicenseKeys;
			});
	}

	public List<LicenseKey> provision(
			Account account, List<JSONObject> jsonObjects)
		throws Exception {

		return _keyedLock.withLock(
			String.valueOf(account.getId()),
			() -> {
				Map<Long, Integer> consumptionCounts = _getConsumptionCounts(
					_licenseKeyService.getLicenseKeysByAccountEntryId(
						account.getId()));

				Map<String, List<Entitlement>> entitlementsMap =
					new HashMap<>();

				List<Long> entitlementIds = new ArrayList<>();

				for (JSONObject jsonObject : jsonObjects) {
					entitlementIds.add(
						_prepare(
							account, consumptionCounts, entitlementsMap,
							jsonObject));
				}

				List<LicenseKey> licenseKeys = new ArrayList<>();

				for (int i = 0; i < jsonObjects.size(); i++) {
					licenseKeys.add(
						_addLicenseKey(
							account, entitlementIds.get(i),
							jsonObjects.get(i)));
				}

				return licenseKeys;
			});
	}

	private LicenseKey _addLicenseKey(
			Account account, long entitlementId, JSONObject jsonObject)
		throws Exception {

		String licenseType = jsonObject.optString("licenseType");
		String productVersion = jsonObject.optString("productVersion");

		LicenseEntry licenseEntry = _getLicenseEntry(
			licenseType, jsonObject.optString("productKey"), productVersion);

		return _licenseKeyService.addLicenseKey(
			account.getId(), account.getName(), true, StringPool.BLANK, false,
			_getDescription(account, jsonObject), StringPool.BLANK,
			entitlementId, _toDate(jsonObject, "expirationDate"),
			jsonObject.optString("hostName"),
			jsonObject.optString("ipAddresses"), licenseEntry.getName(),
			licenseType, _LICENSE_VERSION, jsonObject.optString("macAddresses"),
			jsonObject.optInt("maxClusterNodes"), 0L, 0, 0, 0L,
			jsonObject.optString("name"), jsonObject.optString("orderId"),
			_getOwner(account, jsonObject),
			jsonObject.optString("productExternalId"),
			jsonObject.optString("productName"), productVersion,
			StringPool.BLANK, jsonObject.optString("sizing"),
			_toDate(jsonObject, "startDate"));
	}

	private void _checkEntitlement(
		Map<Long, Integer> consumptionCounts, List<Entitlement> entitlements,
		long entitlementId, long storedEntitlementId, int serverCount) {

		Entitlement storedEntitlement = _fetchEntitlement(
			entitlements, storedEntitlementId);

		// A key written before entitlements were tracked carries no
		// entitlement, and may keep it. Naming zero for a key that does have
		// one would take it off the ledger for good.

		if (entitlementId == 0) {
			if (storedEntitlementId == 0) {
				return;
			}

			throw new ResponseStatusException(
				HttpStatus.BAD_REQUEST,
				"An entitlement is required for this license key");
		}

		for (Entitlement entitlement : entitlements) {
			if (entitlement.getEntitlementId() != entitlementId) {
				continue;
			}

			EntitlementDefinition entitlementDefinition =
				entitlement.getEntitlementDefinition();

			if ((entitlementDefinition == null) ||
				!StringUtil.equals(
					entitlementDefinition.getName(),
					EntitlementConstants.NAME_LICENSE_GENERATION)) {

				throw new ResponseStatusException(
					HttpStatus.BAD_REQUEST,
					"The entitlement does not grant license generation");
			}

			// Granting license generation is a property of the grant, not of
			// the product: the self hosted definitions all carry it. Charging
			// the key to the product it already holds keeps a key for one
			// product off another product's capacity.

			if ((storedEntitlement != null) &&
				(storedEntitlement.getEntitlementDefinitionId() !=
					entitlement.getEntitlementDefinitionId())) {

				throw new ResponseStatusException(
					HttpStatus.BAD_REQUEST,
					"The entitlement is for a different product");
			}

			int remaining =
				_getQuantity(entitlement) -
					_getConsumptionCount(consumptionCounts, entitlement);

			if (remaining < serverCount) {
				throw new ResponseStatusException(
					HttpStatus.CONFLICT,
					"The subscriptions have no more available licenses");
			}

			return;
		}

		throw new ResponseStatusException(
			HttpStatus.BAD_REQUEST,
			"The account holds no active entitlement with the requested ID");
	}

	private Entitlement _fetchEntitlement(
		List<Entitlement> entitlements, long entitlementId) {

		for (Entitlement entitlement : entitlements) {
			if (entitlement.getEntitlementId() == entitlementId) {
				return entitlement;
			}
		}

		return null;
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

	private Map<Long, Integer> _getConsumptionCounts(
		List<LicenseKey> accountLicenseKeys) {

		Map<Long, Integer> consumptionCounts = new HashMap<>();

		Instant instant = Instant.now();

		for (LicenseKey licenseKey : accountLicenseKeys) {
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

	private String _getDescription(Account account, JSONObject jsonObject) {
		String description = jsonObject.optString("description");

		if (Validator.isNull(description)) {
			return _getOwner(account, jsonObject);
		}

		return description;
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

	private LicenseKey _getLicenseKey(
		List<LicenseKey> licenseKeys, long licenseKeyId) {

		for (LicenseKey licenseKey : licenseKeys) {
			if (licenseKey.getLicenseKeyId() == licenseKeyId) {
				return licenseKey;
			}
		}

		throw new ResponseStatusException(
			HttpStatus.NOT_FOUND, "The license key was not found");
	}

	private String _getOwner(Account account, JSONObject jsonObject) {
		String owner = jsonObject.optString("owner");

		if (Validator.isNull(owner)) {
			return account.getName();
		}

		return owner;
	}

	private int _getQuantity(Entitlement entitlement) {
		if (StringUtil.equals(
				entitlement.getGrantType(),
				EntitlementConstants.GRANT_TYPE_UNLIMITED)) {

			return Integer.MAX_VALUE;
		}

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

	private long _prepare(
			Account account, Map<Long, Integer> consumptionCounts,
			Map<String, List<Entitlement>> entitlementsMap,
			JSONObject jsonObject)
		throws Exception {

		String licenseType = jsonObject.optString("licenseType");
		String productVersion = jsonObject.optString("productVersion");

		_getLicenseEntry(
			licenseType, jsonObject.optString("productKey"), productVersion);

		int maxClusterNodes = jsonObject.optInt("maxClusterNodes");

		if ((maxClusterNodes < 0) || (maxClusterNodes > _MAX_CLUSTER_NODES)) {
			throw new ResponseStatusException(
				HttpStatus.BAD_REQUEST,
				"The maximum cluster nodes must be between 0 and " +
					_MAX_CLUSTER_NODES);
		}

		_licenseKeyValidator.validateMetadata(
			_getDescription(account, jsonObject), licenseType, maxClusterNodes,
			jsonObject.optString("name"), _getOwner(account, jsonObject),
			productVersion);

		_licenseKeyValidator.validateDates(
			_toDate(jsonObject, "expirationDate"),
			jsonObject.optString("hostName"),
			jsonObject.optString("ipAddresses"), licenseType,
			jsonObject.optString("macAddresses"),
			_toDate(jsonObject, "startDate"));

		String productExternalReferenceCode = jsonObject.optString(
			"productExternalReferenceCode");

		List<Entitlement> entitlements = entitlementsMap.get(
			productExternalReferenceCode);

		if (entitlements == null) {
			entitlements = _getEntitlements(
				account.getId(), productExternalReferenceCode);

			entitlementsMap.put(productExternalReferenceCode, entitlements);
		}

		int serverCount = _getServerCount(maxClusterNodes);

		long entitlementId = _getEntitlementId(
			consumptionCounts, entitlements, serverCount);

		consumptionCounts.merge(entitlementId, serverCount, Integer::sum);

		return entitlementId;
	}

	private Date _toDate(JSONObject jsonObject, String key) {
		try {
			return Date.from(Instant.parse(jsonObject.getString(key)));
		}
		catch (Exception exception) {
			throw new ResponseStatusException(
				HttpStatus.BAD_REQUEST,
				"Request body has no valid \"" + key + "\"", exception);
		}
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

	@Autowired
	private LicenseKeyValidator _licenseKeyValidator;

}