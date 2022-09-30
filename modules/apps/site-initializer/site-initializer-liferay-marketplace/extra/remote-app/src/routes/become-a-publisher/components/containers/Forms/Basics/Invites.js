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

import classNames from 'classnames';
import React, {useContext} from 'react';

import {AppContext} from '../../../../context/AppContextProvider';
import {useAccountCatalogLookup} from '../../../../hooks/useAccountCatalogLookup';
import {useUserAccountAccountBriefs} from '../../../../hooks/useUserAccountAccountBriefs';

export function FormBasicInvites() {
	const {accountCatalogLookup} = useAccountCatalogLookup();
	const {userAccountAccountBriefs} = useUserAccountAccountBriefs();

	console.log(userAccountAccountBriefs);
	const {
		state: {
			dimensions: {
				device: {isMobile}
			}
		}
	} = useContext(AppContext);

	return (
		<div className="card-content d-flex">
			<div className="col-12 d-flex flex-wrap p-0">
				<div
					className={classNames('mb-4 d-flex col-12', {
						'd-flex justify-content-start': !isMobile,
						'justify-content-sm-center justify-content-center':
							isMobile
					})}
				>
					<label
						className={classNames('d-flex font-weight-bolder', {
							'text-paragraph justify-content-start': !isMobile,
							'text-paragraph-lg justify-content-sm-center justify-content-center':
								isMobile
						})}
					>
						We have found some invitations for you
					</label>
				</div>

				<div>
					{userAccountAccountBriefs &&
						accountCatalogLookup &&
						userAccountAccountBriefs.map((accountBrief) => (
							<h4 key={accountBrief.id}>
								{accountBrief.name} :

								{accountCatalogLookup[accountBrief.id]}{' '}
							</h4>
						))}
				</div>
			</div>
		</div>
	);
}
