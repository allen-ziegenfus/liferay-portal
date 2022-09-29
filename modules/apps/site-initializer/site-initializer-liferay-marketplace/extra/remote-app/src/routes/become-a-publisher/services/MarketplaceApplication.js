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
import {getGuestPermissionToken} from '../../../common/services/token';

const MarketplaceApplicationAPI = 'o/c/marketplaceapplications';

export function getMarketplaceApplicationById(marketplaceApplicationId) {
	return axios.get(`${MarketplaceApplicationAPI}/${marketplaceApplicationId}`);
}

/**
 * @param {DataForm}  form Basics form object
 * @returns {Promise<any>}  Status code
 */

const updateMarketplaceApplication = async (applicationId, payload = null) => {
	const {access_token} = await getGuestPermissionToken();

	sessionStorage.setItem('marketplace-guest-permission-token', access_token);

	return axios.patch(`${MarketplaceApplicationAPI}/${applicationId}`, payload, {
		headers: {
			'Authorization': `Bearer ${access_token}`,
			'Content-Type': 'application/json',
		},
	});
};

export function createOrUpdateMarketplaceApplication(form, status) {
	const payload = LiferayAdapt.adaptToFormApplicationRequest(form, status);
	const applicationId = form?.basics?.applicationId;

	if (applicationId) {
		return updateMarketplaceApplication(applicationId, payload);
	}

	return axios.post(`${MarketplaceApplicationAPI}/`, payload);
}

export function updateMarketplaceApplicationStatus(applicationId, status) {
	const payload = {
		applicationStatus: {
			key: status?.key,
			name: status?.name,
		},
	};

	return updateMarketplaceApplication(applicationId, payload);
}
