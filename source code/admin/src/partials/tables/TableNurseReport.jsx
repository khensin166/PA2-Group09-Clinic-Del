import React, { useState, useEffect } from 'react';
import ModalCreate from '../modals/nurse-report/CreateModals';
import ModalEdit from '../modals/nurse-report/EditModals';
import ReadProductModal from '../modals/nurse-report/ReadModals';
import DeleteProductModel from '../modals/nurse-report/DeleteModals';

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
    const [editId, setEditId] = useState(null)

    const openEdit = (id) => {
        setEditId(id)
        setIsEditOpen(true)
    };
    const closeEdit = () => setIsEditOpen(false);

    // PREVIEW
    const [isPreviewOpen, setIsPreviewOpen] = useState(false);
    const [previewId, setPreviewId] = useState(null)

    const openPreview = (id) => {
        setPreviewId(id)
        setIsPreviewOpen(true);
    }
    const closePreview = () => setIsPreviewOpen(false)

    // DELETE
    const [isDeleteOpen, setIsDeleteOpen] = useState(false);
    const [deleteId, setDeleteId] = useState(null);
    const openDelete = (id) => {
        setDeleteId(id);
        setIsDeleteOpen(true);
    };
    const closeDelete = () => setIsDeleteOpen(false);

    const token = localStorage.getItem('token');
    const [error, setError] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const [nurseReports, setNurseReports] = useState([]);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await fetch('http://127.0.0.1:8080/nurse-reports', {
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
                console.log(data); // Tampilkan data di console

                if (data.nurse_reports) {
                    setNurseReports(data.nurse_reports);
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


    // Pagination
    const [currentPage, setCurrentPage] = useState(1);
    const itemsPerPage = 2;
    const indexOfLastItem = currentPage * itemsPerPage;
    const indexOfFirstItem = indexOfLastItem - itemsPerPage;
    const currentItems = nurseReports.slice(indexOfFirstItem, indexOfLastItem);
    const totalPages = Math.ceil(nurseReports.length / itemsPerPage);
    const paginate = (pageNumber) => setCurrentPage(pageNumber);

    return (
        <>
            {/* Start block */}
            <section className="bg-gray-50 dark:bg-gray-900 p-3 sm:p-5 antialiased">
                <div className="mx-auto max-w-screen-xl px-4 lg:px-12">

                    {/* Start coding here */}
                    <div className="bg-white dark:bg-gray-800 relative shadow-md sm:rounded-lg overflow-hidden">

                        {/* HEADER TABLE */}
                        <div className="flex flex-col md:flex-row items-center justify-between space-y-3 md:space-y-0 md:space-x-4 p-4">
                            <div className="w-full md:w-1/2">
                                <form className="flex items-center">
                                    <label htmlFor="simple-search" className="sr-only">
                                        Search
                                    </label>
                                    <div className="relative w-full">
                                        <div className="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                                            <svg
                                                aria-hidden="true"
                                                className="w-5 h-5 text-gray-500 dark:text-gray-400"
                                                fill="currentColor"
                                                viewBox="0 0 20 20"
                                                xmlns="http://www.w3.org/2000/svg"
                                            >
                                                <path
                                                    fillRule="evenodd"
                                                    d=
                                                    "M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z"
                                                    clipRule="evenodd"
                                                />
                                            </svg>
                                        </div>
                                        <input
                                            type="text"
                                            id="simple-search"
                                            className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 p-2 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                            placeholder="Search"
                                            required=""
                                        />
                                    </div>
                                </form>
                            </div>


                            {/* HEADER TABLE */}
                            <div className="w-full md:w-auto flex flex-col md:flex-row space-y-2 md:space-y-0 items-stretch md:items-center justify-end md:space-x-3 flex-shrink-0">

                                {/* ADD PRODUCT */}
                                <button
                                    type="button"
                                    id="createProductModalButton"
                                    onClick={openModal}
                                    className="flex items-center justify-center text-white bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:ring-primary-300 font-medium rounded-lg text-sm px-4 py-2 dark:bg-primary-600 dark:hover:bg-primary-700 focus:outline-none dark:focus:ring-primary-800"
                                >
                                    <svg className="h-3.5 w-3.5 mr-2" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path clipRule="evenodd" fillRule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" />
                                    </svg>
                                    Add Nurse Report
                                </button>

                                {/* ACTION */}
                                <div className="relative inline-block">
                                    <button
                                        id="actionsDropdownButton"
                                        onClick={toggleDropdown}
                                        className="w-full flex items-center justify-center py-2 px-4 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-primary-700 focus:z-10 focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700"
                                        type="button"
                                    >
                                        <svg
                                            className="-ml-1 mr-1.5 w-5 h-5"
                                            fill="currentColor"
                                            viewBox="0 0 20 20"
                                            xmlns="http://www.w3.org/2000/svg"
                                            aria-hidden="true"
                                        >
                                            <path
                                                clipRule="evenodd"
                                                fillRule="evenodd"
                                                d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 011.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                                            />
                                        </svg>
                                        Action
                                    </button>
                                    {/* Dropdown menu */}
                                    {isOpen && (
                                        <div
                                            id="actionsDropdown"
                                            className="z-10 absolute right-0 mt-2 w-36 origin-top-right bg-white divide-y divide-gray-100 rounded-lg shadow dark:bg-gray-700 dark:divide-gray-600"
                                        >
                                            <div className="py-1">
                                                <a
                                                    href="#"
                                                    className="flex items-center py-2 px-4 text-sm text-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 dark:text-gray-200 dark:hover:text-white"
                                                >
                                                    <svg
                                                        className="mr-2 w-4 h-4"
                                                        fill="none"
                                                        stroke="currentColor"
                                                        viewBox="0 0 24 24"
                                                        xmlns="http://www.w3.org/2000/svg"
                                                    >
                                                        <path
                                                            strokeLinecap="round"
                                                            strokeLinejoin="round"
                                                            strokeWidth="2"
                                                            d="M11 17a4 4 0 100-8 4 4 0 000 8zm5.657-1.657A6 6 0 1116 9m-6 6H9m0 0H8m2 0h1"
                                                        />
                                                    </svg>
                                                    Placeholder
                                                </a>
                                            </div>
                                        </div>
                                    )}
                                </div>

                            </div>

                        </div>

                        {/* TABLE */}
                        <div className="overflow-x-auto">
                            <table className="w-full text-sm text-left text-gray-500 dark:text-gray-400">
                                <thead className="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                                    <tr>
                                        <th scope="col" className="px-4 py-3">ID</th>
                                        <th scope="col" className="px-4 py-3">Patient ID</th>
                                        <th scope="col" className="px-4 py-3">Approved BY ID </th>
                                        <th scope="col" className="px-4 py-3">Temperature</th>
                                        <th scope="col" className="px-4 py-3">Systole</th>
                                        <th scope="col" className="px-4 py-3">Diastole</th>
                                        <th scope="col" className="px-4 py-3">Pulse</th>
                                        <th scope="col" className="px-4 py-3">Oxygen Saturation</th>
                                        <th scope="col" className="px-4 py-3">Respiration</th>
                                        <th scope="col" className="px-4 py-3">Height</th>
                                        <th scope="col" className="px-4 py-3">Weight</th>
                                        <th scope="col" className="px-4 py-3">Abdominal Circumference</th>
                                        <th scope="col" className="px-4 py-3">Allergy</th>
                                        <th scope="col" className="px-4 py-3 text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {isLoading ? (
                                        <tr>
                                            <td colSpan="13" className="text-center py-4">Loading...</td>
                                        </tr>
                                    ) : error ? (
                                        <tr>
                                            <td colSpan="13" className="text-center py-4 text-red-500">{error}</td>
                                        </tr>
                                    ) : (
                                        currentItems.map((report, index) => (
                                            <tr key={report.id} className="border-b dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700">
                                                <td className="px-4 py-3">
                                                    {report.id}

                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {report.staff_id}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {report.patient_id}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {report.temperature}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {report.systole}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {report.diastole}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {report.pulse}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {report.oxygen_saturation}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {report.respiration}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {report.height}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {report.weight}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {report.abdominal_circumference}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {report.allergy}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white text-center">
                                                    <div className="flex items-center space-x-4 justify-center">
                                                        <button
                                                            onClick={() => openPreview(report.nurse_id)}
                                                            type="button"
                                                            className="py-2 px-3 flex items-center text-sm font-medium text-center text-white bg-primary-700 rounded-lg hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800"
                                                        >
                                                            Edit
                                                        </button>
                                                        <button
                                                            onClick={() => openEdit(report.nurse_id)}
                                                            type="button"
                                                            className="py-2 px-3 flex items-center text-sm font-medium text-center text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-primary-700 focus:z-10 focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700"
                                                        >
                                                            Preview
                                                        </button>
                                                        <button
                                                            onClick={() => openDelete(report.nurse_id)}
                                                            type="button"
                                                            className="flex items-center text-red-700 hover:text-white border border-red-700 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-3 py-2 text-center dark:border-red-500 dark:text-red-500 dark:hover:text-white dark:hover:bg-red-600 dark:focus:ring-red-900"
                                                        >
                                                            Delete
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        ))
                                    )}
                                </tbody>
                            </table>
                        </div>


                        {/* PAGINATION */}
                        <nav className="flex justify-between items-center p-4" aria-label="Table navigation">
                            <span className="text-sm font-normal text-gray-500 dark:text-gray-400">Showing <span className="font-semibold text-gray-900 dark:text-white">{indexOfFirstItem + 1}-{Math.min(indexOfLastItem, nurseReports.length)}</span> of <span className="font-semibold text-gray-900 dark:text-white">{nurseReports.length}</span></span>
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

            {/* MODALS */}
            <ModalCreate isOpen={isModalOpen} onClose={closeModal} />
            <ModalEdit isOpen={isEditOpen} onClose={closeEdit} id={editId} />
            <ReadProductModal isOpen={isPreviewOpen} onClose={closePreview} id={previewId} />
            <DeleteProductModel isOpen={isDeleteOpen} onClose={closeDelete} id={deleteId} />
        </>
    );
}

export default Table;
