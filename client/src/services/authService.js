import apiService from './apiService';

/**
 * Authentication Service
 * Handles all authentication-related API calls
 */
class AuthService {
    /**
     * Login user
     */
    async login(credentials) {
        return await apiService.post('/api/auth/login', credentials);
    }

    /**
     * Logout user
     */
    async logout() {
        return await apiService.post('/api/auth/logout');
    }

    /**
     * Refresh token
     */
    async refreshToken() {
        return await apiService.post('/api/auth/refresh');
    }

    /**
     * Validate token
     */
    async validateToken() {
        return await apiService.post('/api/auth/validate');
    }
}

const authService = new AuthService();
export default authService;
