import React, { useState, useEffect } from 'react';
import ModalEdit from './EditModals';
import DeleteProductModel from './DeleteModals';

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
            console.log(url); // Tampilkan URL di console
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



    // esc button
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
                                <h3 className="font-semibold">MEDICINE</h3>
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
                                    {productDetails?.requested.name || 'none'}
                                </dd>

                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Nurse Name</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.approved.name || 'none'}
                                </dd>
                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Complaint</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.complaint || 'none'}
                                </dd>
                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Date</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.date || 'none'}
                                </dd>
                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Time</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.time || 'none'}
                                </dd>
                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Created at</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.created_at || 'none'}
                                </dd>

                                <dt className="mb-2 font-semibold leading-none text-gray-900 dark:text-white">Updated at</dt>
                                <dd className="mb-4 font-light text-gray-500 sm:mb-5 dark:text-gray-400">
                                    {productDetails?.updated_at || 'none'}
                                </dd>
                            </dl>
                        )}
                        <div className="flex justify-between items-center">

                            <button
                                onClick={() => openDelete(productDetails.id)}
                                type="button"
                                className="inline-flex items-center text-white bg-red-600 hover:bg-red-700 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-red-500 dark:hover:bg-red-600 dark:focus:ring-red-900"
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
                                        d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z"
                                        clipRule="evenodd"
                                    />
                                </svg>
                                Delete
                            </button>
                        </div>
                    </div>
                </div>
            </div>


            <DeleteProductModel
                isOpen={isDeleteOpen}
                onClose={closeDelete}
                apiEndpoint="http://127.0.0.1:8080/appointment"
                medicineId={deleteId}
                token={token}
            />
        </>
    );
};

export default ReadProductModal;
