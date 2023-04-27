'use strict';

const config = require('../config.json')
const fetch = require('node-fetch');
const fs = require('fs');
const jsonwebtoken = require('jsonwebtoken');
const jwktopem = require('jwk-to-pem');
const log = require('./log');
const path = require('path');

const lxcDXPMainDomain = getDXPMetadata('com.liferay.lxc.dxp.mainDomain');
const lxcDXPServerProtocol = getDXPMetadata('com.liferay.lxc.dxp.server.protocol');
const oauth2JWKSURI = getExtInitMetadata('liferay-sample-node-oauth-application-user-agent.oauth2.jwks.uri', lxcDXPServerProtocol + lxcDXPMainDomain + '/o/oauth2/jwks');

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

function liferayjwt(readyPath) {
	return async (req, res, next) => {
		if (req.path === readyPath) {
			return next();
		}

		const authorization = req.headers.authorization;

		if (!authorization) {
			res.status(401).send('No authorization header');
			return;
		}

		const bearerToken = req.headers.authorization.split('Bearer ')[1];

		try {
			const jwksResponse = await fetch(jwksURI);
			if (jwksResponse.status == 200) {
				const jwks = await jwksResponse.json();
				const jwksPublicKey = jwktopem(jwks.keys[0]);
				const decoded = jsonwebtoken.verify(
					bearerToken,
					jwksPublicKey,
					{algorithms: ['RS256']}
				);
				req.jwt = decoded;
				next();
			}
			else {
				log.error(
					'Error fetching JWKS %s %s',
					jwksResponse.status,
					jwksResponse.statusText
				);
				res.status(401).send('JWT token is invalid');
				return;
			}
		}
		catch (err) {
			log.error('Error validating JWT token\n%s', err);
			res.status(401).send('JWT token is invalid');
			return;
		}
	};
}

module.exports = liferayjwt;