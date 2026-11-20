/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.client.extension.core;

import java.util.List;
import java.util.Map;
import java.util.function.Function;

/**
 * The single seam between this library and whatever is supplying configuration.
 *
 * <p>
 * Spring's <code>Environment</code> satisfies it as
 * <code>environment::getProperty</code>. So does
 * <code>System::getenv</code>, a <code>Properties</code> object, a Micronaut
 * <code>PropertyResolver</code>, or a <code>Map</code> in a unit test. Nothing
 * below this line knows which one it got.
 * </p>
 */
public interface LiferayProperties {

	public static LiferayProperties from(Function<String, String> function) {
		return function::apply;
	}

	public static LiferayProperties from(Map<String, String> map) {
		return map::get;
	}

	public String get(String name);

	public default String get(String name, String defaultValue) {
		String value = get(name);

		if ((value == null) || value.isBlank()) {
			return defaultValue;
		}

		return value;
	}

	public default List<String> getList(String name) {
		String value = get(name);

		if ((value == null) || value.isBlank()) {
			return List.of();
		}

		return List.of(value.split("\\s*[,\n]\\s*"));
	}

	public default String require(String name) {
		String value = get(name);

		if ((value == null) || value.isBlank()) {
			throw new IllegalStateException(
				"Property \"" + name + "\" is not defined");
		}

		return value;
	}

}
