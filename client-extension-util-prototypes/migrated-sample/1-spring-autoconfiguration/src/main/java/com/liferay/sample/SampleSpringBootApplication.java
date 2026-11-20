/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.sample;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * One line deleted:
 *
 * <pre>
 * -import com.liferay.client.extension.util.spring.boot3.ClientExtensionUtilSpringBootComponentScan;
 * -&#64;Import(ClientExtensionUtilSpringBootComponentScan.class)
 * </pre>
 *
 * The same deletion applies to all 26 in-repo consumers.
 */
@SpringBootApplication
public class SampleSpringBootApplication {

	public static void main(String[] args) {
		SpringApplication.run(SampleSpringBootApplication.class, args);
	}

}
