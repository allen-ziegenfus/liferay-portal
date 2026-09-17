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

import java.time.Instant;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import org.json.JSONObject;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import org.mockito.Mockito;

import org.springframework.http.HttpStatus;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.web.server.ResponseStatusException;

/**
 * @author Allen Ziegenfus
 */
public class LicenseKeyProvisionerTest {

	@BeforeEach
	public void setUp() throws Exception {
		_licenseKeyProvisioner = new LicenseKeyProvisioner();

		_entitlementDefinitionService = Mockito.mock(
			EntitlementDefinitionService.class);
		_entitlementService = Mockito.mock(EntitlementService.class);
		_licenseEntryService = Mockito.mock(LicenseEntryService.class);
		_licenseKeyService = Mockito.mock(LicenseKeyService.class);

		ReflectionTestUtils.setField(
			_licenseKeyProvisioner, "_entitlementDefinitionService",
			_entitlementDefinitionService);
		ReflectionTestUtils.setField(
			_licenseKeyProvisioner, "_entitlementService", _entitlementService);
		ReflectionTestUtils.setField(
			_licenseKeyProvisioner, "_licenseEntryService",
			_licenseEntryService);
		ReflectionTestUtils.setField(
			_licenseKeyProvisioner, "_keyedLock", new KeyedLock());

		ReflectionTestUtils.setField(
			_licenseKeyProvisioner, "_licenseKeyService", _licenseKeyService);

		_licenseKeyValidator = Mockito.mock(LicenseKeyValidator.class);

		ReflectionTestUtils.setField(
			_licenseKeyProvisioner, "_licenseKeyValidator",
			_licenseKeyValidator);

		_setUpLicenseEntry();
	}

	@Test
	public void testActivateSpendsTheLicensesTheBatchAlreadyTook()
		throws Exception {

		_setUpEntitlements(1.0);

		_setUpConsumption(0);

		ResponseStatusException responseStatusException =
			Assertions.assertThrows(
				ResponseStatusException.class,
				() -> _licenseKeyProvisioner.activate(
					_ACCOUNT_ENTRY_ID,
					List.of(
						_toLicenseKey(false, 0, null),
						_toLicenseKey(false, 0, null))));

		Assertions.assertEquals(
			HttpStatus.CONFLICT, responseStatusException.getStatusCode());

		Mockito.verify(
			_licenseKeyService, Mockito.never()
		).updateLicenseKeyActive(
			Mockito.anyBoolean(), Mockito.anyLong()
		);
	}

	@Test
	public void testExtendChargesTheRequestedEntitlement() throws Exception {
		_setUpEntitlements(5.0);

		_setUpConsumption(0);

		LicenseKey licenseKey = _toLicenseKey(true, 0, null);

		_licenseKeyProvisioner.extend(
			_ACCOUNT_ENTRY_ID, Collections.singletonList(licenseKey),
			Collections.singletonList(_toExtendJSONObject(_ENTITLEMENT_ID)));

		Mockito.verify(
			_licenseKeyService
		).extendLicenseKey(
			Mockito.eq(_ENTITLEMENT_ID), Mockito.any(), Mockito.anyLong(),
			Mockito.any()
		);
	}

	@Test
	public void testExtendRejectsAnEntitlementTheAccountDoesNotHold()
		throws Exception {

		_setUpEntitlements(5.0);

		_setUpConsumption(0);

		ResponseStatusException responseStatusException =
			Assertions.assertThrows(
				ResponseStatusException.class,
				() -> _licenseKeyProvisioner.extend(
					_ACCOUNT_ENTRY_ID,
					Collections.singletonList(_toLicenseKey(true, 0, null)),
					Collections.singletonList(_toExtendJSONObject(999L))));

		Assertions.assertEquals(
			HttpStatus.BAD_REQUEST, responseStatusException.getStatusCode());

		Mockito.verify(
			_licenseKeyService, Mockito.never()
		).extendLicenseKey(
			Mockito.anyLong(), Mockito.any(), Mockito.anyLong(), Mockito.any()
		);
	}

