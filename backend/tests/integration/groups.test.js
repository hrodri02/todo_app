const request = require('supertest');
const {Group} = require('../../models/group');
const {Task} = require('../../models/task');
const mongoose = require('mongoose');
const {token} = require('../../constants');
let server;


describe('/api/groups', () => {
    beforeEach(() => {server = require('../../index'); });
    afterEach(async () => {
        server.close();
        await Group.remove({});
    });

    describe('GET /', () => {
        it('should return all groups', async () => {
            const id1 = new mongoose.Types.ObjectId();
            const id2 = new mongoose.Types.ObjectId();

            await Group.collection.insertMany([
                { name: 'name1', _id: id1 },
                { name: 'name2', _id: id2 },
            ]);

            const res = await request(server)
                .get('/api/groups')
                .set('x-auth-token', token);

            expect(res.status).toBe(200);
            expect(res.body.length).toBe(2);

            res.body.forEach(e => {
                expect(e.date).toMatch(/\d+?-\d+?-\d+?/);
            });
        });
    });

    describe('GET /:date', () => {
        it('should return groups if a valid date is passed', async () => {
            const group = new Group({ name: 'group1' });
            await group.save();
            
            const date = group.date;
            const year = date.getFullYear();
            const month = parseInt(date.getMonth()) + 1;
            const day = date.getDate();
            const dateStr = year + '-' + month + '-' + day;

            const res = await request(server)
                .get('/api/groups/' + dateStr)
                .set('x-auth-token', token);

            expect(res.status).toBe(200);
            expect(res.body[0]).toHaveProperty('name', group.name);
        });

        it('should return 404 if invalid date is passed', async () => {
            const res = await request(server)
                .get('/api/groups/1')
                .set('x-auth-token', token);
            expect(res.status).toBe(404);
        });
    });

    describe('POST /', () => {
        let authToken;
        let name;

        const exec = () => {
            return request(server)
            .post('/api/groups')
            .set('x-auth-token', authToken)
            .send({ name: name });
        };

        beforeEach( () => {
            name = 'name1';
            authToken = token;
        });

        it('should return 401 if client is not logged in.', async () => {
            authToken = '';
            const res = await exec();

            expect(res.status).toBe(401);
        });

        it('should return 400 if group is less than 4 characters.', async () => {
            name = 'aaa';
            const res = await exec();

            expect(res.status).toBe(400);
        });

        it('should return 400 if group is more than 50 characters.', async () => {
            name = new Array(52).join('a');

            const res = await exec();

            expect(res.status).toBe(400);
        });

        it('should save the group if it is valid.', async () => {
            await exec();

            const group = await Group.find({ name: 'name1'});

            expect(group).not.toBeNull();
        });

        it('should return group if it is valid.', async () => {
            const res = await exec();
            
            expect(res.body).toHaveProperty('_id');
            expect(res.body).toHaveProperty('tasks');
            expect(res.body).toHaveProperty('date');
            expect(res.body).toHaveProperty('name', 'name1');
        });
    });

    describe('PUT /:groupId', () => {
        let authToken;
        let newName;
        let groupId;

        const exec = () => {
            return request(server)
            .put('/api/groups/' + groupId)
            .set('x-auth-token', authToken)
            .send({ name: newName });
        };

        beforeEach(async () => {
            newName = 'group2';
            authToken = token;

            const group = new Group({ name: 'group1' });
            groupId = group._id;
            await group.save();
        });

        it('should return 404 if group id is invalid.', async () => {
            groupId = '1';
            const res = await exec();

            expect(res.status).toBe(404);
        });

        it('should return 404 if no group with the given id exists.', async () => {
            groupId = mongoose.Types.ObjectId();
            const res = await exec();

            expect(res.status).toBe(404);
        });

        it('should return 400 if group is less than 4 characters.', async () => {
            newName = 'aaa';
            const res = await exec();

            expect(res.status).toBe(400);
        });

        it('should return 400 if group is more than 50 characters.', async () => {
            newName = new Array(52).join('a');

            const res = await exec();

            expect(res.status).toBe(400);
        });

        it('should save the group if it is valid.', async () => {
            await exec();

            const group = await Group.find({ name: newName });

            expect(group).not.toBeNull();
        });

        it('should return group if it is valid.', async () => {
            const res = await exec();
            
            expect(res.body).toHaveProperty('_id');
            expect(res.body).toHaveProperty('tasks');
            expect(res.body).toHaveProperty('date');
            expect(res.body).toHaveProperty('name', newName);
        });
    });

    describe('DEL /:groupId', () => {
        let groupId;

        const exec = () => {
            return request(server)
            .delete('/api/groups/' + groupId)
            .set('x-auth-token', token);
        };

        beforeEach(async () => {
            const group = new Group({ name: 'group1' });
            groupId = group._id;
            await group.save();
        });

        it('should return 404 if group id is invalid.', async () => {
            groupId = '1';
            const res = await exec();

            expect(res.status).toBe(404);
        });

        it('should return 404 if no group with the given id exists.', async () => {
            groupId = mongoose.Types.ObjectId();
            const res = await exec();

            expect(res.status).toBe(404);
        });

        it('should return group if it was deleted successfully.', async () => {
            const res = await exec();
            
            expect(res.status).toBe(200);
            expect(res.body).toHaveProperty('_id');
            expect(res.body).toHaveProperty('tasks');
            expect(res.body).toHaveProperty('date');
            expect(res.body).toHaveProperty('name', 'group1');
        });
    });

    describe('POST /:groupId', () => {
        let groupId;
        let group;
        let taskName;

        const exec = () => {
            return request(server)
            .post('/api/groups/' + groupId)
            .set('x-auth-token', token)
            .send({ name: taskName });
        };

        beforeEach(async () => {
            taskName = 'task1';

            group = new Group({ name: 'group1' });
            groupId = group._id;
            await group.save();
        });

        it('should return 404 if invalid group id is passed.', async () => {
            groupId = '1';
            const res = await exec();

            expect(res.status).toBe(404);
        });

        it('should return 404 if no group with the given id exists.', async () => {
            groupId = mongoose.Types.ObjectId();
            const res = await exec();

            expect(res.status).toBe(404);
        });

        it('should return 400 if task is less than 4 characters.', async () => {
            taskName = 'aaa';
            const res = await exec();

            expect(res.status).toBe(400);
        });

        it('should return 400 if task is more than 50 characters.', async () => {
            taskName = new Array(52).join('a');
            const res = await exec();

            expect(res.status).toBe(400);
        });

        it('should save the taks if it is valid.', async () => {
            await exec();

            const task = await Task.find({ name: taskName });

            expect(task).not.toBeNull();
        });

        it('should return task if it is valid.', async () => {
            const res = await exec();

            expect(res.status).toBe(200);
            expect(res.body).toHaveProperty('_id');
            expect(res.body).toHaveProperty('isComplete');
            expect(res.body).toHaveProperty('totalSeconds', 0);
            expect(res.body).toHaveProperty('name', taskName);
        });
    });

    describe('PUT /:groupId/:taskId', () => {
        let groupId;
        let taskId;
        let group;
        let taskName;

        const exec = () => {
            return request(server)
            .put('/api/groups/' + groupId + '/' + taskId)
            .set('x-auth-token', token)
            .send({ name: taskName });
        };

        beforeEach(async () => {
            taskName = 'task2';

            group = new Group({ name: 'group1', tasks: [new Task({ name: 'task1' })] });
            groupId = group._id;
            taskId = group.tasks[0]._id;
            await group.save();
        });

        it('should return 404 if invalid group id is passed.', async () => {
            groupId = '1';
            const res = await exec();

            expect(res.status).toBe(404);
        });

        it('should return 404 if no group with the given id exists.', async () => {
            groupId = mongoose.Types.ObjectId();
            const res = await exec();

            expect(res.status).toBe(404);
        });

        it('should return 404 if invalid task id is passed.', async () => {
            taskId = '1';
            const res = await exec();

            expect(res.status).toBe(404);
        });

        it('should return 400 if task is less than 5 characters.', async () => {
            taskName = 'task';
            const res = await exec();

            expect(res.status).toBe(400);
        });

        it('should return 400 if task is more than 50 characters.', async () => {
            taskName = new Array(52).join('a');
            const res = await exec();

            expect(res.status).toBe(400);
        });

        it('should save the taks in db if it is valid.', async () => {
            await exec();

            const task = await Task.find({ name: taskName });

            expect(task).not.toBeNull();
        });

        it('should return group if it is valid.', async () => {
            const res = await exec();
            
            expect(res.status).toBe(200);
            expect(res.body).toHaveProperty('_id');
            expect(res.body).toHaveProperty('name', group.name);
            expect(res.body).toHaveProperty('tasks');
            expect(res.body.tasks[0]).toHaveProperty('_id');
            expect(res.body.tasks[0]).toHaveProperty('isComplete');
            expect(res.body.tasks[0]).toHaveProperty('totalSeconds', 0);
            expect(res.body.tasks[0]).toHaveProperty('name', taskName);
        });
    });

    describe('DEL /:groupId/:taskId', () => {
        let groupId;
        let taskId;
        let group;

        const exec = () => {
            return request(server)
            .delete('/api/groups/' + groupId + '/' + taskId)
            .set('x-auth-token', token);
        };

        beforeEach(async () => {
            group = new Group({ name: 'group1', tasks: [new Task({ name: 'task1' })] });
            groupId = group._id;
            taskId = group.tasks[0]._id;
            await group.save();
        });

        it('should return 404 if invalid group id is passed.', async () => {
            groupId = '1';
            const res = await exec();

            expect(res.status).toBe(404);
        });

        it('should return 404 if no group with the given id exists.', async () => {
            groupId = mongoose.Types.ObjectId();
            const res = await exec();

            expect(res.status).toBe(404);
        });

        it('should return 404 if invalid task id is passed.', async () => {
            taskId = '1';
            const res = await exec();

            expect(res.status).toBe(404);
        });

        it('should return group if a valid task id and group id are passed.', async () => {
            const res = await exec();
            
            expect(res.status).toBe(200);
            expect(res.body).toHaveProperty('_id');
            expect(res.body).toHaveProperty('name', group.name);
            expect(res.body).toHaveProperty('tasks');
            expect(res.body.tasks.length).toBe(0);
        });
    });
});