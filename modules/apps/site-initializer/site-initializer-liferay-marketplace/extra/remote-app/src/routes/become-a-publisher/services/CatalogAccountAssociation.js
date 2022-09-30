/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

 import {LiferayAdapt} from '../../../common/services/liferay/adapter';

import {axios} from '../../../common/services/liferay/api';

/**
 * @returns {Promise<AccountCatalogLookup>)} AccountCatalogLookup
 */
export async function getAccountCatalogLookup() {
	let allPagesFetched = false;
	let page = 1;

	const allCatalogAccounts = [];

	while (!allPagesFetched) {
		const catalogAccounts = await axios.get(
			`/o/c/catalogaccounts/?page=${page}`
		);

		allCatalogAccounts.push(...catalogAccounts?.data?.items);

		if (page === catalogAccounts?.data?.lastPage) {
			allPagesFetched = true;
		}
		page++;
	}


	return LiferayAdapt.adaptToAccountCatalogLookup(allCatalogAccounts);
}