	@Test
	public void testExtendRejectsZeroForATrackedLicenseKey() throws Exception {
		_setUpEntitlements(5.0);

		_setUpConsumption(0);

		ResponseStatusException responseStatusException =
			Assertions.assertThrows(
				ResponseStatusException.class,
				() -> _licenseKeyProvisioner.extend(
					_ACCOUNT_ENTRY_ID,
					Collections.singletonList(_toLicenseKey(true, 0, null)),
					Collections.singletonList(_toExtendJSONObject(0))));

		Assertions.assertEquals(
			HttpStatus.BAD_REQUEST, responseStatusException.getStatusCode());

		Mockito.verify(
			_licenseKeyService, Mockito.never()
		).extendLicenseKey(
			Mockito.anyLong(), Mockito.any(), Mockito.anyLong(), Mockito.any()
		);
	}

	@Test
	public void testExtendSpendsTheLicensesTheBatchAlreadyTook()
		throws Exception {

		_setUpEntitlements(1.0);

		_setUpConsumption(0);

		LicenseKey licenseKey = _toLicenseKey(true, 0, null);

		// One license, two extensions: the second has nothing left to take.

		ResponseStatusException responseStatusException =
			Assertions.assertThrows(
				ResponseStatusException.class,
				() -> _licenseKeyProvisioner.extend(
					_ACCOUNT_ENTRY_ID, List.of(licenseKey, licenseKey),
					List.of(
						_toExtendJSONObject(_ENTITLEMENT_ID),
						_toExtendJSONObject(_ENTITLEMENT_ID))));

		Assertions.assertEquals(
			HttpStatus.CONFLICT, responseStatusException.getStatusCode());

		Mockito.verify(
			_licenseKeyService, Mockito.never()
		).extendLicenseKey(
			Mockito.anyLong(), Mockito.any(), Mockito.anyLong(), Mockito.any()
		);
	}

	@Test
	public void testProvision() throws Exception {
		_setUpEntitlementDefinition(
			EntitlementConstants.NAME_LICENSE_GENERATION);

		_setUpEntitlements(5.0);

		_setUpConsumption(2);

		LicenseKey licenseKey = Mockito.mock(LicenseKey.class);

		Mockito.when(
			_licenseKeyService.addLicenseKey(
				_ACCOUNT_ENTRY_ID, "Acme", true, "", false, "Acme description",
				"", _ENTITLEMENT_ID,
				Date.from(Instant.parse("2027-01-01T00:00:00Z")), "acme.host",
				"1.2.3.4", "Portal Production", "production", 3, "AA:BB", 0, 0L,
				0, 0, 0L, "Acme Key", "ORDER-1", "acme@example.com", "portal",
				"Liferay Portal", "7.4", "", "SIZING_1",
				Date.from(Instant.parse("2026-01-01T00:00:00Z")))
		).thenReturn(
			licenseKey
		);

		Assertions.assertEquals(
			Collections.singletonList(licenseKey),
			_licenseKeyProvisioner.provision(
				_createAccount(),
				Collections.singletonList(_createJSONObject())));
	}

	@Test
	public void testProvisionCountsClusterNodesAlreadyConsumed()
		throws Exception {

		_setUpEntitlementDefinition(
			EntitlementConstants.NAME_LICENSE_GENERATION);

		_setUpEntitlements(3.0);

		// One existing three node key consumes the whole entitlement, even
		// though it is a single license key row.

		_setUpConsumption(1, 3);

		ResponseStatusException responseStatusException =
			Assertions.assertThrows(
				ResponseStatusException.class,
				() -> _licenseKeyProvisioner.provision(
					_createAccount(),
					Collections.singletonList(_createJSONObject())));

		Assertions.assertEquals(
			HttpStatus.CONFLICT, responseStatusException.getStatusCode());
	}

