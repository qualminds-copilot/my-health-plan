import axios from 'axios';
import { API_CONFIG, STORAGE_KEYS, HTTP_STATUS } from '../constants';

/**
 * API Service Class
 * Handles all HTTP requests with proper error handling and token management
 */
class ApiService {
    constructor() {
        this.api = axios.create({
            baseURL: API_CONFIG.BASE_URL,
            timeout: API_CONFIG.TIMEOUT,
            headers: {
                'Content-Type': 'application/json'
            }
        });

        // Request interceptor to add token
        this.api.interceptors.request.use(
            (config) => {
                const token = localStorage.getItem(STORAGE_KEYS.TOKEN);
                if (token) {
                    config.headers.Authorization = `Bearer ${token}`;
                }
                return config;
            },
            (error) => Promise.reject(error)
        );

        // Response interceptor for error handling
        this.api.interceptors.response.use(
            (response) => response,
            (error) => {
                if (error.response?.status === HTTP_STATUS.UNAUTHORIZED) {
                    localStorage.removeItem(STORAGE_KEYS.TOKEN);
                    localStorage.removeItem(STORAGE_KEYS.USER);
                    window.location.href = '/login';
                }
                return Promise.reject(error);
            }
        );
    }

    /**
     * Generic GET request
     */
    async get(url, config = {}) {
        try {
            const response = await this.api.get(url, config);
            return response.data;
        } catch (error) {
            throw this.handleError(error);
        }
    }

    /**
     * Generic POST request
     */
    async post(url, data = {}, config = {}) {
        try {
            const response = await this.api.post(url, data, config);
            return response.data;
        } catch (error) {
            throw this.handleError(error);
        }
    }

    /**
     * Generic PUT request
     */
    async put(url, data = {}, config = {}) {
        try {
            const response = await this.api.put(url, data, config);
            return response.data;
        } catch (error) {
            throw this.handleError(error);
        }
    }

    /**
     * Generic DELETE request
     */
    async delete(url, config = {}) {
        try {
            const response = await this.api.delete(url, config);
            return response.data;
        } catch (error) {
            throw this.handleError(error);
        }
    }

    /**
     * Handle API errors consistently
     */
    handleError(error) {
        if (error.response) {
            // Server responded with error status
            return {
                message: error.response.data?.message || 'Server error occurred',
                status: error.response.status,
                data: error.response.data
            };
        } else if (error.request) {
            // Network error
            return {
                message: 'Network error. Please check your connection.',
                status: null,
                data: null
            };
        } else {
            // Request setup error
            return {
                message: error.message || 'An unexpected error occurred',
                status: null,
                data: null
            };
        }
    }
}

// Create and export a singleton instance
const apiService = new ApiService();
export default apiService;
