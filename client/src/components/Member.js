import React, { useState } from 'react';
import Header from './Header';

const Member = ({ user, memberData: propMemberData, onLogout, onBack, onNavigate }) => {
  const [activeTab, setActiveTab] = useState('Authorizations');
  const [activeAuthTab, setActiveAuthTab] = useState('Clinical Review');
  const [activeRequestTab, setActiveRequestTab] = useState('20250P000367');

  // Use prop data if available, otherwise use static demo data
  const memberData = propMemberData || {
    id: 'M001234',
    name: 'Robert Abbott',
    memberNumber: 'M1000020000',
    dateOfBirth: '1985-03-15',
    gender: 'Female',
    insuranceGroup: 'BCBS Premium',
    effectiveDate: '2024-01-01',
    status: 'Active',
    phone: '(555) 123-4567',
    email: 'sarah.johnson@email.com',
    address: '123 Main St, Springfield, IL 62701',
    primaryCarePhysician: 'Dr. Michael Chen',
    emergencyContact: 'John Johnson (Spouse) - (555) 987-6543'
  };

  // Static authorization data for overview
  const recentAuthorizations = [
    {
      id: 1,
      authNumber: 'AUTH-2024-001',
      status: 'Approved',
      service: 'Cardiac Catheterization',
      provider: 'Springfield Medical Center',
      requestDate: '2024-05-15',
      approvedDays: 3,
      priority: 'High'
    },
    {
      id: 2,
      authNumber: 'AUTH-2024-002',
      status: 'Pending',
      service: 'Physical Therapy',
      provider: 'Rehab Solutions',
      requestDate: '2024-05-20',
      approvedDays: null,
      priority: 'Medium'
    },
    {
      id: 3,
      authNumber: 'AUTH-2024-003',
      status: 'In Review',
      service: 'MRI - Brain',
      provider: 'Diagnostic Imaging Inc',
      requestDate: '2024-05-25',
      approvedDays: null,
      priority: 'High'
    }
  ];

  const getStatusBadgeClass = (status) => {
    switch (status?.toLowerCase()) {
      case 'approved': return 'bg-success';
      case 'pending': return 'bg-warning';
      case 'in review': return 'bg-info';
      case 'denied': return 'bg-danger';
      default: return 'bg-secondary';
    }
  };

  const getPriorityBadgeClass = (priority) => {
    switch (priority?.toLowerCase()) {
      case 'high': return 'bg-danger';
      case 'medium': return 'bg-warning';
      case 'low': return 'bg-success';
      default: return 'bg-secondary';
    }
  };

  // Define the tabs
  const tabs = ['Overview', 'Eligibility & Benefits', 'Care Plans', 'Discharge Plans', 'Concierge Care', 'Authorizations', 'Notes', 'Medications', 'Cases', 'Assessments'];

  // Define request history tabs
  const requestTabs = [
    { id: 'Request History', label: 'Request History' },
    { id: '20250P000367', label: '20250P000367' }
  ];

  // Define authorization sub-tabs
  const authTabs = [
    { id: 'Request Submitted', label: 'Request Submitted', status: 'completed' },
    { id: 'Clinical Review', label: 'Clinical Review', status: 'active' },
    { id: 'Request Decision Appeal', label: 'Request Decision Appeal', status: 'pending' },
    { id: 'MD Review', label: 'MD Review', status: 'pending' },
    { id: 'Concurrent Review', label: 'Concurrent Review', status: 'pending' },
    { id: 'Closed', label: 'Closed', status: 'pending' }
  ];

  return (
    <div className="min-vh-100" style={{backgroundColor: '#f8f9fa'}}>
      <Header user={user} onLogout={onLogout} onNavigate={onNavigate} activeTab="Members" />

      {/* Main Content */}
      <div className="main-content">
        {/* Member Header */}
        <div className="member-header bg-white border-bottom">
          <div className="container-fluid">
            <div className="row align-items-center py-3">
              <div className="col">
                <div className="d-flex align-items-center justify-content-between">
                  <div className="d-flex align-items-center">
                    <h3 className="mb-0 me-3" style={{fontWeight: '600', fontSize: '24px'}}>
                      Member Overview: {memberData.name}
                    </h3>
                  </div>
                  <div className="d-flex align-items-center">
                    <i className="bi bi-star text-warning me-3" style={{fontSize: '20px', cursor: 'pointer'}} title="Favorite"></i>
                    <i className="bi bi-telephone me-3" style={{fontSize: '20px', cursor: 'pointer'}} title="Call"></i>
                    <i className="bi bi-printer me-3" style={{fontSize: '20px', cursor: 'pointer'}} title="Print"></i>
                    <i className="bi bi-envelope me-3" style={{fontSize: '20px', cursor: 'pointer'}} title="Email"></i>
                    <i className="bi bi-clock me-3" style={{fontSize: '20px', cursor: 'pointer'}} title="History"></i>
                    <i className="bi bi-shield-check" style={{fontSize: '20px', cursor: 'pointer', color: '#007bff'}} title="Secure"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Member Info Bar */}
        <div className="member-info-bar bg-light border-bottom" style={{borderTop: '3px solid #e9ecef'}}>
          <div className="container-fluid">
            <div className="row py-3 align-items-center">
              <div className="col-md-2">
                <div className="d-flex align-items-center">
                  <div className="member-avatar bg-success text-white rounded-circle d-flex align-items-center justify-content-center me-3" style={{width: '48px', height: '48px', fontSize: '20px'}}>
                    <i className="bi bi-person-fill"></i>
                  </div>
                  <div>
                    <div className="fw-bold" style={{fontSize: '16px', color: '#333'}}>{memberData.name}</div>
                    <small className="text-muted" style={{fontSize: '12px'}}>01/01/1974, 51 Years, Male</small>
                  </div>
                </div>
              </div>
              <div className="col-md-2">
                <div>
                  <small className="text-muted d-block fw-semibold" style={{fontSize: '11px', textTransform: 'uppercase', letterSpacing: '0.5px'}}>Eligibility</small>
                  <span style={{fontSize: '14px', fontWeight: '500'}}>10/01/2024-12/31/2025</span>
                </div>
              </div>
              <div className="col-md-1">
                <div>
                  <small className="text-muted d-block fw-semibold" style={{fontSize: '11px', textTransform: 'uppercase', letterSpacing: '0.5px'}}>MRN</small>
                  <span style={{fontSize: '14px', fontWeight: '500'}}>{memberData.memberNumber}</span>
                </div>
              </div>
              <div className="col-md-2">
                <div>
                  <small className="text-muted d-block fw-semibold" style={{fontSize: '11px', textTransform: 'uppercase', letterSpacing: '0.5px'}}>Language (1st)</small>
                  <span style={{fontSize: '14px', fontWeight: '500'}}>English</span>
                </div>
              </div>
              <div className="col-md-2">
                <div>
                  <small className="text-muted d-block fw-semibold" style={{fontSize: '11px', textTransform: 'uppercase', letterSpacing: '0.5px'}}>Programs</small>
                  <span style={{fontSize: '14px', fontWeight: '500'}}>Care Coordination: ERM PH</span>
                </div>
              </div>
              <div className="col-md-1">
                <div>
                  <small className="text-muted d-block fw-semibold" style={{fontSize: '11px', textTransform: 'uppercase', letterSpacing: '0.5px'}}>BHP</small>
                  <span style={{fontSize: '14px', fontWeight: '500'}}>Large Group</span>
                </div>
              </div>
              <div className="col-md-2">
                <div>
                  <small className="text-muted d-block fw-semibold" style={{fontSize: '11px', textTransform: 'uppercase', letterSpacing: '0.5px'}}>Opt out</small>
                  <span style={{fontSize: '14px', fontWeight: '500'}}>No</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Tab Navigation */}
        <div className="member-tabs border-bottom">
          <div className="container-fluid">
            <ul className="nav nav-tabs border-0" style={{marginBottom: '-1px'}}>
              {tabs.map((tab, index) => (
                <li className="nav-item" key={index}>
                  <button 
                    className={`nav-link ${activeTab === tab ? 'active' : ''}`}
                    onClick={() => setActiveTab(tab)}
                    style={{
                      border: 'none',
                      borderBottom: activeTab === tab ? '3px solid #007bff' : '3px solid transparent',
                      color: activeTab === tab ? '#007bff' : '#6c757d',
                      backgroundColor: 'transparent'
                    }}
                  >
                    {tab}
                  </button>
                </li>
              ))}
            </ul>
          </div>
        </div>

        {/* Tab Content */}
        <div className="tab-content bg-white">
          <div className="container-fluid py-4">
            {activeTab === 'Overview' && (
              <div className="row">
                <div className="col-12">
                  <div className="card border-0 shadow-sm">
                    <div className="card-body">
                      <h5 className="card-title mb-4">Member Overview</h5>
                      <div className="row">
                        <div className="col-md-6">
                          <h6 className="text-muted mb-3">Personal Information</h6>
                          <table className="table table-sm">
                            <tbody>
                              <tr>
                                <td className="fw-bold">Full Name:</td>
                                <td>Robert Abbott</td>
                              </tr>
                              <tr>
                                <td className="fw-bold">Date of Birth:</td>
                                <td>01/01/1974 (51 Years)</td>
                              </tr>
                              <tr>
                                <td className="fw-bold">Gender:</td>
                                <td>Male</td>
                              </tr>
                              <tr>
                                <td className="fw-bold">MRN:</td>
                                <td>M1000020000</td>
                              </tr>
                              <tr>
                                <td className="fw-bold">Primary Language:</td>
                                <td>English</td>
                              </tr>
                            </tbody>
                          </table>
                        </div>
                        <div className="col-md-6">
                          <h6 className="text-muted mb-3">Coverage Information</h6>
                          <table className="table table-sm">
                            <tbody>
                              <tr>
                                <td className="fw-bold">Eligibility Period:</td>
                                <td>10/01/2024 - 12/31/2025</td>
                              </tr>
                              <tr>
                                <td className="fw-bold">Plan Type:</td>
                                <td>Large Group</td>
                              </tr>
                              <tr>
                                <td className="fw-bold">Programs:</td>
                                <td>Care Coordination: ERM PH</td>
                              </tr>
                              <tr>
                                <td className="fw-bold">Opt Out Status:</td>
                                <td><span className="badge bg-success">No</span></td>
                              </tr>
                            </tbody>
                          </table>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            )}

            {activeTab === 'Authorizations' && (
              <div className="row">
                <div className="col-12">
                  {/* Request Tabs */}
                  <div className="card border-0 shadow-sm mb-4">
                    <div className="card-body">
                      {/* Request Tabs Navigation */}
                      <div className="request-tabs mb-4">
                        <div className="d-flex align-items-center justify-content-between mb-3">
                          <h6 className="mb-0 text-muted fw-semibold">Authorization Requests</h6>
                          <span className="badge bg-light text-dark">
                            <i className="bi bi-folder me-1"></i>
                            {requestTabs.length} Requests
                          </span>
                        </div>
                        <ul className="nav nav-tabs" style={{
                          borderBottom: '2px solid #e9ecef',
                          background: 'linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%)',
                          padding: '8px 12px',
                          borderRadius: '12px 12px 0 0',
                          boxShadow: '0 2px 4px rgba(0,0,0,0.05)'
                        }}>
                          {requestTabs.map((requestTab, index) => (
                            <li className="nav-item" key={requestTab.id}>
                              <button
                                className={`nav-link ${activeRequestTab === requestTab.id ? 'active' : ''}`}
                                onClick={() => setActiveRequestTab(requestTab.id)}
                                style={{
                                  border: 'none',
                                  borderRadius: '8px 8px 0 0',
                                  fontSize: '13px',
                                  fontWeight: '600',
                                  padding: '12px 20px',
                                  margin: '0 4px',
                                  backgroundColor: activeRequestTab === requestTab.id ? '#007bff' : 'transparent',
                                  color: activeRequestTab === requestTab.id ? 'white' : '#495057',
                                  transition: 'all 0.3s ease',
                                  position: 'relative',
                                  boxShadow: activeRequestTab === requestTab.id ? '0 4px 8px rgba(0,123,255,0.3)' : 'none',
                                  transform: activeRequestTab === requestTab.id ? 'translateY(-2px)' : 'none'
                                }}
                                onMouseEnter={(e) => {
                                  if (activeRequestTab !== requestTab.id) {
                                    e.target.style.backgroundColor = '#e9ecef';
                                    e.target.style.color = '#343a40';
                                    e.target.style.transform = 'translateY(-1px)';
                                  }
                                }}
                                onMouseLeave={(e) => {
                                  if (activeRequestTab !== requestTab.id) {
                                    e.target.style.backgroundColor = 'transparent';
                                    e.target.style.color = '#495057';
                                    e.target.style.transform = 'none';
                                  }
                                }}
                              >
                                {index === 0 && <i className="bi bi-clock-history me-2"></i>}
                                {index === 1 && (
                                  <>
                                    <i className="bi bi-file-earmark-check me-2"></i>
                                    {activeRequestTab === requestTab.id && (
                                      <span className="badge bg-light text-success me-2" style={{fontSize: '10px', padding: '2px 6px'}}>
                                        ACTIVE
                                      </span>
                                    )}
                                  </>
                                )}
                                <span>
                                  {requestTab.label}
                                </span>
                                {activeRequestTab === requestTab.id && (
                                  <div style={{
                                    position: 'absolute',
                                    bottom: '-2px',
                                    left: '50%',
                                    transform: 'translateX(-50%)',
                                    width: '8px',
                                    height: '4px',
                                    backgroundColor: '#007bff',
                                    borderRadius: '2px 2px 0 0'
                                  }}></div>
                                )}
                              </button>
                            </li>
                          ))}
                        </ul>
                      </div>
                      
                      {/* Request Tab Content */}
                      {activeRequestTab === 'Request History' && (
                        <div className="request-history-content">
                          <div className="d-flex align-items-center mb-4">
                            <div className="bg-primary bg-opacity-10 p-3 rounded-circle me-3">
                              <i className="bi bi-clock-history text-primary" style={{fontSize: '20px'}}></i>
                            </div>
                            <div>
                              <h5 className="mb-1">Authorization Request History</h5>
                              <p className="text-muted mb-0">Complete history of all authorization requests for this member</p>
                            </div>
                          </div>
                          <div className="table-responsive" style={{
                            borderRadius: '12px',
                            overflow: 'hidden',
                            boxShadow: '0 4px 6px rgba(0,0,0,0.07)'
                          }}>
                            <table className="table table-hover mb-0">
                              <thead style={{background: 'linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%)'}}>
                                <tr>
                                  <th style={{borderBottom: '2px solid #dee2e6', fontWeight: '600', fontSize: '13px', color: '#495057'}}>Request ID</th>
                                  <th style={{borderBottom: '2px solid #dee2e6', fontWeight: '600', fontSize: '13px', color: '#495057'}}>Service</th>
                                  <th style={{borderBottom: '2px solid #dee2e6', fontWeight: '600', fontSize: '13px', color: '#495057'}}>Provider</th>
                                  <th style={{borderBottom: '2px solid #dee2e6', fontWeight: '600', fontSize: '13px', color: '#495057'}}>Request Date</th>
                                  <th style={{borderBottom: '2px solid #dee2e6', fontWeight: '600', fontSize: '13px', color: '#495057'}}>Status</th>
                                  <th style={{borderBottom: '2px solid #dee2e6', fontWeight: '600', fontSize: '13px', color: '#495057'}}>Priority</th>
                                  <th style={{borderBottom: '2px solid #dee2e6', fontWeight: '600', fontSize: '13px', color: '#495057'}}>Action</th>
                                </tr>
                              </thead>
                              <tbody>
                                {recentAuthorizations.map((auth) => (
                                  <tr key={auth.id}>
                                    <td className="fw-semibold text-primary" style={{cursor: 'pointer'}} 
                                        onClick={() => setActiveRequestTab('20250P000367')}>
                                      {auth.authNumber}
                                    </td>
                                    <td>{auth.service}</td>
                                    <td>{auth.provider}</td>
                                    <td>{auth.requestDate}</td>
                                    <td>
                                      <span className={`badge ${getStatusBadgeClass(auth.status)}`}>
                                        {auth.status}
                                      </span>
                                    </td>
                                    <td>
                                      <span className={`badge ${getPriorityBadgeClass(auth.priority)}`}>
                                        {auth.priority}
                                      </span>
                                    </td>
                                    <td>
                                      <button 
                                        className="btn btn-sm btn-outline-primary"
                                        onClick={() => setActiveRequestTab('20250P000367')}
                                      >
                                        View Details
                                      </button>
                                    </td>
                                  </tr>
                                ))}
                              </tbody>
                            </table>
                          </div>
                        </div>
                      )}

                      {activeRequestTab === '20250P000367' && (
                        <div className="request-detail-content">
                          {/* Header Section */}
                          <div className="request-header-card mb-3" style={{
                            background: '#f8f9fa',
                            borderRadius: '8px',
                            padding: '12px 16px',
                            color: '#495057',
                            border: '1px solid #dee2e6'
                          }}>
                            <div className="d-flex justify-content-between align-items-start">
                              <div className="w-100">
                                <div className="row align-items-center">
                                  <div className="col-md-3">
                                    <h5 className="mb-0 fw-bold">Authorization Request</h5>
                                    <small className="text-muted fw-semibold">ID: 20250P000367</small>
                                  </div>
                                  <div className="col-md-3">
                                    <small className="text-muted">Request Type</small>
                                    <p className="mb-0 fw-semibold small">Inpatient Authorization</p>
                                  </div>
                                  <div className="col-md-3">
                                    <small className="text-muted">Submitted Date</small>
                                    <p className="mb-0 fw-semibold small">May 15, 2024</p>
                                  </div>
                                  <div className="col-md-3">
                                    <small className="text-muted">Current Status</small>
                                    <div className="d-flex align-items-center">
                                      <span className="badge bg-warning" style={{fontSize: '0.75rem'}}>
                                        <i className="bi bi-clock me-1"></i>
                                        In Review
                                      </span>
                                    </div>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                        
                          {/* Authorization Sub-tabs */}
                          <div className="authorization-subtabs mb-4">
                            <h6 className="text-muted mb-3 fw-semibold">
                              <i className="bi bi-diagram-3 me-2"></i>
                              Authorization Workflow Progress
                            </h6>
                            <div className="workflow-container" style={{
                              background: '#f8f9fa',
                              borderRadius: '12px',
                              padding: '20px',
                              boxShadow: '0 2px 4px rgba(0,0,0,0.05)'
                            }}>
                              <div className="d-flex align-items-center justify-content-start overflow-auto">
                                {authTabs.map((authTab, index) => (
                                  <div key={authTab.id} className="d-flex align-items-center">
                                    <div className="text-center">
                                      <button
                                        className={`auth-step-btn ${authTab.status === 'completed' ? 'completed' : ''} ${authTab.status === 'active' || activeAuthTab === authTab.id ? 'active' : ''}`}
                                        onClick={() => setActiveAuthTab(authTab.id)}
                                        style={{
                                          background: authTab.status === 'completed' ? '#28a745' : 
                                                     (authTab.status === 'active' || activeAuthTab === authTab.id) ? '#007bff' : '#e9ecef',
                                          color: authTab.status === 'completed' || authTab.status === 'active' || activeAuthTab === authTab.id ? 'white' : '#6c757d',
                                          border: authTab.status === 'completed' || authTab.status === 'active' || activeAuthTab === authTab.id ? 
                                                 '3px solid rgba(255,255,255,0.3)' : '3px solid transparent',
                                          padding: '12px 18px',
                                          borderRadius: '25px',
                                          fontSize: '13px',
                                          fontWeight: '600',
                                          cursor: 'pointer',
                                          transition: 'all 0.3s ease',
                                          whiteSpace: 'nowrap',
                                          boxShadow: authTab.status === 'completed' || authTab.status === 'active' || activeAuthTab === authTab.id ? 
                                                    '0 4px 8px rgba(0,0,0,0.2)' : '0 2px 4px rgba(0,0,0,0.1)',
                                          transform: activeAuthTab === authTab.id ? 'scale(1.05)' : 'scale(1)'
                                        }}
                                        onMouseEnter={(e) => {
                                          if (authTab.status === 'pending') {
                                            e.target.style.background = '#dee2e6';
                                            e.target.style.transform = 'scale(1.02)';
                                          }
                                        }}
                                        onMouseLeave={(e) => {
                                          if (authTab.status === 'pending') {
                                            e.target.style.background = '#e9ecef';
                                            e.target.style.transform = 'scale(1)';
                                          }
                                        }}
                                      >
                                        {authTab.status === 'completed' && <i className="bi bi-check-circle me-2"></i>}
                                        {authTab.status === 'active' && <i className="bi bi-play-circle me-2"></i>}
                                        {authTab.status === 'pending' && <i className="bi bi-circle me-2"></i>}
                                        {authTab.label}
                                      </button>
                                      <small className="d-block mt-2 text-muted">
                                        {authTab.status === 'completed' && 'Completed'}
                                        {authTab.status === 'active' && 'In Progress'}
                                        {authTab.status === 'pending' && 'Pending'}
                                      </small>
                                    </div>
                                    {index < authTabs.length - 1 && (
                                      <div 
                                        className="auth-step-line mx-3"
                                        style={{
                                          width: '30px',
                                          height: '3px',
                                          background: authTab.status === 'completed' ? '#28a745' : '#dee2e6',
                                          borderRadius: '2px',
                                          position: 'relative'
                                        }}
                                      >
                                        {authTab.status === 'completed' && (
                                          <div style={{
                                            position: 'absolute',
                                            top: '50%',
                                            right: '-5px',
                                            transform: 'translateY(-50%)',
                                            width: '0',
                                            height: '0',
                                            borderLeft: '8px solid #28a745',
                                            borderTop: '5px solid transparent',
                                            borderBottom: '5px solid transparent'
                                          }}></div>
                                        )}
                                      </div>
                                    )}
                                  </div>
                                ))}
                              </div>
                            </div>
                          </div>

                          {/* Tab Content Based on Active Auth Tab */}
                          <div className="auth-tab-content">
                            {activeAuthTab === 'Request Submitted' && (
                              <div className="request-submitted-content">
                                <h5 className="mb-3">Request Submitted</h5>
                                <p>The authorization request has been submitted and is pending review.</p>
                                <div className="row">
                                  <div className="col-md-6">
                                    <strong>Submission Date:</strong> May 15, 2024<br/>
                                    <strong>Request Type:</strong> Inpatient Authorization<br/>
                                    <strong>Priority:</strong> High
                                  </div>
                                </div>
                              </div>
                            )}

                            {activeAuthTab === 'Clinical Review' && (
                              <div className="clinical-review-content">
                                {/* Medical Necessity Guidelines */}
                                <div className="row">
                                  <div className="col-md-2">
                                    <div className="medical-necessity-icon">
                                      <div className="bg-warning text-white p-3 rounded d-flex align-items-center justify-content-center" style={{width: '80px', height: '80px'}}>
                                        <i className="bi bi-shield-check" style={{fontSize: '24px'}}></i>
                                      </div>
                                      <div className="mt-2 text-center">
                                        <div className="fw-bold" style={{fontSize: '12px', lineHeight: '1.2'}}>Medical</div>
                                        <div className="fw-bold" style={{fontSize: '12px', lineHeight: '1.2'}}>Necessity</div>
                                        <div className="fw-bold" style={{fontSize: '12px', lineHeight: '1.2'}}>Guidelines</div>
                                      </div>
                                    </div>
                                  </div>
                                  <div className="col-md-10">
                                    <div className="informed-care-section">
                                      <h6 className="text-muted mb-3">Informed Care Strategies</h6>
                                      <div className="d-flex flex-wrap gap-3 mb-4">
                                        <a href="#" className="text-decoration-none small">LOG OUT</a>
                                        <span className="text-muted">|</span>
                                        <a href="#" className="text-decoration-none small">SEARCH</a>
                                        <span className="text-muted">|</span>
                                        <a href="#" className="text-decoration-none small">MY PRODUCTS</a>
                                        <span className="text-muted">|</span>
                                        <a href="#" className="text-decoration-none small">CONTACT US</a>
                                        <span className="text-muted">|</span>
                                        <a href="#" className="text-decoration-none small">USER GUIDE</a>
                                      </div>
                                      
                                      <div className="guidelines-content">
                                        <h5 className="mb-3">Goal Length of Stay: 2 Days</h5>
                                        <h6 className="mb-3">Brief Stay (1 to 3 Days) – Target LOS: 2 Days</h6>
                                        
                                        <ul className="list-unstyled">
                                          <li className="mb-2">• Initial stabilization within first 12–24 hours</li>
                                          <li className="mb-2">• Transition from IV insulin to subcutaneous insulin regimen on Day 2</li>
                                          <li className="mb-2">• Correction of:</li>
                                          <li className="mb-2 ms-3">• Acidosis</li>
                                          <li className="mb-2 ms-3">• Ketosis</li>
                                          <li className="mb-2 ms-3">• Electrolyte imbalances</li>
                                          <li className="mb-2">• Nutritional intake established with adequate PO hydration</li>
                                          <li className="mb-2">• Ongoing monitoring of labs and vitals for stability</li>
                                          <li className="mb-2">• Diabetes education and discharge planning initiated:</li>
                                          <li className="mb-2 ms-3">• Insulin use, glucose monitoring</li>
                                          <li className="mb-2 ms-3">• Sick-day management</li>
                                        </ul>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                              </div>
                            )}

                            {activeAuthTab === 'Request Decision Appeal' && (
                              <div className="appeal-content">
                                <h5 className="mb-3">Request Decision Appeal</h5>
                                <p>Appeal process for authorization decisions.</p>
                                <div className="alert alert-info">
                                  <i className="bi bi-info-circle me-2"></i>
                                  Appeal information will be displayed here when available.
                                </div>
                              </div>
                            )}

                            {activeAuthTab === 'MD Review' && (
                              <div className="md-review-content">
                                <h5 className="mb-3">MD Review</h5>
                                <p>Medical Director review process.</p>
                                <div className="alert alert-warning">
                                  <i className="bi bi-clock me-2"></i>
                                  Pending MD review assignment.
                                </div>
                              </div>
                            )}

                            {activeAuthTab === 'Concurrent Review' && (
                              <div className="concurrent-review-content">
                                <h5 className="mb-3">Concurrent Review</h5>
                                <p>Ongoing concurrent review and monitoring.</p>
                                <div className="alert alert-secondary">
                                  <i className="bi bi-eye me-2"></i>
                                  Concurrent review not yet initiated.
                                </div>
                              </div>
                            )}

                            {activeAuthTab === 'Closed' && (
                              <div className="closed-content">
                                <h5 className="mb-3">Closed</h5>
                                <p>Authorization case closed.</p>
                                <div className="alert alert-success">
                                  <i className="bi bi-check-circle me-2"></i>
                                  Case will be marked as closed upon completion.
                                </div>
                              </div>
                            )}
                          </div>
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              </div>
            )}

            {/* Other tabs content - placeholder */}
            {activeTab !== 'Overview' && activeTab !== 'Authorizations' && (
              <div className="row">
                <div className="col-12">
                  <div className="card border-0 shadow-sm">
                    <div className="card-body text-center py-5">
                      <i className="bi bi-construction text-muted" style={{fontSize: '48px'}}></i>
                      <h5 className="text-muted mt-3">{activeTab} Content</h5>
                      <p className="text-muted">This section is under development</p>
                    </div>
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Member;