	@Test
	public void testProvisionCreatesNothingWhenALaterItemIsInvalid()
		throws Exception {

		_setUpEntitlementDefinition(
			EntitlementConstants.NAME_LICENSE_GENERATION);

		_setUpEntitlements(10.0);

		_setUpConsumption(0);

		JSONObject invalidJSONObject = _createJSONObject();

		invalidJSONObject.put("productVersion", "");

		// The second key is rejected, so the first must not have been created
		// even though it was valid and came first.

		Assertions.assertThrows(
			Exception.class,
			() -> _licenseKeyProvisioner.provision(
				_createAccount(),
				List.of(_createJSONObject(), invalidJSONObject)));

		Mockito.verify(
			_licenseKeyService, Mockito.never()
		).addLicenseKey(
			Mockito.anyLong(), Mockito.any(), Mockito.anyBoolean(),
			Mockito.any(), Mockito.anyBoolean(), Mockito.any(), Mockito.any(),
			Mockito.anyLong(), Mockito.any(), Mockito.any(), Mockito.any(),
			Mockito.any(), Mockito.any(), Mockito.anyInt(), Mockito.any(),
			Mockito.anyInt(), Mockito.anyLong(), Mockito.anyInt(),
			Mockito.anyInt(), Mockito.anyLong(), Mockito.any(), Mockito.any(),
			Mockito.any(), Mockito.any(), Mockito.any(), Mockito.any(),
			Mockito.any(), Mockito.any(), Mockito.any()
		);
	}

	@Test
	public void testProvisionIgnoresDeactivatedKeys() throws Exception {
		_setUpEntitlementDefinition(
			EntitlementConstants.NAME_LICENSE_GENERATION);

		_setUpEntitlements(1.0);

		LicenseKey deactivatedLicenseKey = _toLicenseKey(false, 0, null);

		Mockito.when(
			_licenseKeyService.getLicenseKeysByAccountEntryId(_ACCOUNT_ENTRY_ID)
		).thenReturn(
			Collections.singletonList(deactivatedLicenseKey)
		);

		LicenseKey licenseKey = Mockito.mock(LicenseKey.class);

		Mockito.when(
			_licenseKeyService.addLicenseKey(
				Mockito.anyLong(), Mockito.any(), Mockito.anyBoolean(),
				Mockito.any(), Mockito.anyBoolean(), Mockito.any(),
				Mockito.any(), Mockito.anyLong(), Mockito.any(), Mockito.any(),
				Mockito.any(), Mockito.any(), Mockito.any(), Mockito.anyInt(),
				Mockito.any(), Mockito.anyInt(), Mockito.anyLong(),
				Mockito.anyInt(), Mockito.anyInt(), Mockito.anyLong(),
				Mockito.any(), Mockito.any(), Mockito.any(), Mockito.any(),
				Mockito.any(), Mockito.any(), Mockito.any(), Mockito.any(),
				Mockito.any())
		).thenReturn(
			licenseKey
		);

		Assertions.assertEquals(
			Collections.singletonList(licenseKey),
			_licenseKeyProvisioner.provision(
				_createAccount(),
				Collections.singletonList(_createJSONObject())));
	}

	@Test
	public void testProvisionIgnoresExpiredKeys() throws Exception {
		_setUpEntitlementDefinition(
			EntitlementConstants.NAME_LICENSE_GENERATION);

		_setUpEntitlements(1.0);

		LicenseKey expiredLicenseKey = _toLicenseKey(
			true, 0, Instant.parse("2020-01-01T00:00:00Z"));

		Mockito.when(
			_licenseKeyService.getLicenseKeysByAccountEntryId(_ACCOUNT_ENTRY_ID)
		).thenReturn(
			Collections.singletonList(expiredLicenseKey)
		);

		LicenseKey licenseKey = Mockito.mock(LicenseKey.class);

		Mockito.when(
			_licenseKeyService.addLicenseKey(
				Mockito.anyLong(), Mockito.any(), Mockito.anyBoolean(),
				Mockito.any(), Mockito.anyBoolean(), Mockito.any(),
				Mockito.any(), Mockito.anyLong(), Mockito.any(), Mockito.any(),
				Mockito.any(), Mockito.any(), Mockito.any(), Mockito.anyInt(),
				Mockito.any(), Mockito.anyInt(), Mockito.anyLong(),
				Mockito.anyInt(), Mockito.anyInt(), Mockito.anyLong(),
				Mockito.any(), Mockito.any(), Mockito.any(), Mockito.any(),
				Mockito.any(), Mockito.any(), Mockito.any(), Mockito.any(),
				Mockito.any())
		).thenReturn(
			licenseKey
		);

		Assertions.assertEquals(
			Collections.singletonList(licenseKey),
			_licenseKeyProvisioner.provision(
				_createAccount(),
				Collections.singletonList(_createJSONObject())));
	}

