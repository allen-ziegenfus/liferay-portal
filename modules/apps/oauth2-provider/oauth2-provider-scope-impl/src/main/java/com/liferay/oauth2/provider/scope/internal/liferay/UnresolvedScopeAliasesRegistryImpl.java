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
	public Set<Long> getOAuth2ApplicationIds() {
		return new HashSet<>(_scopeAliasesMap.keySet());
	}

	@Override
	public Collection<String> getUnresolvedScopeAliases(
		long oAuth2ApplicationId) {

		return _scopeAliasesMap.getOrDefault(
			oAuth2ApplicationId, Collections.emptySet());
	}

	@Override
	public boolean isEmpty() {
		return _scopeAliasesMap.isEmpty();
	}

	@Override
	public void removeUnresolvedScopeAliases(long oAuth2ApplicationId) {
		_scopeAliasesMap.remove(oAuth2ApplicationId);
	}

	@Override
	public void setUnresolvedScopeAliases(
		long oAuth2ApplicationId, Collection<String> scopeAliases) {

		if ((scopeAliases == null) || scopeAliases.isEmpty()) {
			_scopeAliasesMap.remove(oAuth2ApplicationId);

			return;
		}

		_scopeAliasesMap.put(
			oAuth2ApplicationId,
			Collections.unmodifiableSet(new LinkedHashSet<>(scopeAliases)));
	}

	private final Map<Long, Set<String>> _scopeAliasesMap =
		new ConcurrentHashMap<>();

}