/**
 * SPDX-FileCopyrightText: (c) 2000 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.oauth2.provider.internal.configuration;

import jakarta.ws.rs.core.Application;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Deactivate;
import org.osgi.service.component.annotations.Reference;
import org.osgi.service.component.annotations.ReferenceCardinality;
import org.osgi.service.component.annotations.ReferencePolicy;
import org.osgi.service.component.annotations.ReferencePolicyOption;

/**
 * LPP-64799: Re-resolves OAuth2 configuration scopes when a scope provider
 * registers <em>after</em> the configuration was applied.
 *
 * <p>
 * An OAuth2 configuration factory resolves its declared scope aliases against
 * the JAX-RS applications registered at activation time. A custom Object or
 * DataSet registers its REST application (and therefore its scopes) only when it
 * is published/deployed, which in the CX pipeline happens at runtime - after the
 * configuration has already applied. The unresolved aliases are then silently
 * dropped and never revisited. This component watches application registrations
 * and, debounced, asks the affected configurations to re-resolve.
 * </p>
 *
 * <p>
 * This deliberately avoids the problems of the old greedy reference that was
 * removed in LPD-70721:
 * </p>
 *
 * <ul>
 * <li>It tracks {@link Application} (registered once, stable), not
 * {@code ScopeFinder}. LPS-192126 showed ScopeFinder services are unregistered
 * and re-registered many times during JAX-RS application initialization, which
 * caused the configuration factories to re-activate dozens of times and create
 * redundant grants (and dropped a scope during one of the flickers).</li>
 * <li>The reference is {@code DYNAMIC}, so a bind/unbind never re-activates this
 * component; the bind method only schedules a debounced pass. Nothing runs on
 * the object-publish thread, so the {@code CompanyThreadLocal}
 * UnsupportedOperationException that motivated LPD-70721 cannot occur.</li>
 * <li>Only configurations with unresolved scopes register here, and each writes
 * to the database only when a previously missing scope has actually become
 * resolvable (see {@code BaseConfigurationFactory#reResolveScopes}).</li>
 * </ul>
 *
 * <p>
 * Cluster note: this runs per node, mirroring the existing activation-time
 * {@code updateScopes}. Each node reacts to its own local application
 * registrations and writes to the shared, clustered-cache-backed grant tables,
 * so the result converges cluster-wide.
 * </p>
 *
 * @author Allen Ziegenfus
 */
@Component(service = ScopeProviderReResolver.class)
public class ScopeProviderReResolver {

	public void register(BaseConfigurationFactory baseConfigurationFactory) {
		_baseConfigurationFactories.add(baseConfigurationFactory);

		// A configuration that registers after some providers are already up may
		// have missed them; give it a chance to reconcile against the current
		// set. Idempotent - a no-op unless a missing scope is now resolvable.

		_scheduleReResolve();
	}

	public void unregister(BaseConfigurationFactory baseConfigurationFactory) {
		_baseConfigurationFactories.remove(baseConfigurationFactory);
	}

	@Activate
	protected void activate() {
		_scheduledExecutorService = Executors.newSingleThreadScheduledExecutor(
			runnable -> {
				Thread thread = new Thread(
					runnable, ScopeProviderReResolver.class.getName());

				thread.setDaemon(true);

				return thread;
			});
	}

	@Reference(
		cardinality = ReferenceCardinality.MULTIPLE,
		policy = ReferencePolicy.DYNAMIC,
		policyOption = ReferencePolicyOption.GREEDY
	)
	protected void addApplication(Application application) {
		_scheduleReResolve();
	}

	@Deactivate
	protected void deactivate() {
		ScheduledExecutorService scheduledExecutorService =
			_scheduledExecutorService;

		if (scheduledExecutorService != null) {
			scheduledExecutorService.shutdownNow();
		}
	}

	protected void removeApplication(Application application) {
	}

	private void _reResolve() {
		for (BaseConfigurationFactory baseConfigurationFactory :
				_baseConfigurationFactories) {

			baseConfigurationFactory.reResolveScopes();
		}
	}

	private synchronized void _scheduleReResolve() {
		ScheduledExecutorService scheduledExecutorService =
			_scheduledExecutorService;

		if (scheduledExecutorService == null) {
			return;
		}

		ScheduledFuture<?> scheduledFuture = _scheduledFuture;

		if (scheduledFuture != null) {
			scheduledFuture.cancel(false);
		}

		// Debounce: applications register in bursts (startup, batch imports).
		// Coalesce them into a single re-resolution pass.

		_scheduledFuture = scheduledExecutorService.schedule(
			this::_reResolve, _DEBOUNCE_DELAY, TimeUnit.MILLISECONDS);
	}

	private static final long _DEBOUNCE_DELAY = 2000;

	private final Set<BaseConfigurationFactory> _baseConfigurationFactories =
		ConcurrentHashMap.newKeySet();
	private volatile ScheduledExecutorService _scheduledExecutorService;
	private volatile ScheduledFuture<?> _scheduledFuture;

}