	@Test
	public void testProvisionIssuesNoMoreThanTheQuantityConcurrently()
		throws Exception {

		_setUpEntitlementDefinition(
			EntitlementConstants.NAME_LICENSE_GENERATION);

		_setUpEntitlements(1.0);

		List<LicenseKey> licenseKeys = Collections.synchronizedList(
			new ArrayList<>());

		Mockito.when(
			_licenseKeyService.getLicenseKeysByAccountEntryId(_ACCOUNT_ENTRY_ID)
		).thenAnswer(
			invocation -> new ArrayList<>(licenseKeys)
		);

		Mockito.when(
			_licenseKeyService.addLicenseKey(
				Mockito.anyLong(), Mockito.any(), Mockito.anyBoolean(),
				Mockito.any(), Mockito.anyBoolean(), Mockito.any(),
				Mockito.any(), Mockito.anyLong(), Mockito.any(), Mockito.any(),
				Mockito.any(), Mockito.any(), Mockito.any(), Mockito.anyInt(),
				Mockito.any(), Mockito.anyInt(), Mockito.anyLong(),
				Mockito.anyInt(), Mockito.anyInt(), Mockito.anyLong(),
				Mockito.any(), Mockito.any(), Mockito.any(), Mockito.any(),
				Mockito.any(), Mockito.any(), Mockito.any(), Mockito.any(),
				Mockito.any())
		).thenAnswer(
			invocation -> {
				LicenseKey licenseKey = _toLicenseKey(true, 0, null);

				licenseKeys.add(licenseKey);

				return licenseKey;
			}
		);

		Account account = _createAccount();

		List<Integer> conflicts = Collections.synchronizedList(
			new ArrayList<>());

		ExecutorService executorService = Executors.newFixedThreadPool(2);

		try {
			List<Callable<Void>> callables = new ArrayList<>();

			for (int i = 0; i < 2; i++) {
				callables.add(
					() -> {
						try {
							_licenseKeyProvisioner.provision(
								account,
								Collections.singletonList(_createJSONObject()));
						}
						catch (ResponseStatusException
									responseStatusException) {

							conflicts.add(1);
						}

						return null;
					});
			}

			for (Future<Void> future : executorService.invokeAll(callables)) {
				future.get();
			}
		}
		finally {
			executorService.shutdown();
		}

		Assertions.assertEquals(1, licenseKeys.size());
		Assertions.assertEquals(1, conflicts.size());
	}

	@Test
	public void testProvisionReadsTheEntitlementsOncePerProduct()
		throws Exception {

		_setUpEntitlementDefinition(
			EntitlementConstants.NAME_LICENSE_GENERATION);

		_setUpEntitlements(10.0);

		_setUpConsumption(0);

		_licenseKeyProvisioner.provision(
			_createAccount(),
			List.of(
				_createJSONObject(), _createJSONObject(), _createJSONObject()));

		Mockito.verify(
			_entitlementService, Mockito.times(1)
		).getActiveEntitlements(
			_ACCOUNT_ENTRY_ID
		);

		Mockito.verify(
			_entitlementDefinitionService, Mockito.times(1)
		).fetchEntitlementDefinition(
			Mockito.any()
		);
	}

