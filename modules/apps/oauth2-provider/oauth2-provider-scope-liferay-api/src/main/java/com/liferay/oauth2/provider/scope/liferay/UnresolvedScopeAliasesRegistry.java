/**
 * SPDX-FileCopyrightText: (c) 2000 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.oauth2.provider.scope.liferay;

import java.util.Collection;
import java.util.Map;
import java.util.Set;

import org.osgi.annotation.versioning.ProviderType;

/**
 * Tracks the scope aliases an OAuth 2 application declared that did not resolve
 * to any scope when its configuration was applied. A configuration factory
 * knows the declared aliases, but an alias whose scope source (such as a custom
 * object or DataSet) registers later resolves to nothing and is never persisted
 * as a scope grant. This registry keeps that declared intent available so a
 * reconciler can bind it once the missing scope sources register.
 *
 * <p>
 * Entries are keyed on the company together with the application because primary
 * keys repeat across virtual instances under database partitioning. A caller
 * must supply the company so a reconciler can select the right schema before it
 * reads the application.
 * </p>
 *
 * @author Allen Ziegenfus
 */
@ProviderType
public interface UnresolvedScopeAliasesRegistry {

	public Map<Long, Set<Long>> getOAuth2ApplicationIdsByCompanyId();

	public Collection<String> getUnresolvedScopeAliases(
		long companyId, long oAuth2ApplicationId);

	public boolean isEmpty();

	public void removeUnresolvedScopeAliases(
		long companyId, long oAuth2ApplicationId);

	public void setUnresolvedScopeAliases(
		long companyId, long oAuth2ApplicationId,
		Collection<String> scopeAliases);

}