'use strict';

const config = require('../config.json');
const fs = require('fs');
const log = require('./log');
const path = require('path');

function getExtInitMetadata(property, defaultValue) {
	const configPath = path.join(
		'/etc/liferay/lxc/ext-init-metadata',
		property
	);
	let extInitMetadata;
	if (fs.existsSync(configPath)) {
		extInitMetadata = fs.readFileSync(configPath, 'utf-8');
	}
	else {
		extInitMetadata = defaultValue;
	}
	return extInitMetadata;
}

function getDXPMetadata(property) {
	const configPath = path.join('/etc/liferay/lxc/dxp-metadata', property);
	let dxpMetadata;
	if (fs.existsSync(configPath)) {
		dxpMetadata = fs.readFileSync(configPath, 'utf-8');
	}
	else {
		dxpMetadata = config[property];
	}
	log.info('getDXPMetadata: ' + property + ' = ' + dxpMetadata);
	return dxpMetadata;
}

module.exports = {
	getDXPMetadata,
	getExtInitMetadata,
};