	@Test
	public void testProvisionSkipsAnEntitlementTooSmallForTheRequest()
		throws Exception {

		_setUpEntitlementDefinition(
			EntitlementConstants.NAME_LICENSE_GENERATION);

		// The aggregate has room for three nodes, but only the second
		// entitlement can cover them on its own.

		_setUpEntitlements(1.0, 5.0);

		_setUpConsumption(0);

		JSONObject jsonObject = _createJSONObject();

		jsonObject.put("maxClusterNodes", 3);

		LicenseKey licenseKey = Mockito.mock(LicenseKey.class);

		Mockito.when(
			_licenseKeyService.addLicenseKey(
				Mockito.anyLong(), Mockito.any(), Mockito.anyBoolean(),
				Mockito.any(), Mockito.anyBoolean(), Mockito.any(),
				Mockito.any(), Mockito.eq(_ENTITLEMENT_ID + 1), Mockito.any(),
				Mockito.any(), Mockito.any(), Mockito.any(), Mockito.any(),
				Mockito.anyInt(), Mockito.any(), Mockito.anyInt(),
				Mockito.anyLong(), Mockito.anyInt(), Mockito.anyInt(),
				Mockito.anyLong(), Mockito.any(), Mockito.any(), Mockito.any(),
				Mockito.any(), Mockito.any(), Mockito.any(), Mockito.any(),
				Mockito.any(), Mockito.any())
		).thenReturn(
			licenseKey
		);

		Assertions.assertEquals(
			Collections.singletonList(licenseKey),
			_licenseKeyProvisioner.provision(
				_createAccount(), Collections.singletonList(jsonObject)));
	}

	@Test
	public void testProvisionWhenAccountHoldsNoEntitlement() throws Exception {
		_setUpEntitlementDefinition(
			EntitlementConstants.NAME_LICENSE_GENERATION);

		Mockito.when(
			_entitlementService.getEntitlements(
				_ACCOUNT_ENTRY_ID, _ENTITLEMENT_DEFINITION_ID)
		).thenReturn(
			Collections.emptyList()
		);

		Assertions.assertEquals(
			HttpStatus.CONFLICT, _assertThrows().getStatusCode());

		Mockito.verify(
			_licenseKeyService, Mockito.never()
		).addLicenseKey(
			Mockito.anyLong(), Mockito.any(), Mockito.anyBoolean(),
			Mockito.any(), Mockito.anyBoolean(), Mockito.any(), Mockito.any(),
			Mockito.anyLong(), Mockito.any(), Mockito.any(), Mockito.any(),
			Mockito.any(), Mockito.any(), Mockito.anyInt(), Mockito.any(),
			Mockito.anyInt(), Mockito.anyLong(), Mockito.anyInt(),
			Mockito.anyInt(), Mockito.anyLong(), Mockito.any(), Mockito.any(),
			Mockito.any(), Mockito.any(), Mockito.any(), Mockito.any(),
			Mockito.any(), Mockito.any(), Mockito.any()
		);
	}

	@Test
	public void testProvisionWhenCapacityIsSpreadAcrossEntitlements()
		throws Exception {

		_setUpEntitlementDefinition(
			EntitlementConstants.NAME_LICENSE_GENERATION);

		// Four licenses in total, but neither entitlement can carry three on
		// its own.

		_setUpEntitlements(2.0, 2.0);

		_setUpConsumption(0);

		JSONObject jsonObject = _createJSONObject();

		jsonObject.put("maxClusterNodes", 3);

		ResponseStatusException responseStatusException =
			Assertions.assertThrows(
				ResponseStatusException.class,
				() -> _licenseKeyProvisioner.provision(
					_createAccount(), Collections.singletonList(jsonObject)));

		Assertions.assertEquals(
			HttpStatus.CONFLICT, responseStatusException.getStatusCode());

		Mockito.verify(
			_licenseKeyService, Mockito.never()
		).addLicenseKey(
			Mockito.anyLong(), Mockito.any(), Mockito.anyBoolean(),
			Mockito.any(), Mockito.anyBoolean(), Mockito.any(), Mockito.any(),
			Mockito.anyLong(), Mockito.any(), Mockito.any(), Mockito.any(),
			Mockito.any(), Mockito.any(), Mockito.anyInt(), Mockito.any(),
			Mockito.anyInt(), Mockito.anyLong(), Mockito.anyInt(),
			Mockito.anyInt(), Mockito.anyLong(), Mockito.any(), Mockito.any(),
			Mockito.any(), Mockito.any(), Mockito.any(), Mockito.any(),
			Mockito.any(), Mockito.any(), Mockito.any()
		);
	}

