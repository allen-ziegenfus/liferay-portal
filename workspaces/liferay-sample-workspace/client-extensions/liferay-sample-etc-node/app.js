'use strict';

const config = require('./config.json');
const cors = require('cors');
const express = require('express');
const fetch = require('node-fetch');
const liferayjwt = require('./util/liferayjwt');
const log = require('./util/log');
const {getDXPMetadata} = require('./util/util')

const app = express();
const readyPath = '/ready';

const domains = getDXPMetadata('com.liferay.lxc.dxp.domains');
const lxcDXPServerProtocol = getDXPMetadata('com.liferay.lxc.dxp.server.protocol');
const allowList = domains.split(',').map(v => lxcDXPServerProtocol + '://' + v);

const corsOptions = {
  origin: function (origin, callback) {
		console.log(origin);
    if (allowList.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  }
};

app.use(cors(corsOptions));
app.use(liferayjwt(readyPath));

app.get(readyPath, (req, res) => {
	res.send('READY');
});

app.get('/comic', async (req, res) => {
	if (!req.jwt) {
		res.status(401).send('No authorization header');
		return;
	}

	log.info('User %s is authorized', req.jwt.username);
	log.info('User scopes: ' + req.jwt.scope);

	const comicResponse = await fetch('https://xkcd.com/info.0.json');

	if (comicResponse.status !== 200) {
		res.status(500).send('Error fetching comic ');
		return;
	}

	const comic = await comicResponse.json();

	log.info('Comic fetched\n%s', JSON.stringify(comic));

	res.status(200).json(comic);
});

const serverPort = config["server.port"];

app.listen(serverPort, () => {
	log.info('App listening on %s', serverPort);
});

module.exports = app;
