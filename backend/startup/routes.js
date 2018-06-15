const express = require('express');
const groups = require('../routes/groups');
const users = require('../routes/users');
const auth = require('../routes/auth');
const tokensignin = require('../routes/tokensignin');
const home = require('../routes/home');
const error = require('../middleware/error');

module.exports = function(app) {
    // installing a middleware for input validation
    // its job is to read the request and if there is a json
    // object in the body of the request, it will parse the
    // body of the request into a json object and then it will
    // set req.body
    app.use(express.json());

    // for any route with /api/groups use the groups router
    app.use('/api/groups', groups);
    app.use('/api/users', users);
    app.use('/api/auth', auth);
    app.use('/api/tokensignin', tokensignin);
    app.use('/', home);
    app.use(error);
}