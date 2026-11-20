/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.util.spring.boot3;

import com.liferay.client.extension.util.spring.boot3.service.BaseService;

import org.springframework.web.bind.annotation.RestController;

/**
 * Unchanged, at its original coordinates, because 104 files in this repo import
 * exactly this fully qualified name and an unknown number of customer projects
 * do too.
 *
 * <p>
 * An earlier draft of this prototype proposed deleting this class. That was
 * wrong on the numbers: it is the single most-referenced type in the library.
 * Deprecating it costs nothing and deleting it breaks every consumer at once.
 * </p>
 *
 * @deprecated As of 2.0.0, annotate the controller with
 *             <code>@RestController</code> directly and inject
 *             {@link com.liferay.client.extension.spring.boot.web.LiferayRestClient}
 *             instead of inheriting HTTP methods from a superclass.
 */
@Deprecated
@RestController
public abstract class BaseRestController extends BaseService {
}
