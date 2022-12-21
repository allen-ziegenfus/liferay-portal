import {ClayPaginationBarWithBasicItems} from '@clayui/pagination-bar';
import React from 'react';

import '../Dashboard.css';
import getIconSpriteMap from './getIconSpriteMap';

function Pagination(props) {
	var {delta, page, setDelta, setPage, totalCount} = props;

	return (
		<ClayPaginationBarWithBasicItems
			activeDelta={delta}
			activePage={page}
            deltas={[10, 25, 50].map((size) => ({
                label: size,
            }))}
			ellipsisBuffer={1}
			ellipsisProps={{'aria-label': 'More', 'title': 'More'}}
            onDeltaChange={setDelta}
			onPageChange={setPage}
			spritemap={getIconSpriteMap()}
			totalItems={totalCount}
		/>
	);
}

export default Pagination;
