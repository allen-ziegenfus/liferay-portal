/**
 * SPDX-FileCopyrightText: (c) 2000 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.oauth2.provider.scope.internal.liferay;

import com.liferay.oauth2.provider.scope.liferay.UnresolvedScopeAliasesRegistry;
import com.liferay.portal.test.rule.LiferayUnitTestRule;

import java.util.Arrays;
import java.util.Collection;
import java.util.Set;

import org.junit.Assert;
import org.junit.Before;
import org.junit.ClassRule;
import org.junit.Rule;
import org.junit.Test;

/**
 * @author Allen Ziegenfus
 */
public class UnresolvedScopeAliasesRegistryImplTest {

	@ClassRule
	@Rule
	public static final LiferayUnitTestRule liferayUnitTestRule =
		LiferayUnitTestRule.INSTANCE;

	@Before
	public void setUp() {
		_unresolvedScopeAliasesRegistry =
			new UnresolvedScopeAliasesRegistryImpl();
	}

	@Test
	public void testGetOAuth2ApplicationIdsReturnsSnapshot() {
		_unresolvedScopeAliasesRegistry.setUnresolvedScopeAliases(
			100L, Arrays.asList("C_Foo.everything"));

		Set<Long> oAuth2ApplicationIds =
			_unresolvedScopeAliasesRegistry.getOAuth2ApplicationIds();

		for (long oAuth2ApplicationId : oAuth2ApplicationIds) {
			_unresolvedScopeAliasesRegistry.removeUnresolvedScopeAliases(
				oAuth2ApplicationId);
			_unresolvedScopeAliasesRegistry.setUnresolvedScopeAliases(
				200L, Arrays.asList("C_Bar.everything"));
		}

		Assert.assertFalse(oAuth2ApplicationIds.contains(200L));
	}

	@Test
	public void testRemoveUnresolvedScopeAliases() {
		_unresolvedScopeAliasesRegistry.setUnresolvedScopeAliases(
			100L, Arrays.asList("C_Foo.everything"));

		_unresolvedScopeAliasesRegistry.removeUnresolvedScopeAliases(100L);

		Set<Long> oAuth2ApplicationIds =
			_unresolvedScopeAliasesRegistry.getOAuth2ApplicationIds();

		Assert.assertFalse(oAuth2ApplicationIds.contains(100L));
	}

	@Test
	public void testSetOverwritesPreviousScopeAliases() {
		_unresolvedScopeAliasesRegistry.setUnresolvedScopeAliases(
			100L, Arrays.asList("C_Foo.everything"));
		_unresolvedScopeAliasesRegistry.setUnresolvedScopeAliases(
			100L, Arrays.asList("C_Bar.everything"));

		Collection<String> scopeAliases =
			_unresolvedScopeAliasesRegistry.getUnresolvedScopeAliases(100L);

		Assert.assertFalse(scopeAliases.contains("C_Foo.everything"));
		Assert.assertTrue(scopeAliases.contains("C_Bar.everything"));
	}

	@Test
	public void testSetUnresolvedScopeAliases() {
		_unresolvedScopeAliasesRegistry.setUnresolvedScopeAliases(
			100L, Arrays.asList("C_Foo.everything", "C_Bar.everything"));

		Collection<String> scopeAliases =
			_unresolvedScopeAliasesRegistry.getUnresolvedScopeAliases(100L);

		Assert.assertTrue(scopeAliases.contains("C_Foo.everything"));
		Assert.assertTrue(scopeAliases.contains("C_Bar.everything"));

		Set<Long> oAuth2ApplicationIds =
			_unresolvedScopeAliasesRegistry.getOAuth2ApplicationIds();

		Assert.assertTrue(oAuth2ApplicationIds.contains(100L));
	}

	@Test
	public void testUnknownOAuth2ApplicationId() {
		Collection<String> scopeAliases =
			_unresolvedScopeAliasesRegistry.getUnresolvedScopeAliases(999L);

		Assert.assertTrue(scopeAliases.isEmpty());

		Set<Long> oAuth2ApplicationIds =
			_unresolvedScopeAliasesRegistry.getOAuth2ApplicationIds();

		Assert.assertTrue(oAuth2ApplicationIds.isEmpty());
	}

	private UnresolvedScopeAliasesRegistry _unresolvedScopeAliasesRegistry;

}