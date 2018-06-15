const Joi = require('joi'); // returns a class
const _ = require('lodash');
const {User} = require('../models/user');
const express = require('express');
const router = express.Router();
const verify = require('../middleware/auth');

// login a user
router.post('/', verify, async (req, res) => {
    // validate the body of the request
    const {error} = validate(req.body);

    // if body is invalid, return 400 (bad request)
    if (error) return res.status(400).send(error.details[0].message);

    // check if the user is already in db
    let user = await User.findOne({ email: req.email });

    // if not, then create new user and save in db
    if (!user) {
        user = new User({
            name: req.body.name,
            email: req.email
        });

        await user.save();
    }

    // send user to client
    res.send( _.pick(user, ['_id', 'name', 'email']) );
});

function validate(req) {
    const schema = {
        name: Joi.string().min(5).max(50).required()
    };

    return Joi.validate(req, schema);
}

module.exports = router;