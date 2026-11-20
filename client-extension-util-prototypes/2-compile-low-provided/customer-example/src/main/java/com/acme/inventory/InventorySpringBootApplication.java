/**
 * SPDX-FileCopyrightText: (c) 2026 Acme, Inc.
 * SPDX-License-Identifier: Apache-2.0
 */

package com.acme.inventory;

import com.liferay.client.extension.util.spring.boot3.ClientExtensionUtilSpringBootComponentScan;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Import;

/**
 * UNCHANGED, and that is the entire consumer-facing story of Option 2.
 *
 * <p>
 * The <code>@Import</code> is still here. The package is still
 * <code>...util.spring.boot3</code>. Nothing in this file, and nothing in any
 * of the other 25 in-repo consumers, has to move.
 * </p>
 *
 * <p>
 * Compare Option 1, where this line is deleted, and Option 4, where the whole
 * file has no Liferay import at all. Option 2 buys forward compatibility and
 * removes the CVE treadmill without asking anyone to migrate anything, which is
 * exactly why it should ship first and on its own.
 * </p>
 */
@Import(ClientExtensionUtilSpringBootComponentScan.class)
@SpringBootApplication
public class InventorySpringBootApplication {

	public static void main(String[] args) {
		SpringApplication.run(InventorySpringBootApplication.class, args);
	}

}
