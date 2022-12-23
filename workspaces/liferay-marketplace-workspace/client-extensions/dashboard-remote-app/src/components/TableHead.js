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
