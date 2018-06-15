const {User} = require('../../models/user');
const request = require('supertest');
const {token} = require('../../constants');

let server;

describe('/api/tokensignin', () => {
    

    beforeEach(() => {
        server = require('../../index');
    });

    afterEach(async () => {
        server.close();
        await User.remove({});
    });

    describe('POST /', () => {
        let name;
        
        beforeEach(() => {
            name = 'Heriberto Rodriguez';
        });

        const exec = () => {
            return request(server)
                    .post('/api/tokensignin')
                    .set('x-auth-token', token)
                    .send({ name: name });
        };
    
        it('should return 400 if name is less than 5 characters', async () => {
            name = 'aaaa'
            const res = await exec();
    
            expect(res.status).toBe(400);
        });
    
        it('should return 400 if name is more than 50 characters', async () => {
            name = new Array(52).join('a');
            const res = await exec();
    
            expect(res.status).toBe(400);
        });
    
        it('should save the user if it is valid.', async () => {
            await exec();
    
            const user = await User.find({ email: 'hrodriguez1821@gmail.com' });
    
            expect(user).not.toBeNull();
        });
    
        it('should return user if it is valid.', async () => {
            const res = await exec();
    
            expect(res.status).toBe(200);
            expect(res.body).toHaveProperty('_id');
            expect(res.body).toHaveProperty('email');
            expect(res.body).toHaveProperty('name', name);
        });
    });
});