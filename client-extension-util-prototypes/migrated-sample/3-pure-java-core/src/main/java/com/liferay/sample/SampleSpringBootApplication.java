/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.sample;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Identical to the Option 1 version.
 *
 * <p>
 * That is worth stating rather than hiding: at the consumer level, Options 1
 * and 3 are nearly indistinguishable. The core/adapter split is a maintenance
 * decision about who rewrites what when Spring Boot 5 ships, and it is
 * deliberately invisible from here.
 * </p>
 */
@SpringBootApplication
public class SampleSpringBootApplication {

	public static void main(String[] args) {
		SpringApplication.run(SampleSpringBootApplication.class, args);
	}

}
