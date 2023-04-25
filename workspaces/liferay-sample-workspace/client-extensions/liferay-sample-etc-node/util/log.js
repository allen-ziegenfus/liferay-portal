'use strict';

const {createLogger, format, transports} = require('winston');

let logger;

(function () {
	logger = createLogger({
		format: format.combine(format.splat(), format.simple()),
		transports: [new transports.Console()],
	});
})();

module.exports = logger;
