const jwt = require('jsonwebtoken');

/**
 * JWT Authentication Middleware
 * Verifies JWT tokens and adds user info to request object
 */
const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

    if (!token) {
        return res.status(401).json({
            error: 'Access token required',
            message: 'No token provided'
        });
    }

    jwt.verify(token, process.env.JWT_SECRET || 'your-secret-key', (err, user) => {
        if (err) {
            return res.status(403).json({
                error: 'Invalid token',
                message: 'Token is invalid or expired'
            });
        }

        req.user = user;
        next();
    });
};

/**
 * Optional Authentication Middleware
 * Adds user info if token is provided, but doesn't require it
 */
const optionalAuth = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return next();
    }

    jwt.verify(token, process.env.JWT_SECRET || 'your-secret-key', (err, user) => {
        if (!err) {
            req.user = user;
        }
        next();
    });
};

module.exports = {
    authenticateToken,
    optionalAuth
};
