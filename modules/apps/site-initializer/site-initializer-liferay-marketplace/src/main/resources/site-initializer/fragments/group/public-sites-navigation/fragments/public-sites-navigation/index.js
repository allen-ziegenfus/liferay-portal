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

var menuButtonGroup = fragmentElement.querySelector('.menu-button-group');

var tabletMobileNavSection = fragmentElement.querySelector(
	'.tablet-mobile-nav-section'
);

var menuBtn = fragmentElement.querySelector('.menu-btn');

var closeBtn = fragmentElement.querySelector('.close-btn');

var accountMenus = fragmentElement.querySelectorAll('.account');

menuBtn.addEventListener('click', function () {
	menuButtonGroup.classList.toggle('menu-open');
	tabletMobileNavSection.classList.toggle('menu-open');
});

closeBtn.addEventListener('click', function () {
	menuButtonGroup.classList.toggle('menu-open');
	tabletMobileNavSection.classList.toggle('menu-open');
});

accountMenus.forEach(function (accountMenu) {
	accountMenu.addEventListener('click', function () {
		accountMenu.classList.toggle('menu-open');
	});
});