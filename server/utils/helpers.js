/**
 * Server Utility Functions
 */

/**
 * Create standardized API response
 */
const createResponse = (success = true, data = null, message = null, errors = null) => {
    return {
        success,
        data,
        message,
        errors,
        timestamp: new Date().toISOString()
    };
};

/**
 * Create success response
 */
const successResponse = (data, message = 'Success') => {
    return createResponse(true, data, message);
};

/**
 * Create error response
 */
const errorResponse = (message = 'Error occurred', errors = null) => {
    return createResponse(false, null, message, errors);
};

/**
 * Validate required fields
 */
const validateRequired = (data, requiredFields) => {
    const missing = [];

    requiredFields.forEach(field => {
        if (!data[field] || data[field].toString().trim() === '') {
            missing.push(field);
        }
    });

    return missing;
};

/**
 * Sanitize string input
 */
const sanitizeString = (str) => {
    if (typeof str !== 'string') return str;
    return str.trim().replace(/[<>]/g, '');
};

/**
 * Generate random string
 */
const generateRandomString = (length = 32) => {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let result = '';
    for (let i = 0; i < length; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
};

/**
 * Check if email is valid
 */
const isValidEmail = (email) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
};

/**
 * Format date for database
 */
const formatDateForDB = (date) => {
    if (!date) return null;
    return new Date(date).toISOString().split('T')[0];
};

/**
 * Parse pagination parameters
 */
const parsePagination = (query) => {
    const page = parseInt(query.page) || 1;
    const limit = Math.min(parseInt(query.limit) || 10, 100); // Max 100 items per page
    const offset = (page - 1) * limit;

    return { page, limit, offset };
};

module.exports = {
    createResponse,
    successResponse,
    errorResponse,
    validateRequired,
    sanitizeString,
    generateRandomString,
    isValidEmail,
    formatDateForDB,
    parsePagination
};