	@Test
	public void testProvisionWhenDefinitionDoesNotGrantLicenseGeneration()
		throws Exception {

		_setUpEntitlementDefinition("storage");

		Assertions.assertEquals(
			HttpStatus.BAD_REQUEST, _assertThrows().getStatusCode());

		Mockito.verify(
			_licenseKeyService, Mockito.never()
		).addLicenseKey(
			Mockito.anyLong(), Mockito.any(), Mockito.anyBoolean(),
			Mockito.any(), Mockito.anyBoolean(), Mockito.any(), Mockito.any(),
			Mockito.anyLong(), Mockito.any(), Mockito.any(), Mockito.any(),
			Mockito.any(), Mockito.any(), Mockito.anyInt(), Mockito.any(),
			Mockito.anyInt(), Mockito.anyLong(), Mockito.anyInt(),
			Mockito.anyInt(), Mockito.anyLong(), Mockito.any(), Mockito.any(),
			Mockito.any(), Mockito.any(), Mockito.any(), Mockito.any(),
			Mockito.any(), Mockito.any(), Mockito.any()
		);
	}

	@Test
	public void testProvisionWhenLicenseTypeIsInvalid() throws Exception {
		Mockito.when(
			_licenseEntryService.getLicenseEntriesByProductKeyVersion(
				_PRODUCT_KEY, "7.4")
		).thenReturn(
			Collections.singletonList(
				new LicenseEntry(
					_PRODUCT_KEY, "Portal Free", "free", "7.0", ""))
		);

		Assertions.assertEquals(
			HttpStatus.BAD_REQUEST, _assertThrows().getStatusCode());

		Mockito.verify(
			_licenseKeyService, Mockito.never()
		).addLicenseKey(
			Mockito.anyLong(), Mockito.any(), Mockito.anyBoolean(),
			Mockito.any(), Mockito.anyBoolean(), Mockito.any(), Mockito.any(),
			Mockito.anyLong(), Mockito.any(), Mockito.any(), Mockito.any(),
			Mockito.any(), Mockito.any(), Mockito.anyInt(), Mockito.any(),
			Mockito.anyInt(), Mockito.anyLong(), Mockito.anyInt(),
			Mockito.anyInt(), Mockito.anyLong(), Mockito.any(), Mockito.any(),
			Mockito.any(), Mockito.any(), Mockito.any(), Mockito.any(),
			Mockito.any(), Mockito.any(), Mockito.any()
		);
	}

	@Test
	public void testProvisionWhenMaxClusterNodesExhaustsTheQuantity()
		throws Exception {

		_setUpEntitlementDefinition(
			EntitlementConstants.NAME_LICENSE_GENERATION);

		_setUpEntitlements(3.0);

		_setUpConsumption(0);

		JSONObject jsonObject = _createJSONObject();

		jsonObject.put("maxClusterNodes", 4);

		ResponseStatusException responseStatusException =
			Assertions.assertThrows(
				ResponseStatusException.class,
				() -> _licenseKeyProvisioner.provision(
					_createAccount(), Collections.singletonList(jsonObject)));

		Assertions.assertEquals(
			HttpStatus.CONFLICT, responseStatusException.getStatusCode());

		Mockito.verify(
			_licenseKeyService, Mockito.never()
		).addLicenseKey(
			Mockito.anyLong(), Mockito.anyString(), Mockito.anyBoolean(),
			Mockito.anyString(), Mockito.anyBoolean(), Mockito.anyString(),
			Mockito.anyString(), Mockito.anyLong(), Mockito.any(),
			Mockito.anyString(), Mockito.anyString(), Mockito.anyString(),
			Mockito.anyString(), Mockito.anyInt(), Mockito.anyString(),
			Mockito.anyInt(), Mockito.anyLong(), Mockito.anyInt(),
			Mockito.anyInt(), Mockito.anyLong(), Mockito.anyString(),
			Mockito.anyString(), Mockito.anyString(), Mockito.anyString(),
			Mockito.anyString(), Mockito.anyString(), Mockito.anyString(),
			Mockito.anyString(), Mockito.any()
		);
	}

