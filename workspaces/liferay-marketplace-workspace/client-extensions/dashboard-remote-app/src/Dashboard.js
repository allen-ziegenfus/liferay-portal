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

import './Dashboard.css';
import {useState} from 'react';
import useProducts from './hooks/useProducts';

function Dashboard(props) {
	const [languageId] = useState(Liferay.ThemeDisplay.getLanguageId());

	const {data, isFetching, status} = useProducts(languageId);

	return (
		<div>
			<h1>Dashboard</h1>
			{status == 'success' &&
				data &&
				data.items &&
				data.items.map((product) => (
					<div key={product.id}>{product.name[languageId]}</div>
				))}
		</div>
	);
}

export default Dashboard;
