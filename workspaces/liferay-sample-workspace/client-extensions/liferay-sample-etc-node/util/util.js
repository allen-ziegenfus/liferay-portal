'use strict';

const config = require('../config.json')
const fs = require('fs');
const path = require('path');

function getExtInitMetadata(property, defaultValue) {
	const configPath = path.join('/etc/liferay/lxc/ext-init-metadata', property);
	let extInitMetadata;
	if (fs.existsSync(configPath)) {
		extInitMetadata = fs.readFileSync(configPath);
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
		dxpMetadata = fs.readFileSync(configPath);
	}
	else {
		dxpMetadata = config[property];
	}
	return dxpMetadata;
}

module.exports = {
  getDXPMetadata,
  getExtInitMetadata
}