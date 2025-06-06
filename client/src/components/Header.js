import React, { useState } from 'react';
import axios from 'axios';

const Header = ({ user, onLogout, onNavigate, activeTab = 'Dashboard' }) => {
  const [showLogoutModal, setShowLogoutModal] = useState(false);
  const [loggingOut, setLoggingOut] = useState(false);

  const handleLogoutClick = () => {
    setShowLogoutModal(true);
  };

  const handleNavClick = (navItem) => {
    if (onNavigate) {
      onNavigate(navItem);
    }
  };

  const handleLogoutConfirm = async () => {
    setLoggingOut(true);
    
    try {
      const token = localStorage.getItem('token');
      if (token) {
        // Call backend logout endpoint
        await axios.post('http://localhost:5000/api/auth/logout', {}, {
          headers: {
            'Authorization': `Bearer ${token}`
          }
        });
      }
    } catch (error) {
      console.log('Logout error:', error);
      // Continue with logout even if API call fails
    } finally {
      // Always clear local storage and call parent logout
      setLoggingOut(false);
      setShowLogoutModal(false);
      onLogout();
    }
  };

  const handleLogoutCancel = () => {
    setShowLogoutModal(false);
  };

  const navItems = [
    { name: 'Dashboard', active: activeTab === 'Dashboard' },
    { name: 'Members', active: activeTab === 'Members' },
    { name: 'Tasks', active: activeTab === 'Tasks' },
    { name: 'Providers', active: activeTab === 'Providers' },
    { name: 'Authorization', active: activeTab === 'Authorization' },
    { name: 'Faxes', active: activeTab === 'Faxes' }
  ];

  return (
    <>
      {/* Header with Navigation */}
      <nav className="navbar navbar-expand-lg navbar-dark bg-primary">
        <div className="container-fluid">
          <span className="navbar-brand h1 mb-0" style={{ fontSize: '25px', fontWeight: 'bold', marginRight: '4rem' }}>
            <i className="bi bi-heart-pulse me-2"></i>
            MyHealthPlan
          </span>
          
          {/* Navigation Links */}
          <div className="navbar-nav me-auto">
            {navItems.map((item) => (
              <button 
                key={item.name}
                className={`nav-menu-item me-3 ${item.active ? 'nav-menu-active' : ''}`}
                onClick={() => handleNavClick(item.name)}
              >
                {item.name}
              </button>
            ))}
          </div>
          
          {/* User Dropdown */}
          <div className="navbar-nav ms-auto d-flex align-items-center">
            {/* Header Icons */}
            <div className="d-flex align-items-center me-3">
              <button className="btn btn-link text-white header-icon-btn me-2" title="Notifications">
                <i className="bi bi-bell" style={{ fontSize: '18px' }}></i>
              </button>
              <button className="btn btn-link text-white header-icon-btn me-2" title="Messages">
                <i className="bi bi-envelope" style={{ fontSize: '18px' }}></i>
              </button>
              <button className="btn btn-link text-white header-icon-btn me-2" title="Settings">
                <i className="bi bi-gear" style={{ fontSize: '18px' }}></i>
              </button>
              <button className="btn btn-link text-white header-icon-btn me-2" title="Help">
                <i className="bi bi-question-circle" style={{ fontSize: '18px' }}></i>
              </button>
            </div>
            
            <div className="dropdown">
              <button 
                className="btn btn-link text-white dropdown-toggle username-btn d-flex align-items-center" 
                type="button"
                id="userDropdown"
                data-bs-toggle="dropdown"
                aria-expanded="false"
              >
                <i className="bi bi-person-circle me-2" style={{ fontSize: '20px' }}></i>
                {user?.fullName || user?.name || 'User'}
              </button>
              <ul className="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <li><span className="dropdown-item-text">Logged in as: {user?.email || 'Unknown'}</span></li>
                <li><hr className="dropdown-divider" /></li>
                <li>
                  <button 
                    className="dropdown-item" 
                    onClick={handleLogoutClick}
                  >
                    <i className="bi bi-box-arrow-right me-2"></i>
                    Logout
                  </button>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </nav>

      {/* Logout Modal */}
      {showLogoutModal && (
        <div className="modal fade show d-block" tabIndex="-1">
          <div className="modal-backdrop-blur"></div>
          <div className="modal-dialog modal-dialog-centered">
            <div className="modal-content">
              <div className="modal-header">
                <h5 className="modal-title">Confirm Logout</h5>
                <button 
                  type="button" 
                  className="btn-close" 
                  onClick={handleLogoutCancel}
                ></button>
              </div>
              <div className="modal-body">
                <p>Are you sure you want to log out?</p>
              </div>
              <div className="modal-footer">
                <button 
                  type="button" 
                  className="btn btn-secondary" 
                  onClick={handleLogoutCancel}
                  disabled={loggingOut}
                >
                  Cancel
                </button>
                <button 
                  type="button" 
                  className="btn btn-primary" 
                  onClick={handleLogoutConfirm}
                  disabled={loggingOut}
                >
                  {loggingOut ? 'Logging out...' : 'Logout'}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default Header;
