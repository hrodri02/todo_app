const mongoose = require('mongoose');

module.exports = function(req, res, next) {
    if (!mongoose.Types.ObjectId.isValid(req.params.groupId)) {
        return res.status(404).send('Invalid group ID.');
    }

    if (req.params.taskId) {
        if (!mongoose.Types.ObjectId.isValid(req.params.groupId)) {
            return res.status(404).send('Invalid task ID.');
        }
    }

    next();
}