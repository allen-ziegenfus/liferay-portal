/**
 * SPDX-FileCopyrightText: (c) 2000 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.oauth2.provider.internal.scheduler;

import com.liferay.counter.kernel.service.CounterLocalService;
import com.liferay.oauth2.provider.exception.DuplicateOAuth2ScopeGrantException;
import com.liferay.oauth2.provider.model.OAuth2Application;
import com.liferay.oauth2.provider.model.OAuth2ApplicationScopeAliases;
import com.liferay.oauth2.provider.model.OAuth2ScopeGrant;
import com.liferay.oauth2.provider.scope.liferay.LiferayOAuth2Scope;
import com.liferay.oauth2.provider.scope.liferay.ScopeLocator;
import com.liferay.oauth2.provider.scope.liferay.UnresolvedScopeAliasReconciler;
import com.liferay.oauth2.provider.scope.liferay.UnresolvedScopeAliasesRegistry;
import com.liferay.oauth2.provider.service.OAuth2ApplicationLocalService;
import com.liferay.oauth2.provider.service.OAuth2ApplicationScopeAliasesLocalService;
import com.liferay.oauth2.provider.service.OAuth2ScopeGrantLocalService;
import com.liferay.osgi.util.configuration.ConfigurationFactoryUtil;
import com.liferay.petra.string.StringBundler;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.service.CompanyLocalService;
import com.liferay.portal.kernel.util.HashMapBuilder;
import com.liferay.portal.kernel.util.StringUtil;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.atomic.AtomicBoolean;

import org.osgi.framework.Bundle;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * @author Allen Ziegenfus
 */
