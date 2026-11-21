/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.util.spring.boot3;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;

/**
 * Holds the external reference codes of the OAuth 2 applications whose tokens
 * are accepted, and caches their client IDs. A client ID is obtained from the
 * client ID function when it is first needed. When the function returns
 * <code>null</code>, nothing is cached, so the function is called again the
 * next time.
 *
 * @author Allen Ziegenfus
 */
public class LiferayOAuth2ClientIds {

	public LiferayOAuth2ClientIds(
		Function<String, String> clientIdFunction,
		List<String> externalReferenceCodes) {

		_clientIdFunction = clientIdFunction;
		_externalReferenceCodes = new ArrayList<>(externalReferenceCodes);
	}

	public boolean hasClientId(String clientId) {
		if (clientId == null) {
			return false;
		}

		if (_clientIds.containsValue(clientId)) {
			return true;
		}

		for (String externalReferenceCode : _externalReferenceCodes) {
			if (clientId.equals(_getClientId(externalReferenceCode))) {
				return true;
			}
		}

		return false;
	}

	public boolean hasExternalReferenceCode(String externalReferenceCode) {
		if (externalReferenceCode == null) {
			return false;
		}

		return _externalReferenceCodes.contains(externalReferenceCode);
	}

	private String _getClientId(String externalReferenceCode) {
		String clientId = _clientIds.get(externalReferenceCode);

		if (clientId != null) {
			return clientId;
		}

		clientId = _clientIdFunction.apply(externalReferenceCode);

		if (clientId != null) {
			_clientIds.put(externalReferenceCode, clientId);
		}

		return clientId;
	}

	private final Function<String, String> _clientIdFunction;
	private final Map<String, String> _clientIds = new ConcurrentHashMap<>();
	private final List<String> _externalReferenceCodes;

}