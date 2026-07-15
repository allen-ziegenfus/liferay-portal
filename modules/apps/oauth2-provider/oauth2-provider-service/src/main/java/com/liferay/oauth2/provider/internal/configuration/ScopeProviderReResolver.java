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
 * dropped and never revisited.
 * </p>
 *
 * <p>
 * A greedy {@code Collection<Application>} reference on the configuration
 * factories used to cover this by re-activating them on every new application,
 * but it was removed in LPD-70721 for causing churn, and LPD-81792 replaced it
 * with a one-time startup deferral that does not cover late runtime
 * registration. This component is the targeted replacement: it watches
 * application registrations and, debounced, re-runs the (idempotent) scope
 * resolution for the active configurations - re-attaching a dropped alias the
 * moment its provider appears, without re-activating anything.
 * </p>
 *
 * <p>
 * Cluster note: this runs per node, mirroring the existing activation-time
 * {@code updateScopes}. Each node triggers on its own local application
 * registrations and writes to the shared, clustered-cache-backed grant tables,
 * so the result converges cluster-wide and {@code updateScopes} is idempotent.
 * Gating the pass to the cluster master would reduce redundant writes but is
 * arguably a separate improvement that should also cover the activation path.
 * </p>
 *
 * @author Allen Ziegenfus
 */
@Component(service = ScopeProviderReResolver.class)
public class ScopeProviderReResolver {

	public void register(BaseConfigurationFactory baseConfigurationFactory) {
		_baseConfigurationFactories.add(baseConfigurationFactory);

		// A configuration that activates after providers are already up may
		// itself be missing scopes. Re-resolve it against the current set.

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

	// A JAX-RS application - the service type a published custom Object or
	// DataSet registers to expose its REST endpoints and OAuth2 scopes - has
	// come or gone. This is the exact signal the greedy Collection<Application>
	// reference used before LPD-70721 removed it; here it only schedules a
	// debounced, targeted re-resolution rather than re-activating components.

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

			// updateScopes is idempotent (LPD-23697): a no-op unless a newly
			// registered application makes a previously-dropped alias
			// resolvable.

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
