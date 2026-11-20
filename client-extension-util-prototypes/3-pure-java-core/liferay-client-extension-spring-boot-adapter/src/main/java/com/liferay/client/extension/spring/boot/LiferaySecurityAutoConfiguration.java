/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot;

import com.liferay.client.extension.core.LiferayDXPConnection;
import com.liferay.client.extension.core.LiferayProperties;

import java.util.List;

import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.autoconfigure.condition.ConditionalOnWebApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * The web-facing half of the adapter, and the clearest illustration of where
 * the core/adapter line actually falls.
 *
 * <p>
 * Neither of these beans can live in a Spring-free core, because <em>the bean
 * is a Spring type</em>. A <code>SecurityFilterChain</code> is not a fact about
 * Liferay that happens to be expressed in Spring; it <em>is</em> Spring. Same
 * for <code>WebMvcConfigurer</code>. There is nothing to extract.
 * </p>
 *
 * <p>
 * What the core does supply is the part that is a fact about Liferay:
 * <code>LiferayDXPConnection.getCorsAllowedOrigins()</code> knows that the
 * allowed origins are the <code>com.liferay.lxc.dxp.domains</code> list crossed
 * with http and https. The <em>policy</em> is core knowledge; the
 * <em>mechanism</em> is adapter code. That division is the whole design, and
 * this file is where it is easiest to see.
 * </p>
 *
 * <p>
 * Without this class, a consumer does not simply lose CORS. Declaring a
 * <code>JwtDecoder</code> bean and nothing else leaves Spring Boot's
 * <code>OAuth2ResourceServerJwtConfiguration</code> to supply a default chain,
 * which authenticates every request but leaves CSRF enabled and sessions
 * creatable. For a stateless bearer-token API that means POST, PUT and DELETE
 * start returning 403. The filter chain is not optional garnish; it is load
 * bearing, and it has to be somewhere.
 * </p>
 */
@AutoConfiguration
@ConditionalOnClass(HttpSecurity.class)
@EnableWebSecurity
public class LiferaySecurityAutoConfiguration {

	@Bean
	@ConditionalOnMissingBean
	@ConditionalOnProperty(
		name = "liferay.client.extension.cors.enabled", matchIfMissing = true
	)
	@ConditionalOnWebApplication(type = ConditionalOnWebApplication.Type.SERVLET)
	@Order(Ordered.LOWEST_PRECEDENCE)
	public WebMvcConfigurer liferayCorsWebMvcConfigurer(
		LiferayDXPConnection liferayDXPConnection) {

		List<String> corsAllowedOrigins =
			liferayDXPConnection.getCorsAllowedOrigins();

		return new WebMvcConfigurer() {

			@Override
			public void addCorsMappings(CorsRegistry corsRegistry) {
				corsRegistry.addMapping(
					"/**"
				).allowedHeaders(
					"Authorization", "Content-Type"
				).allowedMethods(
					"DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"
				).allowedOrigins(
					corsAllowedOrigins.toArray(new String[0])
				);
			}

		};
	}

	/**
	 * Written in the lambda DSL, so the same source compiles on Spring
	 * Security 5.8, 6.x and 7.x. This is the method that does not survive
	 * Spring Boot 4 today.
	 */
	@Bean
	@ConditionalOnMissingBean
	@ConditionalOnProperty(
		name = "liferay.client.extension.oauth2.resource-server.enabled",
		matchIfMissing = true
	)
	public SecurityFilterChain liferaySecurityFilterChain(
			HttpSecurity httpSecurity, LiferayProperties liferayProperties)
		throws Exception {

		List<String> permitAllPatterns = liferayProperties.getList(
			"liferay.oauth.urls.excludes");

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
				permitAllPatterns.toArray(new String[0])
			).permitAll(
			).anyRequest(
			).authenticated()
		).oauth2ResourceServer(
			configurer -> configurer.jwt(Customizer.withDefaults())
		).build();
	}

}