	@Test
	public void testProvisionWhenMaxClusterNodesIsOutOfRange()
		throws Exception {

		_setUpEntitlementDefinition(
			EntitlementConstants.NAME_LICENSE_GENERATION);

		_setUpEntitlements(5.0);

		_setUpConsumption(0);

		JSONObject jsonObject = _createJSONObject();

		jsonObject.put("maxClusterNodes", Integer.MAX_VALUE);

		ResponseStatusException responseStatusException =
			Assertions.assertThrows(
				ResponseStatusException.class,
				() -> _licenseKeyProvisioner.provision(
					_createAccount(), Collections.singletonList(jsonObject)));

		Assertions.assertEquals(
			HttpStatus.BAD_REQUEST, responseStatusException.getStatusCode());
	}

	@Test
	public void testProvisionWhenNoLicensesRemain() throws Exception {
		_setUpEntitlementDefinition(
			EntitlementConstants.NAME_LICENSE_GENERATION);

		_setUpEntitlements(2.0);

		_setUpConsumption(2);

		Assertions.assertEquals(
			HttpStatus.CONFLICT, _assertThrows().getStatusCode());
	}

	@Test
	public void testProvisionWhenOwnerIsNull() throws Exception {
		_setUpEntitlementDefinition(
			EntitlementConstants.NAME_LICENSE_GENERATION);

		_setUpEntitlements(5.0);

		_setUpConsumption(0);

		LicenseKey licenseKey = Mockito.mock(LicenseKey.class);

		Mockito.when(
			_licenseKeyService.addLicenseKey(
				_ACCOUNT_ENTRY_ID, "Acme", true, "", false, "Acme", "",
				_ENTITLEMENT_ID,
				Date.from(Instant.parse("2027-01-01T00:00:00Z")), "acme.host",
				"1.2.3.4", "Portal Production", "production", 3, "AA:BB", 0, 0L,
				0, 0, 0L, "Acme Key", "ORDER-1", "Acme", "portal",
				"Liferay Portal", "7.4", "", "SIZING_1",
				Date.from(Instant.parse("2026-01-01T00:00:00Z")))
		).thenReturn(
			licenseKey
		);

		JSONObject jsonObject = _createJSONObject();

		jsonObject.remove("description");
		jsonObject.remove("owner");

		Assertions.assertEquals(
			Collections.singletonList(licenseKey),
			_licenseKeyProvisioner.provision(
				_createAccount(), Collections.singletonList(jsonObject)));
	}

	private ResponseStatusException _assertThrows() {
		return Assertions.assertThrows(
			ResponseStatusException.class,
			() -> _licenseKeyProvisioner.provision(
				_createAccount(),
				Collections.singletonList(_createJSONObject())));
	}

	private Account _createAccount() {
		Account account = new Account();

		account.setId(_ACCOUNT_ENTRY_ID);
		account.setName("Acme");

		return account;
	}

	private JSONObject _createJSONObject() {
		return new JSONObject(
		).put(
			"description", "Acme description"
		).put(
			"expirationDate", "2027-01-01T00:00:00Z"
		).put(
			"hostName", "acme.host"
		).put(
			"ipAddresses", "1.2.3.4"
		).put(
			"licenseType", "production"
		).put(
			"macAddresses", "AA:BB"
		).put(
			"name", "Acme Key"
		).put(
			"orderId", "ORDER-1"
		).put(
			"owner", "acme@example.com"
		).put(
			"productExternalId", "portal"
		).put(
			"productExternalReferenceCode",
			EntitlementConstants.EXTERNAL_REFERENCE_CODE_PORTAL
		).put(
			"productKey", _PRODUCT_KEY
		).put(
			"productName", "Liferay Portal"
		).put(
			"productVersion", "7.4"
		).put(
			"sizing", "SIZING_1"
		).put(
			"startDate", "2026-01-01T00:00:00Z"
		);
	}

	private void _setUpConsumption(int count) throws Exception {
		_setUpConsumption(count, 0);
	}

	private void _setUpConsumption(int count, int maxClusterNodes)
		throws Exception {

		List<LicenseKey> licenseKeys = new ArrayList<>();

		for (int i = 0; i < count; i++) {
			licenseKeys.add(_toLicenseKey(true, maxClusterNodes, null));
		}

		Mockito.when(
			_licenseKeyService.getLicenseKeysByAccountEntryId(_ACCOUNT_ENTRY_ID)
		).thenReturn(
			licenseKeys
		);
	}

