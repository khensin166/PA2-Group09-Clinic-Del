import React, { useEffect } from 'react';
import { Routes, Route, useLocation } from 'react-router-dom';
import './css/style.css';

// Import pages
import Dashboard from './pages/Dashboard';
import SignIn from './pages/auth/LoginForm.jsx';
import SignUp from './pages/auth/RegistrationForm.jsx';
import UserData from './pages/admin/UserDataForm.jsx';
import Appointments from './pages/admin/AppointmentForm.jsx';
import Madicines from './pages/admin/MadicinesForm.jsx';
import FinalReport from './pages/admin/FinalReportForm.jsx';
import NurseReport from './pages/nurse/nurse-report.jsx';
import DoctorReport from './pages/doctor/doctor-report.jsx';
import Dorm from './pages/admin/DormForm.jsx'

import ProtectedRoute from './components/ProtectedRoute';


function App() {
  const location = useLocation();

  useEffect(() => {
    document.querySelector('html').style.scrollBehavior = 'auto';
    window.scroll({ top: 0 });
    document.querySelector('html').style.scrollBehavior = '';
  }, [location.pathname]); // triggered on route change

  return (
    <>
      <Routes>
        <Route path="/signin" element={<SignIn />} />
        <Route path="/signup" element={<SignUp />} />

        <Route element={<ProtectedRoute />}>
          <Route path="/" element={<Dashboard />} />
          <Route path="/user-data" element={<UserData />} />
          <Route path="/appointments" element={<Appointments />} />
          <Route path="/madicines" element={<Madicines />} />
          <Route path="/final-report" element={<FinalReport />} />
          <Route path="/nurse-report" element={<NurseReport />} />
          <Route path="/doctor-report" element={<DoctorReport />} />
          <Route path="/dorm" element={<Dorm />} />
        </Route>
      </Routes>
    </>
  );
}

export default App;
