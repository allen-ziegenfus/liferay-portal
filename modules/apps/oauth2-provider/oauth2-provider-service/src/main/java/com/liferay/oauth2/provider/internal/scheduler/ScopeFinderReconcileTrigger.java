/**
 * SPDX-FileCopyrightText: (c) 2000 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.oauth2.provider.internal.scheduler;

import com.liferay.oauth2.provider.scope.liferay.UnresolvedScopeAliasReconciler;
import com.liferay.oauth2.provider.scope.liferay.UnresolvedScopeAliasesRegistry;
import com.liferay.oauth2.provider.scope.spi.scope.finder.ScopeFinder;
import com.liferay.petra.executor.PortalExecutorManager;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.module.framework.ModuleServiceLifecycle;

import java.util.concurrent.ExecutorService;

import org.osgi.framework.BundleContext;
import org.osgi.framework.ServiceReference;
import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Deactivate;
import org.osgi.service.component.annotations.Reference;
import org.osgi.util.tracker.ServiceTracker;
import org.osgi.util.tracker.ServiceTrackerCustomizer;

/**
 * @author Allen Ziegenfus
 */
@Component(service = {})
public class ScopeFinderReconcileTrigger {

	@Activate
	protected void activate(BundleContext bundleContext) {
		_executorService = _portalExecutorManager.getPortalExecutor(
			ScopeFinderReconcileTrigger.class.getName());

		_scopeFinderServiceTracker = new ServiceTracker<>(
			bundleContext, ScopeFinder.class,
			new ScopeFinderServiceTrackerCustomizer(bundleContext));

		_scopeFinderServiceTracker.open();
	}

	@Deactivate
	protected void deactivate() {
		if (_scopeFinderServiceTracker != null) {
			_scopeFinderServiceTracker.close();
		}
	}

	private void _requestReconcile() {
		if (_unresolvedScopeAliasesRegistry.getOAuth2ApplicationIds(
			).isEmpty()) {

			return;
		}

		_executorService.submit(
			() -> {
				try {
					_unresolvedScopeAliasReconciler.reconcile();
				}
				catch (Exception exception) {
					if (_log.isDebugEnabled()) {
						_log.debug(
							"Unable to reconcile unresolved scope aliases",
							exception);
					}
				}
			});
	}

	private static final Log _log = LogFactoryUtil.getLog(
		ScopeFinderReconcileTrigger.class);

	private ExecutorService _executorService;

	@Reference(target = ModuleServiceLifecycle.PORTAL_INITIALIZED)
	private ModuleServiceLifecycle _moduleServiceLifecycle;

	@Reference
	private PortalExecutorManager _portalExecutorManager;

	private ServiceTracker<ScopeFinder, ScopeFinder> _scopeFinderServiceTracker;

	@Reference
	private UnresolvedScopeAliasesRegistry _unresolvedScopeAliasesRegistry;

	@Reference
	private UnresolvedScopeAliasReconciler _unresolvedScopeAliasReconciler;

	private class ScopeFinderServiceTrackerCustomizer
		implements ServiceTrackerCustomizer<ScopeFinder, ScopeFinder> {

		@Override
		public ScopeFinder addingService(
			ServiceReference<ScopeFinder> serviceReference) {

			_requestReconcile();

			return _bundleContext.getService(serviceReference);
		}

		@Override
		public void modifiedService(
			ServiceReference<ScopeFinder> serviceReference,
			ScopeFinder scopeFinder) {
		}

		@Override
		public void removedService(
			ServiceReference<ScopeFinder> serviceReference,
			ScopeFinder scopeFinder) {

			_bundleContext.ungetService(serviceReference);
		}

		private ScopeFinderServiceTrackerCustomizer(
			BundleContext bundleContext) {

			_bundleContext = bundleContext;
		}

		private final BundleContext _bundleContext;

	}

}