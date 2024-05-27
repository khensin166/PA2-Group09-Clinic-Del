// ProtectedRoute.jsx
import React from 'react';
import { Navigate, Outlet } from 'react-router-dom';
import { getStoredAuthToken } from '../utils/AuthUtils';

const ProtectedRoute = () => {
  const token = getStoredAuthToken();
  const pathname = window.location.pathname;

  // Penanganan jika pengguna mencoba mengakses halaman sign-in atau halaman registrasi ketika sudah terautentikasi
  if (token && (pathname === '/signin' || pathname === '/register')) {
    return <Navigate to="/" />; // Arahkan pengguna kembali ke halaman dashboard
  }

  // Penanganan jika token ada
  if (token) {
    return <Outlet />; // Izinkan pengguna untuk mengakses rute yang dilindungi
  }

  // Penanganan jika tidak ada token, arahkan pengguna ke halaman sign-in
  return <Navigate to="/signin" />;
};

export default ProtectedRoute;
