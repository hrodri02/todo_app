const Joi = require('joi'); // returns a class
const mongoose = require('mongoose');

const taskSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        minlength: 5,
        maxlength: 50
    },
    isComplete: {
        type: Boolean,
        default: false
    },
    totalSeconds: {
        type: Number,
        default: 0,
        min: 0,
    }
});

const Task = mongoose.model('Task', taskSchema);

function validateTask(task)
{
    // validate the course
    // if invalid, reutrn 400
    const schema = {
        name: Joi.string().min(5).max(50).required(),
        isComplete: Joi.bool(),
        totalSeconds: Joi.number().min(0)
    };

    return Joi.validate(task, schema);
}

exports.taskSchema = taskSchema;
exports.Task = Task;
exports.validateTask = validateTask;