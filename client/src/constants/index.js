/**
 * Application Constants
 */

// API Configuration
export const API_CONFIG = {
    BASE_URL: process.env.NODE_ENV === 'production'
        ? 'https://my-health-plan.up.railway.app'
        : 'http://localhost:5000',
    TIMEOUT: 10000,
    RETRY_ATTEMPTS: 3
};

// Route Constants
export const ROUTES = {
    LOGIN: '/login',
    DASHBOARD: '/dashboard',
    MEMBER: '/member',
    HOME: '/'
};

// Local Storage Keys
export const STORAGE_KEYS = {
    TOKEN: 'token',
    USER: 'user',
    PREFERENCES: 'userPreferences'
};

// Application Messages
export const MESSAGES = {
    LOADING: 'Loading...',
    LOGIN_REQUIRED: 'Please log in to continue',
    MEMBER_NOT_FOUND: 'Member not found',
    NETWORK_ERROR: 'Network error occurred',
    UNAUTHORIZED: 'Unauthorized access',
    SESSION_EXPIRED: 'Session expired. Please log in again.'
};

// HTTP Status Codes
export const HTTP_STATUS = {
    OK: 200,
    CREATED: 201,
    BAD_REQUEST: 400,
    UNAUTHORIZED: 401,
    FORBIDDEN: 403,
    NOT_FOUND: 404,
    INTERNAL_SERVER_ERROR: 500
};

// Navigation Items
export const NAV_ITEMS = [
    { name: 'Dashboard', path: '/dashboard' },
    { name: 'Members', path: '/members' },
    { name: 'Tasks', path: '/tasks' },
    { name: 'Providers', path: '/providers' },
    { name: 'Authorization', path: '/authorization' },
    { name: 'Faxes', path: '/faxes' }
];
