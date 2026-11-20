/**
 * SPDX-FileCopyrightText: (c) 2026 Acme, Inc.
 * SPDX-License-Identifier: Apache-2.0
 */

package com.acme.inventory;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * BEFORE
 *
 * <pre>
 * &#64;Import(ClientExtensionUtilSpringBootComponentScan.class)
 * &#64;SpringBootApplication
 * public class InventorySpringBootApplication {
 * </pre>
 *
 * AFTER: the &#64;Import is gone. The library is discovered from the classpath
 * like every other Spring Boot integration, and each of its four pieces can be
 * switched off individually in application.properties.
 *
 * This one deletion applies to all 26 in-repo consumers.
 */
@SpringBootApplication
public class InventorySpringBootApplication {

	public static void main(String[] args) {
		SpringApplication.run(InventorySpringBootApplication.class, args);
	}

}
