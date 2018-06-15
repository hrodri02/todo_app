const Joi = require('joi'); // returns a class
Joi.objectId = require('joi-objectid')(Joi);
const mongoose = require('mongoose');
const {taskSchema} = require('./task');

const groupSchema = new mongoose.Schema({
    name: { 
        type: String, 
        required: true,
        minlength: 4,
        maxlength: 50,
    },
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    tasks: {
        type: [taskSchema],
    },
    date: {
        type: Date,
        default: Date.now
    }
});

// compile schema into a model which returns a class
const Group = mongoose.model('Group', groupSchema);

function validateGroup(group) 
{
    const schema = {
        name: Joi.string().min(4).max(50).required(),
        _id: Joi.objectId().min(5).max(255),
        task: Joi.object()
    };

    return Joi.validate(group, schema);
}

module.exports.Group = Group;
module.exports.validateGroup = validateGroup;