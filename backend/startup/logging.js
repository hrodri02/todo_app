const winston = require('winston');
// require('winston-mongodb');
require('express-async-errors');

module.exports = function() {
    // handle uncaught exceptions
    winston.handleExceptions(
        new winston.transports.Console({ colorize: true, prettyPrint: true }),
        new winston.transports.File({ filename: 'uncaughtExceptions.log' })
    );

    // handle rejected promises
    process.on('unhandledRejection', (ex) => {
        throw ex;
    });

    winston.add(winston.transports.File, { filename: 'logfile.log' });
    // winston.add(winston.transports.MongoDB, {
    //     db: 'mongodb://localhost/todo_db'});
}