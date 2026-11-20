/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.util.spring.boot3.client;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.oauth2.core.OAuth2AccessToken;

/**
 * The second most-referenced type in the library: 34 files inject it by this
 * exact name, usually as
 * <code>&#64;Autowired LiferayOAuth2AccessTokenManager</code>.
 *
 * <p>
 * Kept as a thin forwarder to the replacement bean, so those injection points
 * resolve unchanged. Still annotated <code>@Configuration</code> - not because
 * that was ever right, but because changing a bean's stereotype changes when it
 * is created and proxied, and a compatibility shim is the wrong place to take
 * that risk.
 * </p>
 *
 * @deprecated As of 2.0.0, replaced by
 *             {@link com.liferay.client.extension.spring.boot.client.LiferayOAuth2AccessTokenManager}.
 */
@Configuration
@Deprecated
public class LiferayOAuth2AccessTokenManager {

	public String getAuthorization(String externalReferenceCode) {
		return _delegate.getAuthorization(externalReferenceCode);
	}

	public OAuth2AccessToken getOAuth2AccessToken(
		String externalReferenceCode) {

		return _delegate.getOAuth2AccessToken(externalReferenceCode);
	}

	public String getTokenType(String externalReferenceCode) {
		OAuth2AccessToken oAuth2AccessToken = getOAuth2AccessToken(
			externalReferenceCode);

		if ((oAuth2AccessToken == null) ||
			(oAuth2AccessToken.getTokenType() == null)) {

			return null;
		}

		OAuth2AccessToken.TokenType tokenType =
			oAuth2AccessToken.getTokenType();

		return tokenType.getValue();
	}

	public String getTokenValue(String externalReferenceCode) {
		OAuth2AccessToken oAuth2AccessToken = getOAuth2AccessToken(
			externalReferenceCode);

		if (oAuth2AccessToken == null) {
			return null;
		}

		return oAuth2AccessToken.getTokenValue();
	}

	public void refresh(String externalReferenceCode) {
		_delegate.refresh(externalReferenceCode);
	}

	@Autowired
	private com.liferay.client.extension.spring.boot.client.
		LiferayOAuth2AccessTokenManager _delegate;

}
