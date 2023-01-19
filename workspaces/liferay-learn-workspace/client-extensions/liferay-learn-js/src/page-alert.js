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

const ALERT_ELEMENT_ID = 'pageAlert';

const ALERT_ELEMENT_HEIGHT = 56;

const ALERT_LOCAL_STORAGE_ID = 'pageAlertState';

function displayPageAlert(node) {
	if (window.scrollY <= ALERT_ELEMENT_HEIGHT) {
		node.classList.remove('d-none');
	}

	if (
		window.scrollY > ALERT_ELEMENT_HEIGHT &&
		!node.classList.contains('d-none')
	) {
		node.classList.add('d-none');
	}
}

function initPageAlert() {
	const pageAlertState = localStorage.getItem(ALERT_LOCAL_STORAGE_ID);

	if (pageAlertState !== 'closed') {
		const pageAlertElement = document.getElementById(ALERT_ELEMENT_ID);

		if (pageAlertElement) {
			pageAlertElement.classList.remove('page-alert-hidden');

			document.body.classList.add('page-alert-open');

			const pageAlertContainer = pageAlertElement.parentNode;

			if (pageAlertContainer) {
				window.addEventListener('scroll', () =>
					displayPageAlert(pageAlertContainer)
				);
			}
		}

		const alertCloseElement = document.querySelector(
			'#pageAlertContainer .close'
		);
		if (alertCloseElement) {
			alertCloseElement.addEventListener('click', () => {
				localStorage.setItem(ALERT_LOCAL_STORAGE_ID, 'closed');
			});
		}
	}
}

// Initialize after DOM is ready

document.addEventListener('DOMContentLoaded', initPageAlert);
Liferay.on('endNavigate', initPageAlert);
