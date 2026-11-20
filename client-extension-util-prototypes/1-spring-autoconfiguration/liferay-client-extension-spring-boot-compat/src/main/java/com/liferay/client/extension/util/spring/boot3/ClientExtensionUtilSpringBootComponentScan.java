/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.util.spring.boot3;

import org.springframework.context.annotation.Configuration;

/**
 * A deliberate no-op, kept so that the 25 existing
 * <code>@Import(ClientExtensionUtilSpringBootComponentScan.class)</code>
 * declarations still compile.
 *
 * <p>
 * The auto-configurations in <code>-core</code> have already registered
 * everything this class used to component-scan for, and each of those beans is
 * <code>@ConditionalOnMissingBean</code>, so importing this contributes nothing
 * and conflicts with nothing. A consumer deletes the <code>@Import</code> when
 * convenient rather than when forced.
 * </p>
 *
 * <p>
 * This is the cheapest kind of compatibility there is: an empty class. It is
 * worth noticing that the original was also an empty class - it existed only to
 * anchor an <code>@ComponentScan</code> - which is why removing its behavior
 * costs nothing to remove.
 * </p>
 *
 * @deprecated As of 2.0.0, the library is discovered from the classpath through
 *             <code>AutoConfiguration.imports</code>. Delete the
 *             <code>@Import</code>; nothing replaces it.
 */
@Configuration
@Deprecated
public class ClientExtensionUtilSpringBootComponentScan {
}
