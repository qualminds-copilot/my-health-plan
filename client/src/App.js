import React, { useState, useEffect } from 'react';
import Login from './components/Login';
import Dashboard from './components/Dashboard';
import Member from './components/Member';
import './App.css';

function App() {
  const [user, setUser] = useState(null);
  const [token, setToken] = useState(null);
  const [loading, setLoading] = useState(true);
  const [currentView, setCurrentView] = useState('dashboard');
  const [selectedMember, setSelectedMember] = useState(null);

  // Check for existing login on app start
  useEffect(() => {
    const savedToken = localStorage.getItem('token');
    const savedUser = localStorage.getItem('user');
    
    if (savedToken && savedUser) {
      try {
        setToken(savedToken);
        setUser(JSON.parse(savedUser));
      } catch (error) {
        console.error('Error parsing saved user data:', error);
        // Clear invalid data
        localStorage.removeItem('token');
        localStorage.removeItem('user');
      }
    }
    setLoading(false);
  }, []);

  const handleLogin = (userData, userToken) => {
    setUser(userData);
    setToken(userToken);
  };

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    setUser(null);
    setToken(null);
    setCurrentView('dashboard'); // Default to dashboard after logout
    setSelectedMember(null);
  };

  const handleMemberClick = (memberData) => {
    setSelectedMember(memberData);
    setCurrentView('member');
  };

  const handleNavigation = (view) => {
    if (view === 'Dashboard') {
      setCurrentView('dashboard');
      setSelectedMember(null);
    } else {
      // For other views, you might want to set them directly
      // or handle them based on the specific view name
      console.log(`Navigation to ${view} requested`);
      // Example: setCurrentView(view.toLowerCase()); 
      // Ensure 'view' matches a valid state for currentView
    }
  };

  const handleBackToDashboard = () => {
    setCurrentView('dashboard');
    setSelectedMember(null);
  };

  if (loading) {
    return (
      <div className="d-flex justify-content-center align-items-center vh-100">
        <div className="spinner-border text-primary" role="status">
          <span className="visually-hidden">Loading...</span>
        </div>
      </div>
    );
  }

  return (
    <div className="App">
      {user ? (
        currentView === 'dashboard' ? (
          <Dashboard 
            user={user} 
            onLogout={handleLogout} 
            onMemberClick={handleMemberClick}
            onNavigate={handleNavigation} // Pass handler to Dashboard
          />
        ) : (
          <Member 
            user={user}
            memberData={selectedMember}
            onLogout={handleLogout}
            onBack={handleBackToDashboard}
            onNavigate={handleNavigation} // Pass handler to Member
          />
        )
      ) : (
        <Login onLogin={handleLogin} />
      )}
    </div>
  );
}

export default App;
