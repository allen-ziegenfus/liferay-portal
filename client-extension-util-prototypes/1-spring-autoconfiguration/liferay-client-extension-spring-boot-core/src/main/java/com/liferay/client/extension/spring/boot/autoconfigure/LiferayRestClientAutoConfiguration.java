/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot.autoconfigure;

import com.liferay.client.extension.spring.boot.LiferayDXPProperties;
import com.liferay.client.extension.spring.boot.web.LiferayRestClient;
import com.liferay.client.extension.spring.boot.web.LiferayWebClient;

import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.client.RestClient;
import org.springframework.web.reactive.function.client.WebClient;

/**
 * Registers one HTTP client bean pointed at the bound DXP instance.
 *
 * <p>
 * <code>@ConditionalOnMissingBean</code> is what makes this un-opinionated: a
 * consumer who wants a different timeout, a different connection pool or a
 * tracing interceptor declares their own <code>LiferayRestClient</code> bean
 * and this one silently steps aside. Under the previous
 * <code>@ComponentScan</code> design there was no way to substitute anything,
 * which is why <code>LiferayOAuth2ClientConfiguration</code> accumulated
 * <code>@Autowired(required = false) @Qualifier("extra")</code> escape
 * hatches.
 * </p>
 */
@AutoConfiguration
@ConditionalOnProperty(
	name = "liferay.client.extension.rest-client.enabled",
	matchIfMissing = true
)
@EnableConfigurationProperties(LiferayDXPProperties.class)
public class LiferayRestClientAutoConfiguration {

	@Bean
	@ConditionalOnMissingBean
	public LiferayRestClient liferayRestClient(
		LiferayDXPProperties liferayDXPProperties,
		RestClient.Builder restClientBuilder) {

		RestClient restClient = restClientBuilder.defaultHeader(
			HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE
		).build();

		return new LiferayRestClient(
			restClient, liferayDXPProperties.getBaseURI());
	}

	/**
	 * Only registered when the consumer actually put webflux on the
	 * classpath. An MVC-only client extension never sees Reactor.
	 */
	@AutoConfiguration
	@ConditionalOnClass(WebClient.class)
	@ConditionalOnProperty(
		name = "liferay.client.extension.web-client.enabled",
		matchIfMissing = true
	)
	public static class Reactive {

		@Bean
		@ConditionalOnMissingBean
		public LiferayWebClient liferayWebClient(
			LiferayDXPProperties liferayDXPProperties,
			WebClient.Builder webClientBuilder) {

			return new LiferayWebClient(
				webClientBuilder.build(), liferayDXPProperties.getBaseURI());
		}

	}

}
