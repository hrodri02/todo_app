const validateObjectId = require('../middleware/validateObjectId');
const verify = require('../middleware/auth');
const admin = require('../middleware/admin');
const {Group, validateGroup} = require('../models/group');
const {Task, validateTask} = require('../models/task');
const express = require('express');
const router = express.Router();

// return all groups of user with given uid
router.get('/', verify, async (req, res) => {
    const _id = req.header('_id');
    
    // get all groups and sort them by name
    const groups = await Group
        .find({ user: _id })
        .select('date _id')
        .sort('date');

    // return groups to client
    res.send(groups);
});

// return groups with the given date
router.get('/:date', verify, async (req, res) => {
    if (!req.params.date.match(/\d+?-\d+?-\d+?/))
        return res.status(404).send('Invalid Date.');

    const _id = req.header('_id');
    const date = req.params.date.split('-');

    const year = parseInt(date[0]);
    const month = parseInt(date[1]) - 1;
    const day = parseInt(date[2]);

    const dateGiven = new Date(year, month, day);
    const tomorrow = new Date(year, month, day+1);

    const groups = await Group
        .find({ user: _id, date: {"$gte": dateGiven, "$lt": tomorrow} })
        .populate('user', 'name -_id')
        .sort('date');

    // send group to client
    res.send(groups);
});

// add a group
router.post('/', verify, async (req, res) => {
    // validate the body of the request
    const {error} = validateGroup(req.body);

    // if body is invalid, return 400 (bad request)
    if (error) return res.status(400).send(error.details[0].message);

    // create new group
    let group = new Group({ 
        name: req.body.name,
        user: req.body._id
    });

    // save group in database
    group = await group.save();

    // send group to client
    res.send(group);
});

// update a group
router.put('/:groupId', [verify, validateObjectId], async (req, res) => {
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

// add a task to an existing group
router.post('/:groupId', [verify, validateObjectId], async (req, res) => {
    // look up group
    let group = await Group.findById(req.params.groupId);
    
    // 404: object no found
    if (!group) return res.status(404).send('The group with the given id was not found.');

    // object destructuring allows us to get a property of an object
    const {error} = validateTask(req.body);

    // if body is invalid, return 400
    if (error) return res.status(400).send(error.details[0].message);

    // create new task
    const task = new Task({ 
        name: req.body.name
    });
    
    // add task to group
    group.tasks.push(task);

    // save group to db
    await group.save();

    // send group to client
    res.send(task);
});

// update one task of a group
router.put('/:groupId/:taskId', [verify, validateObjectId], async (req, res) => {
    // look up group
    let group = await Group.findById(req.params.groupId);

    // 404: object not found
    if (!group) return res.status(404).send('The group with the given id was not found.');

    let task = group.tasks.id(req.params.taskId);
    
    // 404: object not found
    if (!task) return res.status(404).send('The task with the given id was not found.');

    // object destructuring allows us to get a property of an object
    const {error} = validateTask( req.body );

    // if invalid body, return 400
    if (error) return res.status(400).send(error.details[0].message);
    
    // set name of task
    task.name = req.body.name
    
    if (req.body.isComplete !== undefined) {
        task.isComplete = req.body.isComplete;
    }
    else {
        console.log('isComplete not in body of request');
    }

    if (req.body.totalSeconds !== undefined) {
        task.totalSeconds = req.body.totalSeconds
    }
    else {
        console.log('totalSeconds not in body of request');
    }

    // save group to db
    group.save();

    // return group to client
    res.send(group);
});

// remove a group
router.delete('/:groupId', [validateObjectId], async (req, res) => {
    // look up the course
    const group = await Group.findByIdAndRemove(req.params.groupId);

    // if does not exist, return 404
    if (!group) return res.status(404).send('The group with the given id was not found.');

    // return course deleted
    res.send(group);
});

// remove a task from a group
router.delete('/:groupId/:taskId', [verify, validateObjectId], async (req, res) => {
    // find group
    const group = await Group.findById(req.params.groupId);

    // if does not exist, return 404
    if (!group) return res.status(404).send('The group with the given id was not found.');

    // find task
    const task = group.tasks.id( req.params.taskId );

    // if does not exist, return 404
    if (!task) return res.status(404).send('The task with the given id was not found.');

    // remove task from group
    task.remove();

    // save group to db
    group.save();

    // return group to client
    res.send(group);
});

module.exports = router;