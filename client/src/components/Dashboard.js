import React, { useState, useEffect } from 'react';
import axios from 'axios';
import Header from './Header';

const Dashboard = ({ user, onLogout, onMemberClick, onNavigate }) => {
  const [dashboardStats, setDashboardStats] = useState({
    due_today_count: 0,
    high_priority_count: 0,
    reminders_count: 0,
    start_this_week_count: 0
  });
  const [authorizations, setAuthorizations] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Fetch dashboard data on component mount
  useEffect(() => {
    const abortController = new AbortController();
    
    const loadData = async () => {
      await fetchDashboardData(abortController.signal);
    };
    
    loadData();
    
    return () => {
      abortController.abort();
    };
  }, []);

  const fetchDashboardData = async (signal) => {
    try {
      setLoading(true);
      const token = localStorage.getItem('token');
      
      // Fetch dashboard statistics
      const statsResponse = await axios.get('http://localhost:5000/api/dashboard/stats', {
        headers: { 'Authorization': `Bearer ${token}` },
        signal
      });
      setDashboardStats(statsResponse.data);

      // Fetch authorizations for the table
      const authResponse = await axios.get('http://localhost:5000/api/dashboard/authorizations?limit=50', {
        headers: { 'Authorization': `Bearer ${token}` },
        signal
      });
      setAuthorizations(authResponse.data.data);

    } catch (error) {
      if (error.name === 'AbortError') {
        console.log('Request was cancelled');
        return;
      }
      console.error('Error fetching dashboard data:', error);
      setError('Failed to load dashboard data');
    } finally {
      setLoading(false);
    }
  };

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      month: '2-digit',
      day: '2-digit',
      year: 'numeric'
    });
  };

  const formatDateTime = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleString('en-US', {
      month: '2-digit',
      day: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      hour12: true
    });
  };

  const getCurrentDate = () => {
    const now = new Date();
    return now.toLocaleDateString('en-US', {
      weekday: 'long',
      month: 'long',
      day: 'numeric'
    });
  };

  const getCurrentDateTime = () => {
    const now = new Date();
    return now.toLocaleString('en-US', {
      weekday: 'long',
      month: 'long',
      day: 'numeric',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      hour12: true
    });
  };

  const getBadgeColor = (diagnosis) => {
    const colors = {
      'DKA': '#28a745',
      'CHF': '#28a745', 
      'CKD': '#28a745',
      'COPD': '#28a745',
      'UTI': '#28a745',
      'Cellulitis': '#28a745'
    };
    return colors[diagnosis] || '#28a745';
  };

  const getStatusBadgeClass = (status) => {
    const classes = {
      'Pending': 'badge-status-pending',
      'In Review': 'badge-status-review',
      'Appeal': 'badge-status-appeal',
      'Approved': 'badge bg-success',
      'Denied': 'badge bg-danger'
    };
    return classes[status] || 'badge bg-secondary';
  };
  
  const handleRowClick = (authorization) => {
    if (onMemberClick) {
      // Create member data from authorization info
      const memberData = {
        id: authorization.member_id || authorization.id,
        name: authorization.member_name || 'Robert Abbott',
        memberNumber: authorization.member_number || 'M1000020000',
        authorizationNumber: authorization.authorization_number,
        status: authorization.status,
        priority: authorization.priority,
        provider: authorization.provider_name,
        diagnosis: authorization.diagnosis_code,
        requestDate: authorization.received_date,
        admissionDate: authorization.admission_date
      };
      onMemberClick(memberData);
    }
  };

  return (
    <div className="min-vh-100" style={{backgroundColor: '#f8f9fa'}}>
      <Header user={user} onLogout={onLogout} onNavigate={onNavigate} activeTab="Dashboard" />

      {/* Dashboard Content */}
      <div className="container-fluid py-4">
        <div className="d-flex justify-content-between align-items-center dashboard-header">
          <h2 className="mb-0 fw-bold">UM Dashboard</h2>
          <h5 className="mb-0 text-muted fw-normal">{getCurrentDate()}</h5>
        </div>

        {/* Tab Navigation */}
        <div className="mb-4">
          <ul className="nav nav-tabs">
            <li className="nav-item">
              <a className="nav-link active" href="#">My Tasks</a>
            </li>
            <li className="nav-item">
              <a className="nav-link" href="#">My Cases</a>
            </li>
            <li className="nav-item">
              <a className="nav-link" href="#">Risk Stratification</a>
            </li>
          </ul>
        </div>
        
        {/* Loading State */}
        {loading && (
          <div className="text-center py-5">
            <div className="spinner-border text-primary" role="status">
              <span className="visually-hidden">Loading...</span>
            </div>
          </div>
        )}

        {/* Error State */}
        {error && (
          <div className="alert alert-danger" role="alert">
            <i className="bi bi-exclamation-triangle me-2"></i>
            {error}
            <button 
              className="btn btn-outline-danger btn-sm ms-3"
              onClick={() => fetchDashboardData()}
            >
              Retry
            </button>
          </div>
        )}

        {/* Stats Cards Row */}
        {!loading && !error && (
          <div className="row mb-4">
            <div className="col-lg-3 col-md-6 mb-3">
              <div className="card text-white summary-card due-today-card">
                <div className="card-body d-flex align-items-center">
                  <div className="me-3">
                    <i className="bi bi-calendar-check" style={{fontSize: '2.5rem'}}></i>
                  </div>
                  <div>
                    <h2 className="card-title mb-1">{dashboardStats.due_today_count || 0}</h2>
                    <p className="card-text mb-0">Due Today</p>
                  </div>
                </div>
              </div>
            </div>
            <div className="col-lg-3 col-md-6 mb-3">
              <div className="card text-white summary-card high-priority-card">
                <div className="card-body d-flex align-items-center">
                  <div className="me-3">
                    <i className="bi bi-exclamation-triangle" style={{fontSize: '2.5rem'}}></i>
                  </div>
                  <div>
                    <h2 className="card-title mb-1">{dashboardStats.high_priority_count || 0}</h2>
                    <p className="card-text mb-0">High Priority</p>
                  </div>
                </div>
              </div>
            </div>
            <div className="col-lg-3 col-md-6 mb-3">
              <div className="card summary-card bg-light">
                <div className="card-body d-flex align-items-center">
                  <div className="me-3">
                    <i className="bi bi-bell text-muted" style={{fontSize: '2.5rem'}}></i>
                  </div>
                  <div>
                    <h2 className="card-title mb-1 text-dark">{dashboardStats.reminders_count || 0}</h2>
                    <p className="card-text mb-0 text-muted">Reminder for Today</p>
                  </div>
                </div>
              </div>
            </div>
            <div className="col-lg-3 col-md-6 mb-3">
              <div className="card summary-card bg-light">
                <div className="card-body d-flex align-items-center">
                  <div className="me-3">
                    <i className="bi bi-calendar-week text-muted" style={{fontSize: '2.5rem'}}></i>
                  </div>
                  <div>
                    <h2 className="card-title mb-1 text-dark">{dashboardStats.start_this_week_count || 0}</h2>
                    <p className="card-text mb-0 text-muted">Start this Week</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Task Table Section */}
        {!loading && !error && (
          <div className="card dashboard-card">
            <div className="card-header d-flex justify-content-between align-items-center">
              <div className="d-flex align-items-center">
                <h5 className="mb-0 me-2">Inpatient Tasks - Due Today ({dashboardStats.due_today_count || 0})</h5>
                <i className="bi bi-box-arrow-up-right text-muted"></i>
              </div>
              <small className="text-muted">Last Updated: {getCurrentDateTime()} <i className="bi bi-arrow-clockwise text-success"></i></small>
            </div>
            <div className="card-body p-0">
              <div className="table-responsive">
                <table className="table table-hover mb-0">
                  <thead className="table-light">
                    <tr>
                      <th style={{width: '40px'}}></th>
                      <th>Priority <i className="bi bi-caret-down-fill small"></i></th>
                      <th>Authorization #</th>
                      <th>Received Date</th>
                      <th>Admission Date</th>
                      <th>Diagnosis</th>
                      <th>DRG</th>
                      <th>POS</th>
                      <th>Type</th>
                      <th>Member Name</th>
                      <th>Approved Days</th>
                      <th>Next Review Date</th>
                      <th>Status</th>
                      <th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {authorizations.length === 0 ? (
                      <tr>
                        <td colSpan="14" className="text-center py-4">
                          <div className="text-muted">
                            <i className="bi bi-inbox fs-1 d-block mb-2"></i>
                            <p className="mb-0">No authorizations found</p>
                            <small>Try refreshing the page or check back later</small>
                          </div>
                        </td>
                      </tr>
                    ) : (
                      authorizations.map((auth, index) => (
                        <tr key={auth.id} className={index === 0 ? "selected" : ""} onClick={() => handleRowClick(auth)}>
                          <td className="cell-indicator">
                            {index === 0 && <i className="bi bi-play-fill text-primary"></i>}
                          </td>
                          <td className={`cell-priority priority-cell priority-${auth.priority?.toLowerCase() || 'medium'}`}>
                            <span className={`badge badge-priority-${auth.priority?.toLowerCase() || 'medium'}`}>
                              {auth.priority || 'Medium'}
                            </span>
                          </td>
                          <td className="cell-authorization-number">
                            <a href="#" className="text-decoration-none">
                              {auth.authorization_number || 'N/A'}
                            </a>
                          </td>
                          <td className="cell-received-date">
                            <small>{auth.received_date ? formatDateTime(auth.received_date) : 'N/A'}</small>
                          </td>
                          <td className="cell-admission-date">
                            <small>{auth.admission_date ? formatDate(auth.admission_date) : 'N/A'}</small>
                          </td>
                          <td className="cell-diagnosis">
                            <span 
                              className="badge" 
                              style={{backgroundColor: getBadgeColor(auth.diagnosis_code), color: 'white'}}
                            >
                              {auth.diagnosis_code || 'N/A'}
                            </span>
                          </td>
                          <td className="cell-drg-code">{auth.drg_code || 'N/A'}</td>
                          <td className="cell-provider">
                            <span className="badge" style={{backgroundColor: '#17a2b8', color: 'white'}}>
                              {auth.provider_name || 'Unknown'}
                            </span>
                          </td>
                          <td className="cell-review-type">
                            <span className="badge" style={{backgroundColor: '#6c757d', color: 'white'}}>
                              {auth.review_type || 'Standard'}
                            </span>
                          </td>
                          <td className="cell-member-name">{auth.member_name || 'N/A'}</td>
                          <td className="cell-approved-days">{auth.approved_days || '0'}</td>
                          <td className="cell-next-review-date">
                            <small>{auth.next_review_date ? formatDateTime(auth.next_review_date) : 'N/A'}</small>
                          </td>
                          <td className="cell-status">
                            <span className={`badge ${getStatusBadgeClass(auth.status)}`}>
                              {auth.status || 'Pending'}
                            </span>
                          </td>
                          <td className="cell-action">
                            <i className="bi bi-three-dots action-dots"></i>
                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </div>
              
              {/* Pagination */}
              <div className="d-flex justify-content-between align-items-center p-3 border-top">
                <div className="d-flex align-items-center">
                  <select className="form-select form-select-sm" style={{width: 'auto'}}>
                    <option>10 per page</option>
                    <option>25 per page</option>
                    <option>50 per page</option>
                  </select>
                </div>
                <nav>
                  <ul className="pagination pagination-sm mb-0">
                    <li className="page-item disabled">
                      <a className="page-link" href="#"><i className="bi bi-chevron-left"></i></a>
                    </li>
                    <li className="page-item active">
                      <a className="page-link" href="#">1</a>
                    </li>
                    <li className="page-item">
                      <a className="page-link" href="#">2</a>
                    </li>
                    <li className="page-item disabled">
                      <a className="page-link" href="#">...</a>
                    </li>
                    <li className="page-item">
                      <a className="page-link" href="#">8</a>
                    </li>
                    <li className="page-item">
                      <a className="page-link" href="#">9</a>
                    </li>
                    <li className="page-item">
                      <a className="page-link" href="#"><i className="bi bi-chevron-right"></i></a>
                    </li>
                  </ul>
                </nav>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default Dashboard;
