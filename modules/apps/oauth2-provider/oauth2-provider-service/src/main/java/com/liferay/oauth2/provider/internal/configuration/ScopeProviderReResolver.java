/**
 * SPDX-FileCopyrightText: (c) 2000 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.oauth2.provider.internal.configuration;

import com.liferay.petra.function.UnsafeRunnable;
import com.liferay.portal.kernel.scheduler.SchedulerJobConfiguration;
import com.liferay.portal.kernel.scheduler.TimeUnit;
import com.liferay.portal.kernel.scheduler.TriggerConfiguration;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.osgi.service.component.annotations.Component;

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
 * This is the <strong>timer-triggered</strong> variant of the reconcile: a
 * scheduled job periodically asks each configuration that still has unresolved
 * scopes to re-resolve. The reconcile itself
 * ({@code BaseConfigurationFactory#reResolveScopes}) is idempotent and
 * level-triggered - it writes only when a previously missing scope has become
 * resolvable - so the trigger is interchangeable with the event-driven variant,
 * and the two compose (event for latency, timer as a backstop) if both are
 * wanted.
 * </p>
 *
 * <p>
 * Trading the event trigger for a timer removes all of the machinery the
 * event-driven version needs: there is no {@code Application}/{@code ScopeFinder}
 * tracking (so none of the LPS-192126 re-registration churn), and the job runs
 * on the scheduler's own thread rather than the object-publish thread (so the
 * {@code CompanyThreadLocal} UnsupportedOperationException that motivated
 * LPD-70721 cannot occur - no hand-off executor is needed). The cost is
 * latency: a dropped scope is re-applied within one interval rather than
 * immediately.
 * </p>
 *
 * <p>
 * Cluster note: this runs per node, mirroring the existing activation-time
 * {@code updateScopes}. Each node writes to the shared, clustered-cache-backed
 * grant tables, so the result converges cluster-wide.
 * </p>
 *
 * @author Allen Ziegenfus
 */
@Component(
	service = {ScopeProviderReResolver.class, SchedulerJobConfiguration.class}
)
public class ScopeProviderReResolver implements SchedulerJobConfiguration {

	@Override
	public UnsafeRunnable<Exception> getJobExecutorUnsafeRunnable() {
		return () -> {
			for (BaseConfigurationFactory baseConfigurationFactory :
					_baseConfigurationFactories) {

				baseConfigurationFactory.reResolveScopes();
			}
		};
	}

	@Override
	public TriggerConfiguration getTriggerConfiguration() {
		return TriggerConfiguration.createTriggerConfiguration(
			1, TimeUnit.MINUTE);
	}

	public void register(BaseConfigurationFactory baseConfigurationFactory) {
		_baseConfigurationFactories.add(baseConfigurationFactory);
	}

	public void unregister(BaseConfigurationFactory baseConfigurationFactory) {
		_baseConfigurationFactories.remove(baseConfigurationFactory);
	}

	private final Set<BaseConfigurationFactory> _baseConfigurationFactories =
		ConcurrentHashMap.newKeySet();

}
