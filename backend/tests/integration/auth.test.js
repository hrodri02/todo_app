const request = require('supertest');
const {token} = require('../../constants');

let server;

describe('auth middleware', () => {
    let authToken;

    beforeEach(() => {
        server = require('../../index');
        authToken = token;
    });

    afterEach(async () => {
        server.close();
    });

    const exec = () => {
        return request(server)
                .get('/api/groups')
                .set('x-auth-token', authToken)
    };

    it('should return 401 if client is not logged in.', async () => {
        authToken = '';
        const res = await exec();

        expect(res.status).toBe(401);
    });
    
    it('should return 200 if token is valid.', async () => {
        const res = await exec();

        expect(res.status).toBe(200);
    });
});