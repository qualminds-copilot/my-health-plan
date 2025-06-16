/**
 * Server Constants
 */

// HTTP Status Codes
const HTTP_STATUS = {
    OK: 200,
    CREATED: 201,
    NO_CONTENT: 204,
    BAD_REQUEST: 400,
    UNAUTHORIZED: 401,
    FORBIDDEN: 403,
    NOT_FOUND: 404,
    CONFLICT: 409,
    INTERNAL_SERVER_ERROR: 500
};

// Error Messages
const ERROR_MESSAGES = {
    INVALID_CREDENTIALS: 'Invalid email or password',
    TOKEN_REQUIRED: 'Access token is required',
    TOKEN_INVALID: 'Invalid or expired token',
    USER_NOT_FOUND: 'User not found',
    MEMBER_NOT_FOUND: 'Member not found',
    UNAUTHORIZED_ACCESS: 'Unauthorized access',
    VALIDATION_ERROR: 'Validation error',
    SERVER_ERROR: 'Internal server error',
    MISSING_REQUIRED_FIELDS: 'Missing required fields'
};

// Success Messages
const SUCCESS_MESSAGES = {
    LOGIN_SUCCESS: 'Login successful',
    LOGOUT_SUCCESS: 'Logout successful',
    DATA_RETRIEVED: 'Data retrieved successfully',
    DATA_CREATED: 'Data created successfully',
    DATA_UPDATED: 'Data updated successfully',
    DATA_DELETED: 'Data deleted successfully'
};

// JWT Configuration
const JWT_CONFIG = {
    SECRET: process.env.JWT_SECRET || 'your-secret-key',
    EXPIRES_IN: process.env.JWT_EXPIRES_IN || '24h',
    REFRESH_EXPIRES_IN: process.env.JWT_REFRESH_EXPIRES_IN || '7d'
};

// Database Configuration
const DB_CONFIG = {
    MAX_CONNECTIONS: 20,
    IDLE_TIMEOUT: 30000,
    CONNECTION_TIMEOUT: 2000
};

// API Limits
const API_LIMITS = {
    MAX_PAGE_SIZE: 100,
    DEFAULT_PAGE_SIZE: 10,
    MAX_SEARCH_RESULTS: 1000
};

module.exports = {
    HTTP_STATUS,
    ERROR_MESSAGES,
    SUCCESS_MESSAGES,
    JWT_CONFIG,
    DB_CONFIG,
    API_LIMITS
};
