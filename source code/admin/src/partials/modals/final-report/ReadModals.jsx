import React, { useState, useEffect } from 'react';
import jsPDF from 'jspdf';
import html2canvas from 'html2canvas';

const ReadProductModal = ({ isOpen, onClose, apiEndpoint, token, medicineId }) => {
    const [isLoading, setIsLoading] = useState(false);
    const [productDetails, setProductDetails] = useState(null);

    const fetchProductDetails = async () => {
        setIsLoading(true);
        try {
            if (typeof medicineId !== 'string' && typeof medicineId !== 'number') {
                throw new Error('Invalid medicineId');
            }

            const url = `${apiEndpoint}/${medicineId}`;
            const response = await fetch(url, {
                headers: {
                    'Authorization': token,
                    'Content-Type': 'application/json',
                }
            });

            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }
            const data = await response.json();
            setProductDetails(data.data);
            console.log(data);

        } catch (error) {
            console.error('Error fetching product details:', error.message);
        } finally {
            setIsLoading(false);
        }
    };

    useEffect(() => {
        const handleEsc = (event) => {
            if (event.key === 'Escape') {
                onClose();
            }
        };

        if (isOpen) {
            fetchProductDetails();
            window.addEventListener('keydown', handleEsc);
        } else {
            window.removeEventListener('keydown', handleEsc);
        }

        return () => {
            window.removeEventListener('keydown', handleEsc);
        };
    }, [isOpen, medicineId, onClose]);

    // DELETE
    const [isDeleteOpen, setIsDeleteOpen] = useState(false);
    const [deleteId, setDeleteId] = useState(null);
    const openDelete = (id) => {
        setDeleteId(id);
        setIsDeleteOpen(true);
    };
    const closeDelete = () => setIsDeleteOpen(false);

    // EDIT
    const [isEditOpen, setIsEditOpen] = useState(false);
    const [editId, setEditId] = useState(null);

    const openEdit = (id) => {
        setEditId(id);
        setIsEditOpen(true);
    };
    const closeEdit = () => setIsEditOpen(false);

    const exportToPDF = () => {
        const input = document.getElementById('readProductModal'); // Get the modal element to export
        html2canvas(input).then((canvas) => {
            const imgData = canvas.toDataURL('image/png');
            const pdf = new jsPDF();
            pdf.addImage(imgData, 'PNG', 0, 0);
            pdf.save('medical_history.pdf');
        });
    };


    if (!isOpen) return null;

    return (
        <>
            <div
                id="readProductModal"
                tabIndex={-1}
                aria-hidden={!isOpen}
                className={`${isOpen ? 'flex' : 'hidden'} overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full`}
            >
                <div className="relative p-4 w-full max-w-xl max-h-full">
                    <div className="relative p-4 bg-white rounded-lg shadow dark:bg-gray-800 sm:p-5">
                        <div className="flex justify-between mb-4 rounded-t sm:mb-5">
                            <div className="text-lg text-gray-900 md:text-xl dark:text-white">
                                <h3 className="font-semibold">Medical History</h3>
                            </div>
                            <div>
                                <button
                                    type="button"
                                    className="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 ml-auto inline-flex items-center dark:hover:bg-gray-600 dark:hover:text-white"
                                    onClick={onClose}
                                >
                                    <svg
                                        aria-hidden="true"
                                        className="w-5 h-5"
                                        fill="currentColor"
                                        viewBox="0 0 20 20"
                                        xmlns="http://www.w3.org/2000/svg"
                                    >
                                        <path
                                            fillRule="evenodd"
                                            d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                                            clipRule="evenodd"
                                        />
                                    </svg>
                                    <span className="sr-only">Close modal</span>
                                </button>
                            </div>
                        </div>
                        {isLoading ? (
                            <div>Loading...</div>
                        ) : (
                            <dl>
                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Patient Name</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.doctorReport.nurse_report.patient.name || 'Product Name'}
                                </dd>

                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Disease</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.doctorReport.disease || 'Product amount'}
                                </dd>
                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Medicine Name</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.doctorReport.medicine.name || 'Product expiry date'}
                                </dd>
                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Medicine Amount Each</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.doctorReport.amount || 'Product details here...'}
                                </dd>
                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Nurse Name</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.doctorReport.nurse_report.staff.name || 'Product image'}
                                </dd>
                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Doctor Name</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.doctorReport.staff_doctor.name || 'Product category'}
                                </dd>
                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Size Circumference</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.doctorReport.nurse_report.SizeCircumference || 'Product category'}
                                </dd>
                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Allergy</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.doctorReport.nurse_report.allergy || 'Product category'}
                                </dd>
                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Diastole</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.doctorReport.nurse_report.diastole || 'Product category'}
                                </dd>
                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Pulse</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.doctorReport.nurse_report.pulse || 'Product category'}
                                </dd>
                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Respiration</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.doctorReport.nurse_report.respiration || 'Product category'}
                                </dd>
                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Systole</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.doctorReport.nurse_report.systole || 'Product category'}
                                </dd>
                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Temperature</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.doctorReport.nurse_report.temperature || 'Product category'}
                                </dd>

                            </dl>
                        )}
                        <div className="flex justify-between items-center">
                            <div className="flex items-center space-x-3 sm:space-x-4">
                                <button
                                    type="button"
                                    onClick={exportToPDF}
                                    className="inline-flex items-center text-white bg-green-600 hover:bg-green-700 focus:ring-4 focus:outline-none focus:ring-green-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-green-500 dark:hover:bg-green-600 dark:focus:ring-green-900"
                                >
                                    <svg
                                        aria-hidden="true"
                                        className="w-5 h-5 mr-1.5 -ml-1"
                                        fill="currentColor"
                                        viewBox="0 0 20 20"
                                        xmlns="http://www.w3.org/2000/svg"
                                    >
                                        <path
                                            fillRule="evenodd"
                                            d="M10 2a8 8 0 100 16 8 8 0 000-16zM4 10a6 6 0 1112 0 6 6 0 01-12 0zm7.707-2.293a1 1 0 00-1.414-1.414L8 10.586V7a1 1 0 00-2 0v3.586L4.707 7.293a1 1 0 00-1.414 1.414l3 3a1 1 0 001.414 0l3-3z"
                                            clipRule="evenodd"
                                        />
                                    </svg>
                                    Export PDF
                                </button>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </>
    );
};

export default ReadProductModal;
