const {token} = require('../../../constants');
const verify = require('../../../middleware/auth');


describe('auth middleware', () => {
    it('should populate req.email with payload of a valid JWT.', async () => {
        const req = {
            header: jest.fn().mockReturnValue(token),
        };
        const res = {};
        const next = jest.fn();

        await verify(req, res, next);

        expect(req.email).toBeDefined();
    });
});