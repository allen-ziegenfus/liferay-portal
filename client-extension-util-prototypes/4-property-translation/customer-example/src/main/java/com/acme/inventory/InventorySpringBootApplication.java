/**
 * SPDX-FileCopyrightText: (c) 2026 Acme, Inc.
 * SPDX-License-Identifier: Apache-2.0
 */

package com.acme.inventory;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * There is nothing Liferay in this file, and that is the deliverable.
 *
 * No &#64;Import, no component scan marker, no base class, no library type in
 * any signature. The jar is on the classpath and it set some properties.
 */
@SpringBootApplication
public class InventorySpringBootApplication {

	public static void main(String[] args) {
		SpringApplication.run(InventorySpringBootApplication.class, args);
	}

}
