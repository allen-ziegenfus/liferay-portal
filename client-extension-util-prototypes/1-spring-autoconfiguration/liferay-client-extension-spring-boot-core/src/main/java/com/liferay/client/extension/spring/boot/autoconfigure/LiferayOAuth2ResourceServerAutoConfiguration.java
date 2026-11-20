/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.spring.boot.autoconfigure;

import com.liferay.client.extension.spring.boot.LiferayClientExtensionProperties;
import com.liferay.client.extension.spring.boot.LiferayDXPProperties;
import com.liferay.client.extension.spring.boot.client.LiferayOAuth2ApplicationResolver;

import com.nimbusds.jose.JOSEObjectType;
import com.nimbusds.jose.proc.DefaultJOSEObjectTypeVerifier;
import com.nimbusds.jose.proc.JWSAlgorithmFamilyJWSKeySelector;
import com.nimbusds.jose.proc.SecurityContext;
import com.nimbusds.jwt.proc.DefaultJWTProcessor;

import java.net.URI;
import java.net.URL;

import java.util.List;

import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Validates the JWTs Liferay issues for this client extension.
 *
 * <p>
 * Two substantive changes from
 * <code>LiferayOAuth2ResourceServerEnableWebSecurity</code>:
 * </p>
 *
 * <ol>
 * <li>The filter chain is written in the lambda DSL. The old chain used the
 * <code>cors().and().csrf().disable()</code> form, which was deprecated in
 * Spring Security 6.1 and removed in 7. That single method was the whole
 * Spring Boot 4 blast radius of the library.</li>
 * <li>Both the decoder and the chain are <code>@ConditionalOnMissingBean</code>,
 * so a client extension with unusual authorization rules can declare its own
 * <code>SecurityFilterChain</code> and still keep the Liferay JWT decoder,
 * rather than having to abandon the library wholesale.</li>
 * </ol>
 */
@AutoConfiguration
@ConditionalOnClass({HttpSecurity.class, JwtDecoder.class})
@ConditionalOnProperty(
	name = "liferay.client.extension.oauth2.resource-server.enabled",
	matchIfMissing = true
)
@EnableConfigurationProperties(
	{LiferayClientExtensionProperties.class, LiferayDXPProperties.class}
)
@EnableWebSecurity
public class LiferayOAuth2ResourceServerAutoConfiguration {

	@Bean
	@ConditionalOnMissingBean
	public JwtDecoder jwtDecoder(
			LiferayClientExtensionProperties liferayClientExtensionProperties,
			LiferayDXPProperties liferayDXPProperties,
			LiferayOAuth2ApplicationResolver liferayOAuth2ApplicationResolver)
		throws Exception {

		URI baseURI = liferayDXPProperties.getBaseURI();

		URL jwkSetURL = baseURI.resolve("/o/oauth2/jwks").toURL();

		DefaultJWTProcessor<SecurityContext> defaultJWTProcessor =
			new DefaultJWTProcessor<>();

		defaultJWTProcessor.setJWSKeySelector(
			JWSAlgorithmFamilyJWSKeySelector.fromJWKSetURL(jwkSetURL));
		defaultJWTProcessor.setJWSTypeVerifier(
			new DefaultJOSEObjectTypeVerifier<>(new JOSEObjectType("at+jwt")));

		NimbusJwtDecoder nimbusJwtDecoder = new NimbusJwtDecoder(
			defaultJWTProcessor);

		nimbusJwtDecoder.setJwtValidator(
			new LiferayClientIdOAuth2TokenValidator(
				liferayClientExtensionProperties.getExternalReferenceCodes(),
				liferayOAuth2ApplicationResolver));

		return nimbusJwtDecoder;
	}

	@Bean
	@ConditionalOnMissingBean
	public SecurityFilterChain liferaySecurityFilterChain(
			HttpSecurity httpSecurity,
			LiferayClientExtensionProperties liferayClientExtensionProperties)
		throws Exception {

		List<String> permitAllPatterns =
			liferayClientExtensionProperties.getOAuth2(
			).getResourceServer(
			).getPermitAllPatterns();

		return httpSecurity.cors(
			Customizer.withDefaults()
		).csrf(
			csrfConfigurer -> csrfConfigurer.disable()
		).sessionManagement(
			sessionManagementConfigurer ->
				sessionManagementConfigurer.sessionCreationPolicy(
					SessionCreationPolicy.STATELESS)
		).authorizeHttpRequests(
			authorizationManagerRequestMatcherRegistry ->
				authorizationManagerRequestMatcherRegistry.requestMatchers(
					permitAllPatterns.toArray(new String[0])
				).permitAll(
				).anyRequest(
				).authenticated()
		).oauth2ResourceServer(
			oAuth2ResourceServerConfigurer ->
				oAuth2ResourceServerConfigurer.jwt(Customizer.withDefaults())
		).build();
	}

}
