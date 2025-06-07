// API configuration based on environment
const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000';

export const apiConfig = {
  baseURL: API_BASE_URL,
  endpoints: {
    auth: {
      login: `${API_BASE_URL}/api/auth/login`,
      logout: `${API_BASE_URL}/api/auth/logout`,
      me: `${API_BASE_URL}/api/auth/me`
    },
    dashboard: {
      stats: `${API_BASE_URL}/api/dashboard/stats`,
      authorizations: `${API_BASE_URL}/api/dashboard/authorizations`
    }
  }
};

export default apiConfig;
