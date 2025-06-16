/**
 * Error Handling Middleware
 * Centralizes error handling across the application
 */

/**
 * Not Found Handler
 */
const notFound = (req, res, next) => {
    const error = new Error(`Not Found - ${req.originalUrl}`);
    res.status(404);
    next(error);
};

/**
 * General Error Handler
 */
const errorHandler = (error, req, res, next) => {
    // Default to 500 server error
    let statusCode = res.statusCode === 200 ? 500 : res.statusCode;
    let message = error.message;

    // Handle specific error types
    if (error.name === 'ValidationError') {
        statusCode = 400;
        message = Object.values(error.errors).map(val => val.message).join(', ');
    }

    if (error.name === 'CastError') {
        statusCode = 400;
        message = 'Invalid ID format';
    }

    if (error.code === 11000) {
        statusCode = 400;
        message = 'Duplicate field value entered';
    }

    if (error.name === 'JsonWebTokenError') {
        statusCode = 401;
        message = 'Invalid token';
    }

    if (error.name === 'TokenExpiredError') {
        statusCode = 401;
        message = 'Token expired';
    }

    console.error(error);

    res.status(statusCode).json({
        error: message,
        ...(process.env.NODE_ENV === 'development' && { stack: error.stack })
    });
};

/**
 * Async Handler Wrapper
 * Wraps async functions to catch errors and pass to error handler
 */
const asyncHandler = (fn) => (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
};

module.exports = {
    notFound,
    errorHandler,
    asyncHandler
};
