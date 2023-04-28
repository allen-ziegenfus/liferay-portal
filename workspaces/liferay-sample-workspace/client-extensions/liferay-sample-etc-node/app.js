'use strict';

import config from './config.js';
import express from 'express';
import fetch from 'node-fetch';
import {
	corsWithReady,
	liferayJWT,
} from './util/liferay-oauth2-resource-server.js';
import log from './util/log.js';

const app = express();
const readyPath = '/ready';

app.use(corsWithReady(readyPath));
app.use(liferayJWT(readyPath));

app.get(readyPath, (req, res) => {
	res.send('READY');
});

app.get('/comic', async (req, res) => {
	log.info('User %s is authorized', req.jwt.username);
	log.info('User scopes: ' + req.jwt.scope);

	const comicResponse = await fetch('https://xkcd.com/info.0.json');

	if (comicResponse.status !== 200) {
		res.status(500).send('Error fetching comic ');
		return;
	}

	const comic = await comicResponse.json();

	log.info('Comic fetched\n%s', JSON.stringify(comic, null, 2));

	res.status(200).json(comic);
});

const serverPort = config['server.port'];

app.get('/sample/object/action/1', async (req, res) => {
	res.status(200).send('OK');
});

app.get('/sample/object/action/2', async (req, res) => {
	res.status(200).send('OK');
});

app.get('/sample/workflow/action/1', async (req, res) => {
	res.status(200).send('OK');
});

app.listen(serverPort, () => {
	log.info('App listening on %s', serverPort);
});

export default app;
