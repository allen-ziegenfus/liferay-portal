'use strict';

const fetch = require('node-fetch');
const fs = require('fs');
const jsonwebtoken = require('jsonwebtoken');
const jwktopem = require('jwk-to-pem');
const log = require('./log');
const path = require('path');

let jwksURI;
let dxpMainDomain;

const dxpMainDomainPath = path.join('/etc/liferay/lxc/dxp-metadata', 'com.liferay.lxc.dxp.mainDomain');
const jwksURIPath = path.join('/etc/liferay/lxc/ext-init-metadata', 'liferay-sample-node-oauth-application-user-agent.oauth2.jwks.uri');

if (fs.existsSync(dxpMainDomainPath) && fs.existsSync(jwksURIPath)) {
	dxpMainDomain = fs.readFileSync(dxpMainDomainPath);
	jwksURI = "https://" + dxpMainDomain + fs.readFileSync(jwksURIPath);
}
else {
	jwksURI = process.env.JWKS_URI || 'http://localhost:8080/o/oauth2/jwks';
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