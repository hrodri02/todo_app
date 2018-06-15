const winston = require('winston')
const express = require('express');
const app = express();

require('./startup/logging')();
require('./startup/routes')(app);
require('./startup/db')();
require('./startup/config')();
require('./startup/prod')(app);


// the hosting environment decides what port is used for commucation
// by setting an environment variable called port so it is better to
// read the value of this variable to see if it is assigned something.
// If not, then use an arbitrary port number
const port = process.env.PORT || 3000;
const server = app.listen(port, () => winston.info(`listening on port ${port}...`));

module.exports = server;