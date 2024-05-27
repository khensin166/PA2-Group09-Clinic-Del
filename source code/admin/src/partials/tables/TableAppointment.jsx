import React, { useState, useEffect } from 'react';
import ModalCreate from '../modals/appointment/CreateModals';
import ReadProductModal from '../modals/appointment/ReadModals';
import DeleteProductModel from '../modals/appointment/DeleteModals';
import { jwtDecode } from 'jwt-decode';

function Table() {
    // ACTION DROPDOWN IN HEADER
    const [isOpen, setIsOpen] = useState(false);
    const toggleDropdown = () => {
        setIsOpen(!isOpen);
    };

    // ADD
    const [isModalOpen, setIsModalOpen] = useState(false);
    const openModal = () => setIsModalOpen(true);
    const closeModal = () => setIsModalOpen(false);

    // EDIT
    const [isEditOpen, setIsEditOpen] = useState(false);
    const [editId, setEditId] = useState(null);
    const openEdit = (id) => {
        setEditId(id);
        setIsEditOpen(true);
    };
    const closeEdit = () => setIsEditOpen(false);

    // PREVIEW
    const [isPreviewOpen, setIsPreviewOpen] = useState(false);
    const [previewId, setPreviewId] = useState(null);
    const openPreview = (id) => {
        setPreviewId(id);
        setIsPreviewOpen(true);
    };
    const closePreview = () => setIsPreviewOpen(false);

    // DELETE
    const [isDeleteOpen, setIsDeleteOpen] = useState(false);
    const [deleteId, setDeleteId] = useState(null);
    const openDelete = (id) => {
        setDeleteId(id);
        setIsDeleteOpen(true);
    };
    const closeDelete = () => setIsDeleteOpen(false);

    const token = localStorage.getItem('token');
    const decodedToken = jwtDecode(token);
    const approvingNurse = decodedToken.id

    const [error, setError] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const [appointments, setAppointments] = useState([]);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await fetch('http://127.0.0.1:8080/appointments', {
                    method: 'GET',
                    headers: {
                        'Authorization': `${token}`,
                        'Content-Type': 'application/json',
                    }
                });

                if (!response.ok) {
                    throw new Error('Failed to fetch data');
                }

                const data = await response.json();
                console.log(data); // Display data in the console

                if (data.appointments) {
                    setAppointments(data.appointments);
                } else {
                    throw new Error('Invalid data format');
                }

                setIsLoading(false);
            } catch (error) {
                setError(error.message);
                setIsLoading(false);
            }
        };

        fetchData();
    }, [token]);

    const approveAppointment = async (id) => {
        try {
            const response = await fetch(`http://127.0.0.1:8080/appointment/${id}/approve`, {
                method: 'PUT',
                headers: {
                    'Authorization': `${token}`,
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ approved_id: approvingNurse }), // Replace with the actual ID of the approving nurse
            });

            if (!response.ok) {
                throw new Error('Failed to approve appointment');
            }

            const updatedAppointments = appointments.map((appointment) =>
                appointment.id === id ? { ...appointment, approved: { name: approvingNurse } } : appointment
            );
            setAppointments(updatedAppointments);
            window.location.reload();

        } catch (error) {
            setError(error.message);
        }
    };

    // Pagination
    const [currentPage, setCurrentPage] = useState(1);
    const itemsPerPage = 2;
    const indexOfLastItem = currentPage * itemsPerPage;
    const indexOfFirstItem = indexOfLastItem - itemsPerPage;
    const currentItems = appointments.slice(indexOfFirstItem, indexOfLastItem);
    const totalPages = Math.ceil(appointments.length / itemsPerPage);
    const paginate = (pageNumber) => setCurrentPage(pageNumber);

    return (
        <>
            <section className="bg-gray-50 dark:bg-gray-900 p-3 sm:p-5 antialiased">
                <div className="mx-auto max-w-screen-xl px-4 lg:px-12">
                    <div className="bg-white dark:bg-gray-800 relative shadow-md sm:rounded-lg overflow-hidden">
                        <div className="flex flex-col md:flex-row items-center justify-between space-y-3 md:space-y-0 md:space-x-4 p-4">
                            <div className="w-full md:w-1/2">
                                <form className="flex items-center">
                                    <label htmlFor="simple-search" className="sr-only">Search</label>
                                    <div className="relative w-full">
                                        <div className="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                                            <svg aria-hidden="true" className="w-5 h-5 text-gray-500 dark:text-gray-400" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                                                <path fillRule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clipRule="evenodd" />
                                            </svg>
                                        </div>
                                        <input type="text" id="simple-search" className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 p-2 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500" placeholder="Search" required="" />
                                    </div>
                                </form>
                            </div>
                        </div>

                        <div className="overflow-x-auto">
                            <table className="w-full text-sm text-left text-gray-500 dark:text-gray-400">
                                <thead className="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                                    <tr>
                                        <th scope="col" className="px-4 py-3">ID</th>
                                        <th scope="col" className="px-4 py-3">Description</th>
                                        <th scope="col" className="px-4 py-3">Date</th>
                                        <th scope="col" className="px-4 py-3">Time</th>
                                        <th scope="col" className="px-4 py-3">Approved</th>
                                        <th scope="col" className="px-4 py-3">Requested</th>
                                        <th scope="col" className="px-4 py-3 text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {isLoading ? (
                                        <tr>
                                            <td colSpan="6" className="px-4 py-3 text-center">Loading...</td>
                                        </tr>
                                    ) : error ? (
                                        <tr>
                                            <td colSpan="6" className="px-4 py-3 text-center text-red-500">{error}</td>
                                        </tr>
                                    ) : currentItems.length > 0 ? (
                                        currentItems.map((appointment, index) => (
                                            <tr className="border-b dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700" key={appointment.id}>
                                                <td className="px-6 py-4">
                                                    {indexOfFirstItem + index + 1}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {appointment.complaint}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    <div className="flex items-center">
                                                        <div className="h-4 w-4 rounded-full inline-block mr-2 bg-red-700" />
                                                        {appointment.date}
                                                    </div>
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {appointment.time}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {appointment.approved ? appointment.approved.name : 'N/A'}
                                                </td>

                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {appointment.requested ? appointment.requested.name : 'N/A'}
                                                </td>

                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white text-center">
                                                    <div className="flex items-center space-x-4 justify-center">


                                                        {!appointment.approved && ( // Tambahkan kondisi disini
                                                            <button
                                                                onClick={() => approveAppointment(appointment.id)}
                                                                type="button"
                                                                className="py-2 px-3 flex items-center text-sm font-medium text-center text-white bg-primary-700 rounded-lg hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800"
                                                            >
                                                                Approve
                                                            </button>
                                                        )}

                                                        {/* PREVIEW BUTTON */}
                                                        <button
                                                            onClick={() => openPreview(appointment.id)}
                                                            type="button"
                                                            data-drawer-target="drawer-read-product-advanced"
                                                            data-drawer-show="drawer-read-product-advanced"
                                                            aria-controls="drawer-read-product-advanced"
                                                            className="py-2 px-3 flex items-center text-sm font-medium text-center text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-primary-700 focus:z-10 focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700"
                                                        >
                                                            <svg
                                                                xmlns="http://www.w3.org/2000/svg"
                                                                viewBox="0 0 24 24"
                                                                fill="currentColor"
                                                                className="w-4 h-4 mr-2 -ml-0.5"
                                                            >
                                                                <path d="M12 15a3 3 0 100-6 3 3 0 000 6z" />
                                                                <path
                                                                    fillRule="evenodd"
                                                                    clipRule="evenodd"
                                                                    d="M1.323 11.447C2.811 6.976 7.028 3.75 12.001 3.75c4.97 0 9.185 3.223 10.675 7.69.12.362.12.752 0 1.113-1.487 4.471-5.705 7.697-10.677 7.697-4.97 0-9.186-3.223-10.675-7.69a1.762 1.762 0 010-1.113zM17.25 12a5.25 5.25 0 11-10.5 0 5.25 5.25 0 0110.5 0z"
                                                                />
                                                            </svg>
                                                            Preview
                                                        </button>


                                                        {/* DELETE BUTTON */}
                                                        <button
                                                            onClick={() => openDelete(appointment.id)}
                                                            type="button"
                                                            data-modal-target="delete-modal"
                                                            data-modal-toggle="delete-modal"
                                                            className="flex items-center text-red-700 hover:text-white border border-red-700 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-3 py-2 text-center dark:border-red-500 dark:text-red-500 dark:hover:text-white dark:hover:bg-red-600 dark:focus:ring-red-900"
                                                        >
                                                            <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4 mr-2 -ml-0.5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                                                <path fillRule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clipRule="evenodd" />
                                                            </svg>
                                                            Delete
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        ))
                                    ) : (
                                        <tr>
                                            <td colSpan="6" className="px-4 py-3 text-center">No appointments found</td>
                                        </tr>
                                    )}
                                </tbody>
                            </table>
                        </div>


                        <nav className="flex justify-between items-center p-4" aria-label="Table navigation">
                            <span className="text-sm font-normal text-gray-500 dark:text-gray-400">Showing <span className="font-semibold text-gray-900 dark:text-white">{indexOfFirstItem + 1}-{Math.min(indexOfLastItem, appointments.length)}</span> of <span className="font-semibold text-gray-900 dark:text-white">{appointments.length}</span></span>
                            <ul className="inline-flex items-stretch -space-x-px">
                                <li>
                                    <button
                                        className="px-3 py-2 ml-0 leading-tight text-gray-500 bg-white border border-gray-300 rounded-l-lg hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
                                        onClick={() => paginate(currentPage - 1)}
                                        disabled={currentPage === 1}
                                    >
                                        Previous
                                    </button>
                                </li>
                                {Array.from({ length: totalPages }, (_, index) => (
                                    <li key={index}>
                                        <button
                                            className={`px-3 py-2 leading-tight border ${currentPage === index + 1 ? 'text-primary-600 bg-primary-50 border-primary-300 hover:bg-primary-100 hover:text-primary-700 dark:bg-gray-700 dark:border-gray-600 dark:text-white' : 'text-gray-500 bg-white border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white'}`}
                                            onClick={() => paginate(index + 1)}
                                        >
                                            {index + 1}
                                        </button>
                                    </li>
                                ))}
                                <li>
                                    <button
                                        className="px-3 py-2 leading-tight text-gray-500 bg-white border border-gray-300 rounded-r-lg hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
                                        onClick={() => paginate(currentPage + 1)}
                                        disabled={currentPage === totalPages}
                                    >
                                        Next
                                    </button>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </section>

            <ModalCreate
                isOpen={isModalOpen}
                onClose={closeModal}
                apiEndpoint="http://127.0.0.1:8080/appointment"
                token={token}
            />

            <ReadProductModal
                isOpen={isPreviewOpen}
                onClose={closePreview}
                apiEndpoint="http://127.0.0.1:8080/appointment"
                token={token}
                medicineId={previewId}
            />

            <DeleteProductModel
                isOpen={isDeleteOpen}
                onClose={closeDelete}
                deleteId={deleteId}
                apiEndpoint="http://127.0.0.1:8080/appointment"
                token={token}
                medicineId={deleteId}
            />
        </>
    );
}

export default Table;