	private void _setUpEntitlementDefinition(String name) throws Exception {
		EntitlementDefinition entitlementDefinition = Mockito.mock(
			EntitlementDefinition.class);

		Mockito.when(
			entitlementDefinition.getEntitlementDefinitionId()
		).thenReturn(
			_ENTITLEMENT_DEFINITION_ID
		);

		Mockito.when(
			entitlementDefinition.getName()
		).thenReturn(
			name
		);

		Mockito.when(
			_entitlementDefinitionService.fetchEntitlementDefinition(
				EntitlementConstants.EXTERNAL_REFERENCE_CODE_PORTAL)
		).thenReturn(
			entitlementDefinition
		);
	}

	private void _setUpEntitlements(Double... quantities) throws Exception {
		List<Entitlement> entitlements = new ArrayList<>();

		for (int i = 0; i < quantities.length; i++) {
			Entitlement entitlement = Mockito.mock(Entitlement.class);

			EntitlementDefinition entitlementDefinition = Mockito.mock(
				EntitlementDefinition.class);

			Mockito.when(
				entitlementDefinition.getName()
			).thenReturn(
				EntitlementConstants.NAME_LICENSE_GENERATION
			);

			Mockito.when(
				entitlement.getEntitlementDefinition()
			).thenReturn(
				entitlementDefinition
			);

			Mockito.when(
				entitlement.getEntitlementDefinitionId()
			).thenReturn(
				_ENTITLEMENT_DEFINITION_ID
			);

			Mockito.when(
				entitlement.getEntitlementId()
			).thenReturn(
				_ENTITLEMENT_ID + i
			);

			Mockito.when(
				entitlement.getQuantity()
			).thenReturn(
				quantities[i]
			);

			entitlements.add(entitlement);
		}

		Mockito.when(
			_entitlementService.getActiveEntitlements(_ACCOUNT_ENTRY_ID)
		).thenReturn(
			entitlements
		);
	}

	private void _setUpLicenseEntry() {
		Mockito.when(
			_licenseEntryService.getLicenseEntriesByProductKeyVersion(
				_PRODUCT_KEY, "7.4")
		).thenReturn(
			List.of(
				new LicenseEntry(
					_PRODUCT_KEY, "Portal Free", "free", "7.0", ""),
				new LicenseEntry(
					_PRODUCT_KEY, "Portal Production", "production", "7.0", ""))
		);
	}

	private JSONObject _toExtendJSONObject(long entitlementId) {
		return new JSONObject(
		).put(
			"entitlementId", entitlementId
		).put(
			"expirationDate", "2028-01-01T00:00:00Z"
		).put(
			"startDate", "2027-01-01T00:00:00Z"
		);
	}

	private LicenseKey _toLicenseKey(
		boolean active, int maxClusterNodes,
		Instant customExpirationDateInstant) {

		LicenseKey licenseKey = Mockito.mock(LicenseKey.class);

		Mockito.when(
			licenseKey.getCustomExpirationDateInstant()
		).thenReturn(
			customExpirationDateInstant
		);

		Mockito.when(
			licenseKey.getEntitlementId()
		).thenReturn(
			_ENTITLEMENT_ID
		);

		Mockito.when(
			licenseKey.getMaxClusterNodes()
		).thenReturn(
			maxClusterNodes
		);

		Mockito.when(
			licenseKey.isActive()
		).thenReturn(
			active
		);

		return licenseKey;
	}

	private static final long _ACCOUNT_ENTRY_ID = 55L;

	private static final long _ENTITLEMENT_DEFINITION_ID = 88L;

	private static final long _ENTITLEMENT_ID = 77L;

	private static final String _PRODUCT_KEY = "KOR-36143";

	private EntitlementDefinitionService _entitlementDefinitionService;
	private EntitlementService _entitlementService;
	private LicenseEntryService _licenseEntryService;
	private LicenseKeyProvisioner _licenseKeyProvisioner;
	private LicenseKeyService _licenseKeyService;
	private LicenseKeyValidator _licenseKeyValidator;

}