@Component(service = UnresolvedScopeAliasReconciler.class)
public class UnresolvedScopeAliasReconcilerImpl
	implements UnresolvedScopeAliasReconciler {

	@Override
	public void reconcile() throws Exception {
		_pending.set(true);

		while (_reconciling.compareAndSet(false, true)) {
			try {
				if (!_pending.compareAndSet(true, false)) {
					return;
				}

				_reconcileOnce();
			}
			catch (Exception exception) {
				_pending.set(true);

				throw exception;
			}
			finally {
				_reconciling.set(false);
			}

			if (!_pending.get()) {
				return;
			}
		}
	}

	private void _addScopeAliases(
			OAuth2Application oAuth2Application, List<String> scopeAliasesList)
		throws Exception {

		long companyId = oAuth2Application.getCompanyId();

		long oAuth2ApplicationScopeAliasesId = _counterLocalService.increment(
			OAuth2ApplicationScopeAliases.class.getName());

		OAuth2ApplicationScopeAliases oAuth2ApplicationScopeAliases =
			_oAuth2ApplicationScopeAliasesLocalService.
				createOAuth2ApplicationScopeAliases(
					oAuth2ApplicationScopeAliasesId);

		oAuth2ApplicationScopeAliases.setCompanyId(companyId);
		oAuth2ApplicationScopeAliases.setUserId(oAuth2Application.getUserId());
		oAuth2ApplicationScopeAliases.setUserName(
			oAuth2Application.getUserName());
		oAuth2ApplicationScopeAliases.setCreateDate(new Date());
		oAuth2ApplicationScopeAliases.setOAuth2ApplicationId(
			oAuth2Application.getOAuth2ApplicationId());

		_oAuth2ApplicationScopeAliasesLocalService.
			updateOAuth2ApplicationScopeAliases(oAuth2ApplicationScopeAliases);

		for (OAuth2ScopeGrant oAuth2ScopeGrant :
				_oAuth2ScopeGrantLocalService.getOAuth2ScopeGrants(
					oAuth2Application.getOAuth2ApplicationScopeAliasesId(),
					QueryUtil.ALL_POS, QueryUtil.ALL_POS, null)) {

			_oAuth2ScopeGrantLocalService.createOAuth2ScopeGrant(
				companyId, oAuth2ApplicationScopeAliasesId,
				oAuth2ScopeGrant.getApplicationName(),
				oAuth2ScopeGrant.getBundleSymbolicName(),
				oAuth2ScopeGrant.getScope(),
				oAuth2ScopeGrant.getScopeAliasesList());
		}

		for (String scopeAlias : scopeAliasesList) {
			for (LiferayOAuth2Scope liferayOAuth2Scope :
					_scopeLocator.getLiferayOAuth2Scopes(
						companyId, scopeAlias)) {

				Bundle bundle = liferayOAuth2Scope.getBundle();

				try {
					_oAuth2ScopeGrantLocalService.createOAuth2ScopeGrant(
						companyId, oAuth2ApplicationScopeAliasesId,
						liferayOAuth2Scope.getApplicationName(),
						bundle.getSymbolicName(), liferayOAuth2Scope.getScope(),
						Collections.singletonList(scopeAlias));
				}
				catch (DuplicateOAuth2ScopeGrantException
							duplicateOAuth2ScopeGrantException) {

					// The scope is already granted by an existing alias

				}
			}
		}

		oAuth2Application.setOAuth2ApplicationScopeAliasesId(
			oAuth2ApplicationScopeAliasesId);

		_oAuth2ApplicationLocalService.updateOAuth2Application(
			oAuth2Application);
	}

	private String _normalizeScopeAlias(
		Collection<String> registeredScopeAliases, String scopeAlias) {

		if (registeredScopeAliases.contains(scopeAlias)) {
			return scopeAlias;
		}

		for (String registeredScopeAlias : registeredScopeAliases) {
			if (StringUtil.equalsIgnoreCase(registeredScopeAlias, scopeAlias)) {
				return registeredScopeAlias;
			}
		}

		return scopeAlias;
	}

	private void _reconcile(long companyId, Set<Long> oAuth2ApplicationIds)
		throws Exception {

		Collection<String> registeredScopeAliases =
			_scopeLocator.getScopeAliases(companyId);

		for (long oAuth2ApplicationId : oAuth2ApplicationIds) {
			OAuth2Application oAuth2Application =
				_oAuth2ApplicationLocalService.fetchOAuth2Application(
					oAuth2ApplicationId);

			if (oAuth2Application == null) {
				_unresolvedScopeAliasesRegistry.removeUnresolvedScopeAliases(
					companyId, oAuth2ApplicationId);

				continue;
			}

			try {
				_reconcile(oAuth2Application, registeredScopeAliases);
			}
			catch (Exception exception) {
				if (_log.isWarnEnabled()) {
					_log.warn(
						"Unable to reconcile OAuth 2 application " +
							oAuth2ApplicationId,
						exception);
				}
			}
		}
	}

	private void _reconcile(
			OAuth2Application oAuth2Application,
			Collection<String> registeredScopeAliases)
		throws Exception {

		long companyId = oAuth2Application.getCompanyId();
		long oAuth2ApplicationId = oAuth2Application.getOAuth2ApplicationId();

		Collection<String> unresolvedScopeAliases =
			_unresolvedScopeAliasesRegistry.getUnresolvedScopeAliases(
				companyId, oAuth2ApplicationId);

		if (unresolvedScopeAliases.isEmpty()) {
			return;
		}

		List<String> boundScopeAliasesList = new ArrayList<>();
		List<String> resolvedScopeAliasesList = new ArrayList<>();

		for (String scopeAlias : unresolvedScopeAliases) {
			String normalizedScopeAlias = _normalizeScopeAlias(
				registeredScopeAliases, scopeAlias);

			if (!_scopeLocator.getLiferayOAuth2Scopes(
					companyId, normalizedScopeAlias
				).isEmpty()) {

				boundScopeAliasesList.add(scopeAlias);
				resolvedScopeAliasesList.add(normalizedScopeAlias);
			}
		}

		if (boundScopeAliasesList.isEmpty()) {
			return;
		}

		_addScopeAliases(oAuth2Application, resolvedScopeAliasesList);

		List<String> remainingScopeAliasesList = new ArrayList<>(
			unresolvedScopeAliases);

		remainingScopeAliasesList.removeAll(boundScopeAliasesList);

		if (remainingScopeAliasesList.isEmpty()) {
			_unresolvedScopeAliasesRegistry.removeUnresolvedScopeAliases(
				companyId, oAuth2ApplicationId);
		}
		else {
			_unresolvedScopeAliasesRegistry.setUnresolvedScopeAliases(
				companyId, oAuth2ApplicationId, remainingScopeAliasesList);
		}

		if (_log.isInfoEnabled()) {
			_log.info(
				StringBundler.concat(
					"Bound previously unresolved scope aliases ",
					boundScopeAliasesList, " for OAuth 2 application ",
					oAuth2ApplicationId));
		}
	}

	private void _reconcileOnce() throws Exception {
		if (_unresolvedScopeAliasesRegistry.isEmpty()) {
			return;
		}

		Map<Long, Set<Long>> oAuth2ApplicationIdsByCompanyId =
			_unresolvedScopeAliasesRegistry.
				getOAuth2ApplicationIdsByCompanyId();

		if (_log.isDebugEnabled()) {
			_log.debug(
				"Reconciling unresolved scope aliases for OAuth 2 " +
					"applications " + oAuth2ApplicationIdsByCompanyId);
		}

		for (Map.Entry<Long, Set<Long>> entry :
				oAuth2ApplicationIdsByCompanyId.entrySet()) {

			long companyId = entry.getKey();

			Set<Long> oAuth2ApplicationIds = entry.getValue();

			try {
				ConfigurationFactoryUtil.executeAsCompany(
					_companyLocalService,
					HashMapBuilder.<String, Object>put(
						"companyId", companyId
					).build(),
					curCompanyId -> _reconcile(
						curCompanyId, oAuth2ApplicationIds));
			}
			catch (Exception exception) {
				if (_log.isWarnEnabled()) {
					_log.warn(
						"Unable to reconcile OAuth 2 applications for " +
							"company " + companyId,
						exception);
				}
			}
		}
	}

	private static final Log _log = LogFactoryUtil.getLog(
		UnresolvedScopeAliasReconcilerImpl.class);

	@Reference
	private CompanyLocalService _companyLocalService;

	@Reference
	private CounterLocalService _counterLocalService;

	@Reference
	private OAuth2ApplicationLocalService _oAuth2ApplicationLocalService;

	@Reference
	private OAuth2ApplicationScopeAliasesLocalService
		_oAuth2ApplicationScopeAliasesLocalService;

	@Reference
	private OAuth2ScopeGrantLocalService _oAuth2ScopeGrantLocalService;

	private final AtomicBoolean _pending = new AtomicBoolean();
	private final AtomicBoolean _reconciling = new AtomicBoolean();

	@Reference
	private ScopeLocator _scopeLocator;

	@Reference
	private UnresolvedScopeAliasesRegistry _unresolvedScopeAliasesRegistry;

}