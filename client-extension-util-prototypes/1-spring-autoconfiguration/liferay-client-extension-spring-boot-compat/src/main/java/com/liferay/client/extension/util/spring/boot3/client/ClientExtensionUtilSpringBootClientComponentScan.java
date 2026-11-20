/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.util.spring.boot3.client;

import org.springframework.context.annotation.Configuration;

/**
 * The same no-op as
 * {@link com.liferay.client.extension.util.spring.boot3.ClientExtensionUtilSpringBootComponentScan},
 * for the 7 consumers that import the client variant.
 *
 * @deprecated As of 2.0.0. Delete the <code>@Import</code>; nothing replaces it.
 */
@Configuration
@Deprecated
public class ClientExtensionUtilSpringBootClientComponentScan {
}
