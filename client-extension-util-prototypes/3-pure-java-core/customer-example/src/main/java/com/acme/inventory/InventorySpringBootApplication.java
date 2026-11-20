/**
 * SPDX-FileCopyrightText: (c) 2026 Acme, Inc.
 * SPDX-License-Identifier: Apache-2.0
 */

package com.acme.inventory;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Same as Option 1 from the consumer's side: no &#64;Import, no marker class,
 * no base class. The adapter is discovered from the classpath.
 *
 * The difference is invisible here and that is the point. Which framework
 * generation the adapter targets is the adapter's problem, not this file's.
 */
@SpringBootApplication
public class InventorySpringBootApplication {

	public static void main(String[] args) {
		SpringApplication.run(InventorySpringBootApplication.class, args);
	}

}
