import React, { useState } from 'react';

import Sidebar from '../../partials/Sidebar';
import Header from '../../partials/Header';
import WelcomeBanner from '../../partials/dashboard/WelcomeBanner';
import TableDorm from '../../partials/tables/TableDorm'


function Dorm() {

  const [sidebarOpen, setSidebarOpen] = useState(false);
  const token = localStorage.getItem('token'); // Mendapatkan token dari localStorage


  // tambahkan ini
  const [isModalOpen, setIsModalOpen] = useState(false);
  const openModal = () => setIsModalOpen(true);
  const closeModal = () => setIsModalOpen(false)


  return (
    <div className="flex h-screen overflow-hidden">

      {/* Sidebar */}
      <Sidebar sidebarOpen={sidebarOpen} setSidebarOpen={setSidebarOpen} />

      {/* Content area */}
      <div className="relative flex flex-col flex-1 overflow-y-auto overflow-x-hidden">

        {/*  Site header */}
        <Header sidebarOpen={sidebarOpen} setSidebarOpen={setSidebarOpen} />

        <main>
          <div className="px-4 sm:px-6 lg:px-8 py-8 w-full max-w-9xl mx-auto">

            {/* Welcome banner */}
            <WelcomeBanner token={token} /> {/* Meneruskan token sebagai prop */}



            {/* Cards */}
            <TableDorm token={token} />


          </div>
        </main>

      </div>

    </div>
  );
}

export default Dorm;