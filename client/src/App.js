import React, { useState, useEffect } from 'react';
import { Routes, Route, useNavigate, useLocation, useParams } from 'react-router-dom';
import Login from './components/Login';
import Dashboard from './components/Dashboard';
import Member from './components/Member';
import './App.css';

// Placeholder for fetching member data by Number - replace with your actual data fetching logic
const fetchMemberByNumber = async (memberNumber, token) => {
  console.log(`[App.js] fetchMemberByNumber called with: ${memberNumber}, token: ${token ? 'present' : 'absent'}`);
  try {
    const response = await fetch(`/api/dashboard/member/${memberNumber}`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });
    console.log(`[App.js] fetchMemberByNumber API response status: ${response.status}`);
    if (!response.ok) {
      if (response.status === 404) {
        console.warn(`[App.js] Member with number ${memberNumber} not found (404).`);
        return null;
      }
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();
    console.log("[App.js] fetchMemberByNumber API response data:", data);
    // Transform snake_case from API to camelCase for frontend consistency if needed
    // The backend currently returns: id, member_number, first_name, last_name, name, dob, pcp, plan, status etc.
    // Let's ensure the key 'memberNumber' is present for consistency with useParams and other frontend logic.
    return { 
      ...data, 
      memberNumber: data.member_number // Ensure memberNumber (camelCase) is available
    };
  } catch (error) {
    console.error("[App.js] Failed to fetch member by number:", error);
    throw error;
  }
};

function App() {
  const [user, setUser] = useState(null);
  const [token, setToken] = useState(null);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    const savedToken = localStorage.getItem('token');
    const savedUser = localStorage.getItem('user');
    
    if (savedToken && savedUser) {
      try {
        setToken(savedToken);
        setUser(JSON.parse(savedUser));
      } catch (error) {
        console.error('Error parsing saved user data:', error);
        localStorage.removeItem('token');
        localStorage.removeItem('user');
      }
    } 
    // No automatic redirect to /login here to avoid issues during initial load before routes are fully processed.
    // Protected routing is handled by the Routes configuration itself.
    setLoading(false);
  }, []); // Removed navigate and location.pathname as they could cause loops if not handled carefully here.

  const handleLogin = (userData, userToken) => {
    setUser(userData);
    setToken(userToken);
    localStorage.setItem('token', userToken);
    localStorage.setItem('user', JSON.stringify(userData));
    navigate('/dashboard');
  };

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    setUser(null);
    setToken(null);
    navigate('/login');
  };

  const handleMemberClick = (memberData) => {
    // IMPORTANT: Ensure memberData from Dashboard includes a 'member_number' field.
    if (memberData && memberData.memberNumber) { // Changed from member_number to memberNumber
      navigate(`/member/${memberData.memberNumber}`);
    } else {
      console.error("Clicked member data does not have a memberNumber (camelCase) property:", memberData);
      // Optionally, navigate to an error page or show a notification
    }
  };

  const handleNavigation = (viewPath) => {
    const path = viewPath.toLowerCase();
    if (path === 'dashboard') {
      navigate('/dashboard');
    } else if (path.startsWith('member/')) {
      navigate(`/${path}`);
    } else {
      console.log(`Navigation to ${viewPath} requested`);
      // navigate(`/${path}`); // Example for other potential routes
    }
  };

  const MemberPage = () => {
    const { memberNumber } = useParams(); // This will be "MEM001"
    const [memberData, setMemberData] = useState(null);
    const [memberLoading, setMemberLoading] = useState(true);
    const [memberError, setMemberError] = useState(null);

    useEffect(() => {
      console.log(`[App.js MemberPage] useEffect triggered. memberNumber: ${memberNumber}, token: ${token ? 'present' : 'absent'}`);
      if (memberNumber && token) {
        setMemberLoading(true);
        fetchMemberByNumber(memberNumber, token)
          .then(data => {
            console.log("[App.js MemberPage] Data received from fetchMemberByNumber:", data);
            if (data) {
              setMemberData(data);
              setMemberError(null); // Clear previous errors
            } else {
              setMemberError('Member not found.');
              setMemberData(null); // Clear previous data
            }
          })
          .catch(err => {
            console.error("[App.js MemberPage] Error in fetchMemberByNumber chain:", err);
            setMemberError('Failed to load member data.');
            setMemberData(null); // Clear previous data
          })
          .finally(() => {
            setMemberLoading(false);
            console.log("[App.js MemberPage] Fetch attempt finished.");
          });
      } else if (!token && location.pathname !== '/login') {
        console.log("[App.js MemberPage] No token, redirecting to login.");
        navigate('/login');
      } else if (!memberNumber) {
        console.warn("[App.js MemberPage] memberNumber is undefined.");
        setMemberError("Member number not provided in URL.");
        setMemberLoading(false);
      }
    }, [memberNumber, token, navigate, location.pathname]);

    console.log(`[App.js MemberPage] Rendering. Loading: ${memberLoading}, Error: ${memberError}, Data: ${memberData ? 'present' : 'absent'}`);

    if (memberLoading) {
      return <div className="loading-center"><div className="spinner-border text-primary"></div></div>;
    }
    if (memberError) {
      return <div className="container mt-5"><div className="alert alert-danger">{memberError}</div></div>;
    }
    if (!memberData) {
      return <div className="container mt-5"><div className="alert alert-warning">Member data not available.</div></div>;
    }

    return (
      <Member 
        user={user} 
        memberData={memberData} 
        onLogout={handleLogout} 
        onBack={() => navigate('/dashboard')} 
        onNavigate={handleNavigation} 
      />
    );
  };

  if (loading && !token && location.pathname !== '/login') {
    // If still loading initial auth state AND not logged in AND not on login page, show loading or redirect early.
    // This helps prevent flashing content before redirection logic in Routes takes full effect.
    // However, the main redirect logic is within the <Routes> for non-authenticated users.
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
      <Routes>
        <Route path="/login" element={<Login onLogin={handleLogin} />} />
        {user && token ? (
          <>
            <Route path="/dashboard" element={<Dashboard user={user} onLogout={handleLogout} onMemberClick={handleMemberClick} onNavigate={handleNavigation} />} />
            <Route path="/member/:memberNumber" element={<MemberPage />} /> {/* Changed :memberId to :memberNumber */}
            <Route path="*" element={<Dashboard user={user} onLogout={handleLogout} onMemberClick={handleMemberClick} onNavigate={handleNavigation} />} />
          </>
        ) : (
          <Route path="*" element={<Login onLogin={handleLogin} />} />
        )}
      </Routes>
    </div>
  );
}

export default App;
