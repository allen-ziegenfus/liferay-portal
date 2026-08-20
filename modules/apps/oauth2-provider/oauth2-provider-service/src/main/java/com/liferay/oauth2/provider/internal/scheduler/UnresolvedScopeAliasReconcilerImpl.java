/**
 * SPDX-FileCopyrightText: (c) 2000 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.oauth2.provider.internal.scheduler;

import com.liferay.oauth2.provider.model.OAuth2Application;
import com.liferay.oauth2.provider.scope.liferay.ScopeLocator;
import com.liferay.oauth2.provider.scope.liferay.UnresolvedScopeAliasReconciler;
import com.liferay.oauth2.provider.scope.liferay.UnresolvedScopeAliasesRegistry;
import com.liferay.oauth2.provider.service.OAuth2ApplicationLocalService;
import com.liferay.oauth2.provider.service.OAuth2ApplicationScopeAliasesLocalService;
import com.liferay.osgi.util.configuration.ConfigurationFactoryUtil;
import com.liferay.petra.string.StringBundler;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.service.CompanyLocalService;
import com.liferay.portal.kernel.util.HashMapBuilder;
import com.liferay.portal.kernel.util.StringUtil;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.concurrent.atomic.AtomicBoolean;

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
		if (!_reconciling.compareAndSet(false, true)) {
			return;
		}

		try {
			_reconcileOnce();
		}
		finally {
			_reconciling.set(false);
		}
	}

	private boolean _hasNewlyResolvedScopeAlias(
		long companyId, Collection<String> scopeAliases) {

		for (String scopeAlias : scopeAliases) {
			if (!_scopeLocator.getLiferayOAuth2Scopes(
					companyId, scopeAlias
				).isEmpty()) {

				return true;
			}
		}

		return false;
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

	private void _reconcile(OAuth2Application oAuth2Application)
		throws Exception {

		long oAuth2ApplicationId = oAuth2Application.getOAuth2ApplicationId();

		Collection<String> unresolvedScopeAliases =
			_unresolvedScopeAliasesRegistry.getUnresolvedScopeAliases(
				oAuth2ApplicationId);

		if (unresolvedScopeAliases.isEmpty()) {
			return;
		}

		long companyId = oAuth2Application.getCompanyId();

		Collection<String> registeredScopeAliases =
			_scopeLocator.getScopeAliases(companyId);

		List<String> normalizedScopeAliasesList = new ArrayList<>();

		for (String scopeAlias : unresolvedScopeAliases) {
			normalizedScopeAliasesList.add(
				_normalizeScopeAlias(registeredScopeAliases, scopeAlias));
		}

		if (!_hasNewlyResolvedScopeAlias(
				companyId, normalizedScopeAliasesList)) {

			return;
		}

		List<String> scopeAliasesList = new ArrayList<>(
			_oAuth2ApplicationScopeAliasesLocalService.getScopeAliasesList(
				oAuth2Application.getOAuth2ApplicationScopeAliasesId()));

		boolean modified = false;

		for (String scopeAlias : normalizedScopeAliasesList) {
			if (!scopeAliasesList.contains(scopeAlias)) {
				scopeAliasesList.add(scopeAlias);

				modified = true;
			}
		}

		// Another node (or an earlier pass) already persisted every resolvable
		// alias, so there is nothing to write; just clear the registry entry

		if (!modified) {
			_unresolvedScopeAliasesRegistry.removeUnresolvedScopeAliases(
				oAuth2ApplicationId);

			return;
		}

		_oAuth2ApplicationLocalService.updateScopeAliases(
			oAuth2Application.getUserId(), oAuth2Application.getUserName(),
			oAuth2ApplicationId, scopeAliasesList);

		OAuth2Application reconciledOAuth2Application =
			_oAuth2ApplicationLocalService.fetchOAuth2Application(
				oAuth2ApplicationId);

		if (reconciledOAuth2Application == null) {
			_unresolvedScopeAliasesRegistry.removeUnresolvedScopeAliases(
				oAuth2ApplicationId);

			return;
		}

		List<String> unreconciledScopeAliasesList = new ArrayList<>(
			normalizedScopeAliasesList);

		unreconciledScopeAliasesList.removeAll(
			_oAuth2ApplicationScopeAliasesLocalService.getScopeAliasesList(
				reconciledOAuth2Application.
					getOAuth2ApplicationScopeAliasesId()));

		if (unreconciledScopeAliasesList.isEmpty()) {
			_unresolvedScopeAliasesRegistry.removeUnresolvedScopeAliases(
				oAuth2ApplicationId);
		}
		else {
			_unresolvedScopeAliasesRegistry.setUnresolvedScopeAliases(
				oAuth2ApplicationId, unreconciledScopeAliasesList);
		}

		if (_log.isInfoEnabled()) {
			List<String> boundScopeAliasesList = new ArrayList<>(
				normalizedScopeAliasesList);

			boundScopeAliasesList.removeAll(unreconciledScopeAliasesList);

			_log.info(
				StringBundler.concat(
					"Bound previously unresolved scope aliases ",
					boundScopeAliasesList, " for OAuth 2 application ",
					oAuth2ApplicationId));
		}
	}

	private void _reconcileOnce() throws Exception {
		Set<Long> oAuth2ApplicationIds =
			_unresolvedScopeAliasesRegistry.getOAuth2ApplicationIds();

		if (oAuth2ApplicationIds.isEmpty()) {
			return;
		}

		if (_log.isDebugEnabled()) {
			_log.debug(
				"Reconciling unresolved scope aliases for OAuth 2 " +
					"applications " + oAuth2ApplicationIds);
		}

		for (long oAuth2ApplicationId : oAuth2ApplicationIds) {
			OAuth2Application oAuth2Application =
				_oAuth2ApplicationLocalService.fetchOAuth2Application(
					oAuth2ApplicationId);

			if (oAuth2Application == null) {
				_unresolvedScopeAliasesRegistry.removeUnresolvedScopeAliases(
					oAuth2ApplicationId);

				continue;
			}

			try {
				ConfigurationFactoryUtil.executeAsCompany(
					_companyLocalService,
					HashMapBuilder.<String, Object>put(
						"companyId", oAuth2Application.getCompanyId()
					).build(),
					curCompanyId -> _reconcile(oAuth2Application));
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

	private static final Log _log = LogFactoryUtil.getLog(
		UnresolvedScopeAliasReconcilerImpl.class);

	@Reference
	private CompanyLocalService _companyLocalService;

	@Reference
	private OAuth2ApplicationLocalService _oAuth2ApplicationLocalService;

	@Reference
	private OAuth2ApplicationScopeAliasesLocalService
		_oAuth2ApplicationScopeAliasesLocalService;

	private final AtomicBoolean _reconciling = new AtomicBoolean();

	@Reference
	private ScopeLocator _scopeLocator;

	@Reference
	private UnresolvedScopeAliasesRegistry _unresolvedScopeAliasesRegistry;

}