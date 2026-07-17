/**
 * SPDX-FileCopyrightText: (c) 2000 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.oauth2.provider.scope.internal.liferay;

import com.liferay.oauth2.provider.scope.liferay.UnresolvedScopeAliasesRegistry;

import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.osgi.service.component.annotations.Component;

/**
 * @author Allen Ziegenfus
 */
@Component(service = UnresolvedScopeAliasesRegistry.class)
public class UnresolvedScopeAliasesRegistryImpl
	implements UnresolvedScopeAliasesRegistry {

	@Override
	public long getCompanyId(long oAuth2ApplicationId) {
		UnresolvedScopeAliases unresolvedScopeAliases =
			_unresolvedScopeAliasesMap.get(oAuth2ApplicationId);

		if (unresolvedScopeAliases == null) {
			return 0;
		}

		return unresolvedScopeAliases.getCompanyId();
	}

	@Override
	public Set<Long> getOAuth2ApplicationIds() {
		return new HashSet<>(_unresolvedScopeAliasesMap.keySet());
	}

	@Override
	public Collection<String> getUnresolvedScopeAliases(
		long oAuth2ApplicationId) {

		UnresolvedScopeAliases unresolvedScopeAliases =
			_unresolvedScopeAliasesMap.get(oAuth2ApplicationId);

		if (unresolvedScopeAliases == null) {
			return Collections.emptySet();
		}

		return unresolvedScopeAliases.getScopeAliases();
	}

	@Override
	public void removeUnresolvedScopeAliases(long oAuth2ApplicationId) {
		_unresolvedScopeAliasesMap.remove(oAuth2ApplicationId);
	}

	@Override
	public void setUnresolvedScopeAliases(
		long companyId, long oAuth2ApplicationId,
		Collection<String> scopeAliases) {

		_unresolvedScopeAliasesMap.put(
			oAuth2ApplicationId,
			new UnresolvedScopeAliases(
				companyId,
				Collections.unmodifiableSet(
					new LinkedHashSet<>(scopeAliases))));
	}

	private final Map<Long, UnresolvedScopeAliases> _unresolvedScopeAliasesMap =
		new ConcurrentHashMap<>();

	private static class UnresolvedScopeAliases {

		public UnresolvedScopeAliases(
			long companyId, Set<String> scopeAliases) {

			_companyId = companyId;
			_scopeAliases = scopeAliases;
		}

		public long getCompanyId() {
			return _companyId;
		}

		public Set<String> getScopeAliases() {
			return _scopeAliases;
		}

		private final long _companyId;
		private final Set<String> _scopeAliases;

	}

}