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

import {useState} from 'react';
import ClayLoadingIndicator from '@clayui/loading-indicator';

import Pagination from './Pagination';
import TableBody from './TableBody';
import TableHead from './TableHead';
import useProducts from '../hooks/useProducts';

const Table = () => {
	const columns = [
		{label: 'Name', accessor: 'name'},
		{label: 'Version', accessor: 'version'},
		{label: 'Last Updated', accessor: 'modifiedDate'},
		{label: 'Status', accessor: 'productStatus'},
	];

	const publisherName = 'Acme Co';
	const [languageId] = useState(Liferay.ThemeDisplay.getLanguageId());
	const [page, setPage] = useState(1);
	const [delta, setDelta] = useState(10);
	const [sort, setSort] = useState('');
	const [order, setOrder] = useState(true);

	const {data, refetch, status} = useProducts(languageId, page, delta, sort);

	function handleSortClick(event) {
		const sortCategory = event.target.dataset.category;

		if (sortCategory === 'name' || sortCategory === 'modifiedDate') {
			if (sort.includes(sortCategory)) {
				const currentOrder = order ? ':asc' : ':desc';

				setSort(sortCategory + currentOrder);
				setOrder(!order);
			} else {
				setSort(sortCategory + ':asc');
				setOrder(true);
			}

			refetch();
		}
	}

	if (status === 'success' && data.totalCount === 0) {
		return (
			<div className="align-items-center d-flex flex-column justify-items-center no-apps">
				<svg
					width="144"
					height="80"
					viewBox="0 0 144 80"
					fill="none"
					xmlns="http://www.w3.org/2000/svg"
				>
					<rect width="144" height="80" rx="8" fill="#EDF3FE" />
					<path
						opacity="0.2"
						d="M86 44H76V54H86V44Z"
						fill="#0B5FFF"
					/>
					<path
						d="M86 44H76V54H86V44Z"
						stroke="#004AD7"
						stroke-width="3"
						stroke-linecap="round"
						stroke-linejoin="round"
					/>
					<path
						opacity="0.2"
						d="M68 44H58V54H68V44Z"
						fill="#0B5FFF"
					/>
					<path
						d="M68 44H58V54H68V44Z"
						stroke="#004AD7"
						stroke-width="3"
						stroke-linecap="round"
						stroke-linejoin="round"
					/>
					<path
						opacity="0.2"
						d="M86 26H76V36H86V26Z"
						fill="#0B5FFF"
					/>
					<path
						d="M86 26H76V36H86V26Z"
						stroke="#004AD7"
						stroke-width="3"
						stroke-linecap="round"
						stroke-linejoin="round"
					/>
					<path
						opacity="0.2"
						d="M68 26H58V36H68V26Z"
						fill="#0B5FFF"
					/>
					<path
						d="M68 26H58V36H68V26Z"
						stroke="#004AD7"
						stroke-width="3"
						stroke-linecap="round"
						stroke-linejoin="round"
					/>
				</svg>

				<h4 className="font-weight-bold">No apps yet</h4>

				<div>
					Create new apps and they will show up here. Click on "New
					App" to start creating apps
				</div>
			</div>
		);
	}

	if (status === 'success' && data.totalCount !== 0) {
		return (
			<>
				<table className="table">
					<TableHead columns={columns} handleSortClick={handleSortClick} order={order} sort={sort}/>
					<TableBody
						columns={columns}
						data={data}
						languageId={languageId}
						status={status}
					/>
				</table>

				<Pagination
					delta={delta}
					page={page}
					setDelta={setDelta}
					setPage={setPage}
					totalCount={data.totalCount}
				/>
			</>
		);
	}

	return (
		<div className="align-items-center d-flex flex-column justify-items-center">
			<ClayLoadingIndicator displayType="primary" shape="squares" size="lg" />

			<div>
				Hang tight, we are preparing your arrival as publisher and
				member of{' '}
				<span className="font-weight-bold">{publisherName}</span>
			</div>
		</div>
	);
};

export default Table;
