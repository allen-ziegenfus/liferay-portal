/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.sample;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

/**
 * THE SECOND COST OF OPTION 4.
 *
 * <p>
 * The option ships no <code>SecurityFilterChain</code>, so Boot's default
 * resource-server chain applies. That chain authenticates every request, but it
 * leaves CSRF enabled and sessions creatable. This endpoint is a stateless POST
 * carrying a bearer token, so under the default chain it would start returning
 * 403.
 * </p>
 *
 * <p>
 * So the consumer writes this. It is twenty lines, it is the same twenty lines
 * in every client extension, and getting it subtly wrong is a security bug
 * rather than a compile error - which is the strongest argument for keeping it
 * in a library rather than in a template.
 * </p>
 *
 * <p>
 * Worth weighing against the option's headline: the maintained library drops to
 * roughly fifty lines, but the code does not vanish. It moves across the
 * support boundary to the customer.
 * </p>
 */
@Configuration
public class SampleSecurityConfiguration {

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity)
		throws Exception {

		return httpSecurity.cors(
			Customizer.withDefaults()
		).csrf(
			csrfConfigurer -> csrfConfigurer.disable()
		).sessionManagement(
			sessionManagementConfigurer ->
				sessionManagementConfigurer.sessionCreationPolicy(
					SessionCreationPolicy.STATELESS)
		).authorizeHttpRequests(
			registry -> registry.requestMatchers(
				"/ready"
			).permitAll(
			).anyRequest(
			).authenticated()
		).oauth2ResourceServer(
			configurer -> configurer.jwt(Customizer.withDefaults())
		).build();
	}

}
