import React, { useState, useEffect } from 'react';
import ModalEdit from '../modals/doctor-report/EditModals';
import ReadProductModal from '../modals/doctor-report/ReadModals';

function Table() {
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
    const [doctorReports, setDoctorReports] = useState([]);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await fetch('http://127.0.0.1:8080/doctor-report-approved', {
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

                if (data.doctor_reports) {
                    setDoctorReports(data.doctor_reports);
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
    const itemsPerPage = 5;
    const indexOfLastItem = currentPage * itemsPerPage;
    const indexOfFirstItem = indexOfLastItem - itemsPerPage;
    const currentItems = doctorReports.slice(indexOfFirstItem, indexOfLastItem);
    const totalPages = Math.ceil(doctorReports.length / itemsPerPage);

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
                        </div>

                        {/* MAIN TABLE SECTION */}
                        <div className="overflow-x-auto">
                            <table className="w-full text-sm text-left text-gray-500 dark:text-gray-400">
                                <thead className="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                                    <tr>
                                        <th scope="col" className="p-4">ID</th>
                                        <th scope="col" className="p-4">Amount</th>
                                        <th scope="col" className="p-4">Disease</th>
                                        <th scope="col" className="p-4">Medicine</th>
                                        <th scope="col" className="p-4">Nurse Report For</th>
                                        <th scope="col" className="p-4">Doctor Name</th>
                                        <th scope="col" className="text-center p-4">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {isLoading ? (
                                        <tr>
                                            <td colSpan="7" className="text-center py-4">Loading...</td>
                                        </tr>
                                    ) : error ? (
                                        <tr>
                                            <td colSpan="7" className="text-center py-4 text-red-500">{error}</td>
                                        </tr>
                                    ) : (
                                        currentItems.map((report, index) => (
                                            <tr key={report.id} className="border-b dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700">
                                                < td className="px-4 py-3" >
                                                    {report.id}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {report.amount}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {report.disease}
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    kosong
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                   <a href="" className='text-blue-500 justify-center'>{report.nurse_report.patient.name}</a> 
                                                </td>
                                                <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                                    {/* {report.staffDoctor.name} */}
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
                            <span className="text-sm font-normal text-gray-500 dark:text-gray-400">Showing <span className="font-semibold text-gray-900 dark:text-white">{indexOfFirstItem + 1}-{Math.min(indexOfLastItem, doctorReports.length)}</span> of <span className="font-semibold text-gray-900 dark:text-white">{doctorReports.length}</span></span>
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

                </div >
            </section >
            {/* End block */}


       
            {/* Update modal */}
            <ModalEdit
                isOpen={isEditOpen}
                onClose={closeEdit}
                apiEndpoint="http://127.0.0.1:8080/medicine"
                token={token}
                medicineId={editId}
            >
            </ModalEdit >

            {/* Read modal */}
            < ReadProductModal
                isOpen={isPreviewOpen}
                onClose={closePreview}
                apiEndpoint="http://127.0.0.1:8080/medicine"
                medicineId={previewId}
                token={token}
            />

        

        </>
    );
}


export default Table;
