import React from 'react';
import ReactDOM from 'react-dom';

import type {FDSCellRenderer} from '@liferay/js-api/data-set';

const fdsCellRenderer: FDSCellRenderer = ({value}) => {
	const element = document.createElement('div');

	ReactDOM.render(<>{value === 'Green' ? '🍏' : value}</>, element);

	return element;
};

export default fdsCellRenderer;
