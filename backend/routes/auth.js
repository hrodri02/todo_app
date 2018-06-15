const Joi = require('joi'); // returns a class
const bcrypt = require('bcrypt');
const {User} = require('../models/user');
const express = require('express');
const router = express.Router();

// login a user
router.post('/', async (req, res) => {
    // validate the body of the request
    const {error} = validate(req.body);

    // if body is invalid, return 400 (bad request)
    if (error) return res.status(400).send(error.details[0].message);

    // find user with given email
    const user = await User.findOne({ email: req.body.email });

    // if user with email does not exist, return 400
    if (!user) return res.status(400).send('Invalid email or password.');

    // verify password
    const validPwd = await bcrypt.compare(req.body.password, user.password);

    // if password is invalid, return 400
    if (!validPwd) return res.status(400).send('Invalid email or password.');

    const token = user.generateAuthToken();

    // send group to client
    res.send(token);
});

function validate(req) {
    const schema = {
        email: Joi.string().min(5).max(255).required().email(),
        password: Joi.string().min(5).max(255).required(),
    };

    return Joi.validate(req, schema);
}

module.exports = router;