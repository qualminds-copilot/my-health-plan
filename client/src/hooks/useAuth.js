import { useState, useEffect } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { STORAGE_KEYS, ROUTES, MESSAGES } from '../constants';
import authService from '../services/authService';

/**
 * Custom hook for authentication management
 */
export const useAuth = () => {
    const [user, setUser] = useState(null);
    const [token, setToken] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    const navigate = useNavigate();
    const location = useLocation();

    // Initialize authentication state
    useEffect(() => {
        initializeAuth();
    }, []);

    const initializeAuth = () => {
        try {
            const savedToken = localStorage.getItem(STORAGE_KEYS.TOKEN);
            const savedUser = localStorage.getItem(STORAGE_KEYS.USER);

            if (savedToken && savedUser) {
                setToken(savedToken);
                setUser(JSON.parse(savedUser));
            }
        } catch (error) {
            console.error('Error parsing saved user data:', error);
            clearAuthData();
        } finally {
            setLoading(false);
        }
    };

    const login = async (credentials) => {
        try {
            setLoading(true);
            setError(null);

            const response = await authService.login(credentials);

            if (response.token && response.user) {
                setToken(response.token);
                setUser(response.user);

                localStorage.setItem(STORAGE_KEYS.TOKEN, response.token);
                localStorage.setItem(STORAGE_KEYS.USER, JSON.stringify(response.user));

                // Redirect to intended page or dashboard
                const from = location.state?.from?.pathname || ROUTES.DASHBOARD;
                navigate(from, { replace: true });

                return response;
            } else {
                throw new Error('Invalid response from server');
            }
        } catch (error) {
            const errorMessage = error.message || MESSAGES.NETWORK_ERROR;
            setError(errorMessage);
            throw error;
        } finally {
            setLoading(false);
        }
    };

    const logout = async () => {
        try {
            setLoading(true);

            // Call logout endpoint
            await authService.logout();
        } catch (error) {
            console.error('Logout error:', error);
            // Continue with logout even if API call fails
        } finally {
            clearAuthData();
            navigate(ROUTES.LOGIN, { replace: true });
            setLoading(false);
        }
    };

    const clearAuthData = () => {
        localStorage.removeItem(STORAGE_KEYS.TOKEN);
        localStorage.removeItem(STORAGE_KEYS.USER);
        setUser(null);
        setToken(null);
        setError(null);
    };

    const isAuthenticated = () => {
        return !!(user && token);
    };

    return {
        user,
        token,
        loading,
        error,
        login,
        logout,
        isAuthenticated,
        clearError: () => setError(null)
    };
};
