/**
 * SPDX-FileCopyrightText: (c) 2025 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.util.spring.boot3;

import com.liferay.client.extension.util.spring.boot3.client.LiferayOAuth2Util;

import com.nimbusds.jose.JOSEObjectType;
import com.nimbusds.jose.proc.DefaultJOSEObjectTypeVerifier;
import com.nimbusds.jose.proc.JWSAlgorithmFamilyJWSKeySelector;
import com.nimbusds.jose.proc.SecurityContext;
import com.nimbusds.jwt.proc.DefaultJWTProcessor;

import java.net.URL;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.oauth2.server.resource.OAuth2ResourceServerConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.core.DelegatingOAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.OAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2TokenValidatorResult;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.web.SecurityFilterChain;

/**
 * @author Raymond Augé
 * @author Gregory Amerson
 * @author Brian Wing Shun Chan
 * @author Allen Ziegenfus
 */
@Configuration
@EnableWebSecurity
public class LiferayOAuth2ResourceServerEnableWebSecurity {

	@Bean
	public JwtDecoder jwtDecoder() throws Exception {
		String liferayOauthApplicationExternalReferenceCodes =
			_environment.getProperty(
				"liferay.oauth.application.external.reference.codes");

		if (liferayOauthApplicationExternalReferenceCodes == null) {
			throw new IllegalArgumentException(
				"Property " +
					"\"liferay.oauth.application.external.reference.codes\" " +
						"is not defined");
		}

		DefaultJWTProcessor<SecurityContext> defaultJWTProcessor =
			new DefaultJWTProcessor<>();

		URL jwkSetURL = new URL(
			new StringBuilder(
			).append(
				_lxcDXPServerProtocol
			).append(
				"://"
			).append(
				_lxcDXPMainDomain
			).append(
				"/o/oauth2/jwks"
			).toString());

		if (_log.isDebugEnabled()) {
			_log.debug("Using " + jwkSetURL);
		}

		defaultJWTProcessor.setJWSKeySelector(
			JWSAlgorithmFamilyJWSKeySelector.fromJWKSetURL(jwkSetURL));

		defaultJWTProcessor.setJWSTypeVerifier(
			new DefaultJOSEObjectTypeVerifier<>(new JOSEObjectType("at+jwt")));

		NimbusJwtDecoder nimbusJwtDecoder = new NimbusJwtDecoder(
			defaultJWTProcessor);

		List<String> externalReferenceCodes = new ArrayList<>();

		for (String externalReferenceCode :
				liferayOauthApplicationExternalReferenceCodes.split(",")) {

			String clientId = _environment.getProperty(
				externalReferenceCode + ".oauth2.user.agent.client.id");

			if (_log.isInfoEnabled()) {
				String clientIdLogMessage = _getClientIdLogMessage(
					clientId, externalReferenceCode);

				if (clientIdLogMessage != null) {
					_log.info(clientIdLogMessage);
				}
			}

			externalReferenceCodes.add(externalReferenceCode);
		}

		nimbusJwtDecoder.setJwtValidator(
			new DelegatingOAuth2TokenValidator<>(
				new LiferayOAuth2TokenValidator(
					new LiferayOAuth2ClientIds(
						this::_getClientId, externalReferenceCodes))));

		return nimbusJwtDecoder;
	}

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity)
		throws Exception {

		return httpSecurity.cors(
		).and(
		).csrf(
		).disable(
		).sessionManagement(
		).sessionCreationPolicy(
			SessionCreationPolicy.STATELESS
		).and(
		).authorizeHttpRequests(
			customizer -> customizer.requestMatchers(
				_liferayOauthURLsExcludes
			).permitAll(
			).anyRequest(
			).authenticated()
		).oauth2ResourceServer(
			OAuth2ResourceServerConfigurer::jwt
		).build();
	}

	private String _getClientId(String externalReferenceCode) {
		String clientId = _environment.getProperty(
			externalReferenceCode + ".oauth2.user.agent.client.id");

		if (clientId != null) {
			return clientId;
		}

		clientId = _environment.getProperty(
			externalReferenceCode + ".oauth2.headless.server.client.id");

		if (clientId != null) {
			return clientId;
		}

		return LiferayOAuth2Util.getClientId(
			externalReferenceCode, _lxcDXPMainDomain, _lxcDXPServerProtocol);
	}

	private String _getClientIdLogMessage(
		String clientId, String externalReferenceCode) {

		if (clientId != null) {
			return new StringBuilder(
			).append(
				"Using user agent client ID "
			).append(
				clientId
			).append(
				" for external reference code "
			).append(
				externalReferenceCode
			).toString();
		}

		if (clientId != _environment.getProperty(
				externalReferenceCode + ".oauth2.headless.server.client.id")) {

			return null;
		}

		return "Unable to get user agent client ID for external reference " +
			"code " + externalReferenceCode;
	}

	private static final Log _log = LogFactory.getLog(
		LiferayOAuth2ResourceServerEnableWebSecurity.class);

	@Autowired
	private Environment _environment;

	@Value("${liferay.oauth.urls.excludes:}")
	private String[] _liferayOauthURLsExcludes;

	@Value("${com.liferay.lxc.dxp.domains}")
	private String _lxcDXPDomains;

	@Value("${com.liferay.lxc.dxp.mainDomain}")
	private String _lxcDXPMainDomain;

	@Value("${com.liferay.lxc.dxp.server.protocol}")
	private String _lxcDXPServerProtocol;

	private class LiferayOAuth2TokenValidator
		implements OAuth2TokenValidator<Jwt> {

		@Override
		public OAuth2TokenValidatorResult validate(Jwt jwt) {
			if (_hasListedExternalReferenceCode(jwt) ||
				_liferayOAuth2ClientIds.hasClientId(
					jwt.getClaimAsString("client_id"))) {

				return OAuth2TokenValidatorResult.success();
			}

			return OAuth2TokenValidatorResult.failure(_oAuth2Error);
		}

		private LiferayOAuth2TokenValidator(
			LiferayOAuth2ClientIds liferayOAuth2ClientIds) {

			_liferayOAuth2ClientIds = liferayOAuth2ClientIds;
		}

		private boolean _hasListedExternalReferenceCode(Jwt jwt) {
			if (!_liferayOAuth2ClientIds.hasExternalReferenceCode(
					jwt.getClaimAsString("external_reference_code"))) {

				return false;
			}

			for (String lxcDXPDomain : _lxcDXPDomains.split("\\s*[,\n]\\s*")) {
				if (lxcDXPDomain.equals(jwt.getClaimAsString("iss"))) {
					return true;
				}
			}

			return false;
		}

		private final LiferayOAuth2ClientIds _liferayOAuth2ClientIds;
		private final OAuth2Error _oAuth2Error = new OAuth2Error(
			"invalid_token", "The client_id does not match", null);

	}

}