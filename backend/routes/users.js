const auth = require('../middleware/auth');
const bcrypt = require('bcrypt');
const _ = require('lodash');
const {User, validateUser} = require('../models/user');
const express = require('express');
const router = express.Router();

/*
// return all groups
router.get('/', async (req, res) => {
    // get all groups and sort them by name
    const groups = await Group.find().sort('name');

    // return groups to client
    res.send(groups);
});
*/

// get current user
router.get('/me', auth, async (req, res) => {
    const user = await User.findById(req.user._id).select('-password');
    
    // send group to client
    res.send(user);
});


// register a user
router.post('/', async (req, res) => {
    // validate the body of the request
    const {error} = validateUser(req.body);

    // if body is invalid, return 400 (bad request)
    if (error) return res.status(400).send(error.details[0].message);

    let user = await User.findOne({ email: req.body.email });

    // if user with email already exists, return 400
    if (user) return res.status(400).send('User already registered.');

    // create new user
    user = new User(_.pick(req.body, ['name', 'email', 'password']));

    // hash plain text password
    const salt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(user.password, salt);

    // save group in database
    await user.save();

    const token = user.generateAuthToken();

    // send group to client
    res.header('x-auth-token', token).send( _.pick(user, ['_id', 'name', 'email']) );
});

/*
// update a group
router.put('/:groupId', async (req, res) => {
    // look up group
    let group = await Group.findById(req.params.groupId);
    
    // if does not exist, return 404
    if (!group) return res.status(404).send('The group with the given id was not found.');

    // validate the body of the request
    const {error} = validateGroup(req.body);

    // if body is invalid, return 400
    if (error) return res.status(400).send(error.details[0].message);
    
    // update the name of the group
    group.name = req.body.name;

    // save group to db
    group = await group.save();

    // return group to client
    res.send(group);
});
// remove a group
router.delete('/:id', async (req, res) => {
    // look up the course
    const group = await Group.findByIdAndRemove(req.params.id);

    // if does not exist, return 404
    if (!group) return res.status(404).send('The group with the given id was not found.');

    // return course deleted
    res.send(group);
});
*/

module.exports = router;