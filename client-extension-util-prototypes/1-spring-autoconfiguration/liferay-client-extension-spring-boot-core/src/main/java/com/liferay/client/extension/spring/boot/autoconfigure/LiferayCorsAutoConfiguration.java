/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot.autoconfigure;

import com.liferay.client.extension.spring.boot.LiferayClientExtensionProperties;
import com.liferay.client.extension.spring.boot.LiferayDXPProperties;

import java.util.List;

import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.autoconfigure.condition.ConditionalOnWebApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * The same CORS policy the old <code>LiferayWebMvcConfigurer</code> applied,
 * with two changes: it can be switched off, and the allowed headers and
 * methods are properties rather than constants baked into the jar.
 *
 * <p>
 * The old class was imported unconditionally, so a client extension that
 * fronted its own gateway, or one that needed to allow an extra header, had to
 * fight the library rather than configure it.
 * </p>
 */
@AutoConfiguration
@ConditionalOnProperty(
	name = "liferay.client.extension.cors.enabled", matchIfMissing = true
)
@ConditionalOnWebApplication(type = ConditionalOnWebApplication.Type.SERVLET)
@EnableConfigurationProperties(
	{LiferayClientExtensionProperties.class, LiferayDXPProperties.class}
)
public class LiferayCorsAutoConfiguration {

	@Bean
	@Order(Ordered.LOWEST_PRECEDENCE)
	public WebMvcConfigurer liferayCorsWebMvcConfigurer(
		LiferayClientExtensionProperties liferayClientExtensionProperties,
		LiferayDXPProperties liferayDXPProperties) {

		LiferayClientExtensionProperties.Cors cors =
			liferayClientExtensionProperties.getCors();

		List<String> allowedOrigins =
			liferayDXPProperties.getCorsAllowedOrigins();

		return new WebMvcConfigurer() {

			@Override
			public void addCorsMappings(CorsRegistry corsRegistry) {
				corsRegistry.addMapping(
					cors.getPathPattern()
				).allowedHeaders(
					cors.getAllowedHeaders().toArray(new String[0])
				).allowedMethods(
					cors.getAllowedMethods().toArray(new String[0])
				).allowedOrigins(
					allowedOrigins.toArray(new String[0])
				);
			}

		};
	}

}
