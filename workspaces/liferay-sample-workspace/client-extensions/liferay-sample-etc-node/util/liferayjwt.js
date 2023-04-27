'use strict';

const config = require('../config.json');
const fetch = require('node-fetch');
const fs = require('fs');
const jsonwebtoken = require('jsonwebtoken');
const jwktopem = require('jwk-to-pem');
const log = require('./log');
const {getDXPMetadata, getExtInitMetadata} = require('./util');

const lxcDXPMainDomain = getDXPMetadata('com.liferay.lxc.dxp.mainDomain');
const lxcDXPServerProtocol = getDXPMetadata(
	'com.liferay.lxc.dxp.server.protocol'
);
const erc =
	config['liferay.oauth.application.external.reference.codes'].split(',')[0];
const oauth2JWKSURI =
	lxcDXPServerProtocol +
	'://' +
	lxcDXPMainDomain +
	getExtInitMetadata(erc + '.oauth2.jwks.uri', '/o/oauth2/jwks');
log.info('oauth2JWKSURI: %s', oauth2JWKSURI);

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
			const jwksResponse = await fetch(oauth2JWKSURI);
			if (jwksResponse.status == 200) {
				const jwks = await jwksResponse.json();
				const jwksPublicKey = jwktopem(jwks.keys[0]);
				const decoded = jsonwebtoken.verify(
					bearerToken,
					jwksPublicKey,
					{
						algorithms: ['RS256'],
						ignoreExpiration: true, // TODO we need to use refresh token
					}
				);
				const ercResponse = await fetch(
					lxcDXPServerProtocol +
						'://' +
						lxcDXPMainDomain +
						'/o/oauth2/application?externalReferenceCode=' +
						erc
				);
				const {client_id} = await ercResponse.json();
				if (decoded.client_id == client_id) {
					req.jwt = decoded;
					next();
				}
				else {
					log.error('JWT token client_id is not expected.');
					res.status(401).send('JWT token is invalid');
					return;
				}
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
