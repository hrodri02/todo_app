const {OAuth2Client} = require('google-auth-library');
const {clientId} = require('../constants');
const config = require('config');
const jwt = require('jsonwebtoken');

const client = new OAuth2Client(clientId);

async function verify(req, res, next) {
    const token = req.header('x-auth-token');
    if (!token) return res.status(401).send('Access denied. No token provided.');

    try 
    {
        const ticket = await client.verifyIdToken({
            idToken: token,
            audience: clientId,
        });

        const payload = ticket.getPayload();
        req.email = payload['email'];
        req.googleId = payload['sub'];
        next();
    }
    catch (err) {
        res.status(400).send(err.message);
    }
}

function auth(req, res, next) {
    // get token
    const token = req.header('x-auth-token');

    // client does not have the authentication credentials for this operation 
    if (!token) return res.status(401).send('Access denied. No token provided.');

    try {
        const decoded = jwt.verify(token, config.get('jwtPrivateKey'));
        req.user = decoded;
        next();
    }
    catch (ex) {
        res.status(400).send('Invalid token.');
    }
}

module.exports = verify;