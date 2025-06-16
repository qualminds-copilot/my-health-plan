import React, { useState, useEffect } from 'react';
import { Routes, Route, useNavigate, useParams } from 'react-router-dom';
import Login from './components/Login';
import Dashboard from './components/Dashboard';
import Member from './components/Member';
import memberService from './services/memberService';
import { ROUTES, STORAGE_KEYS } from './constants';
import './App.css';

/**
 * Member Page Component
 * Handles member detail view
 */
const MemberPage = ({ user, onLogout, onNavigate }) => {
  const { memberNumber } = useParams();
  const [memberData, setMemberData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchMemberData = async () => {
      if (!memberNumber) {
        setError('Member number not provided in URL.');
        setLoading(false);
        return;
      }

      try {
        setLoading(true);
        setError(null);

        const data = await memberService.getMemberByNumber(memberNumber);

        if (data) {
          setMemberData(data);
        } else {
          setError('Member not found.');
        }
      } catch (err) {
        console.error('Error fetching member data:', err);
        setError(err.message || 'Failed to load member data.');
      } finally {
        setLoading(false);
      }
    };

    fetchMemberData();
  }, [memberNumber]);

  if (loading) {
    return (
      <div className="loading-center">
        <div className="spinner-border text-primary" aria-label="Loading"></div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="container mt-5">
        <div className="alert alert-danger">{error}</div>
      </div>
    );
  }

  if (!memberData) {
    return (
      <div className="container mt-5">
        <div className="alert alert-warning">Member data not available.</div>
      </div>
    );
  }

  return (
    <Member
      user={user}
      memberData={memberData}
      onLogout={onLogout}
      onBack={() => navigate(ROUTES.DASHBOARD)}
      onNavigate={onNavigate}
    />
  );
};

/**
 * Main Application Component
 */
function App() {
  const [user, setUser] = useState(null);
  const [token, setToken] = useState(null);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

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

  const clearAuthData = () => {
    localStorage.removeItem(STORAGE_KEYS.TOKEN);
    localStorage.removeItem(STORAGE_KEYS.USER);
    setUser(null);
    setToken(null);
  };

  const handleLogin = (userData, userToken) => {
    setUser(userData);
    setToken(userToken);
    localStorage.setItem(STORAGE_KEYS.TOKEN, userToken);
    localStorage.setItem(STORAGE_KEYS.USER, JSON.stringify(userData));
    navigate(ROUTES.DASHBOARD);
  };

  const handleLogout = () => {
    clearAuthData();
    navigate(ROUTES.LOGIN);
  };

  const handleMemberClick = (memberData) => {
    if (memberData?.memberNumber) {
      navigate(`/member/${memberData.memberNumber}`);
    } else {
      console.error('Member data does not have a memberNumber property:', memberData);
    }
  };

  const handleNavigation = (viewPath) => {
    const path = viewPath.toLowerCase();
    if (path === 'dashboard') {
      navigate(ROUTES.DASHBOARD);
    } else if (path.startsWith('member/')) {
      navigate(`/${path}`);
    } else {
      console.log(`Navigation to ${viewPath} requested`);
    }
  };

  const isAuthenticated = !!(user && token);

  if (loading) {
    return (
      <div className="d-flex justify-content-center align-items-center vh-100">
        <div className="spinner-border text-primary" aria-label="Loading">
          <span className="visually-hidden">Loading...</span>
        </div>
      </div>
    );
  }

  return (
    <div className="App">
      <Routes>
        <Route path={ROUTES.LOGIN} element={<Login onLogin={handleLogin} />} />
        {isAuthenticated ? (
          <>
            <Route
              path={ROUTES.DASHBOARD}
              element={
                <Dashboard
                  user={user}
                  onLogout={handleLogout}
                  onMemberClick={handleMemberClick}
                  onNavigate={handleNavigation}
                />
              }
            />
            <Route
              path="/member/:memberNumber"
              element={
                <MemberPage
                  user={user}
                  onLogout={handleLogout}
                  onNavigate={handleNavigation}
                />
              }
            />
            <Route
              path="*"
              element={
                <Dashboard
                  user={user}
                  onLogout={handleLogout}
                  onMemberClick={handleMemberClick}
                  onNavigate={handleNavigation}
                />
              }
            />
          </>
        ) : (
          <Route path="*" element={<Login onLogin={handleLogin} />} />
        )}
      </Routes>
    </div>
  );
}

export default App;
