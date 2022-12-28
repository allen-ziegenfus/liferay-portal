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

const TableHead = ({columns, handleSortClick, order, sort}) => {
	return (
		<thead>
			<tr>
				{columns.map(({label, accessor}) => {
					if (sort.includes(accessor)) {
						if (order) {
							return <th className="column-name" data-category={accessor} key={accessor} onClick={handleSortClick}>{label} <svg class="lexicon-icon lexicon-icon-order-arrow-up" focusable="false" role="presentation"><use xlinkHref="/o/admin-theme/images/clay/icons.svg#order-arrow-up" /></svg></th>;
						} else {
							return <th className="column-name" data-category={accessor} key={accessor} onClick={handleSortClick}>{label} <svg class="lexicon-icon lexicon-icon-order-arrow-down" focusable="false" role="presentation"><use xlinkHref="/o/admin-theme/images/clay/icons.svg#order-arrow-down" /></svg></th>;
						}
					}

					return <th className="column-name" data-category={accessor} key={accessor} onClick={handleSortClick}>{label}</th>;
				})}
			</tr>
		</thead>
	);
};

export default TableHead;
