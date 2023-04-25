'use strict';

const express = require('express');
const fetch = require('node-fetch');
const liferayjwt = require('./util/liferayjwt');
const log = require('./util/log');

const app = express();
const readyPath = '/ready';

app.use(liferayjwt(readyPath));

app.get(readyPath, (req, res) => {
	res.send('READY');
});

app.get('/comic', async (req, res) => {
	if (!req.user) {
		res.status(401).send('No authorization header');
		return;
	}

	log.info('User %s is authorized', req.user.username);
	log.info('User scopes: ' + req.user.scope);

	const comicResponse = await fetch('https://xkcd.com/info.0.json');

	if (comicResponse.status !== 200) {
		res.status(500).send('Error fetching comic ');
		return;
	}

	const comic = await comicResponse.json();

	log.info('Comic fetched\n%s', JSON.stringify(comic));

	res.status(200).json(comic);
});

const port = process.env.PORT || '3000';

app.listen(port, () => {
	log.info('App listening on %s', port);
});

module.exports = app;
