import React, { useState, useEffect } from "react";

const DeleteProductModel = ({ isOpen, onClose, apiEndpoint, token, medicineId }) => {
    const [isLoading, setIsLoading] = useState(false);

    // Function to handle modal closure
    const closeModal = () => {
        setIsLoading(false);
        onClose();
    };

    // Function to handle keyboard events
    const handleKeyDown = (e) => {
        if (e.key === 'Escape') {
            closeModal();
        }
    };

    // Effect to add event listener for keyboard events
    useEffect(() => {
        if (isOpen) {
            window.addEventListener('keydown', handleKeyDown);
        } else {
            window.removeEventListener('keydown', handleKeyDown);
        }

        // Cleanup function to remove event listener
        return () => {
            window.removeEventListener('keydown', handleKeyDown);
        };
    }, [isOpen]); // Listen for changes in isOpen


    const handleDelete = async (e) => {
        e.preventDefault();
        setIsLoading(true);

        try {
            // Ensure medicineId is a string or number, not an object
            if (typeof medicineId !== 'string' && typeof medicineId !== 'number') {
                throw new Error('Invalid medicineId');
            }

            const url = `${apiEndpoint}/${medicineId}`;
            const response = await fetch(url, {
                method: 'DELETE',
                headers: {
                    'Authorization': token,
                    'Content-Type': 'application/json',
                },
            });

            console.log('Response Status:', response.status);
            if (!response.ok) {
                try {
                    const responseData = await response.clone().json();
                    console.error('Response Data:', responseData);
                    alert(`Error: ${responseData.message || 'Failed to delete the product.'}`);
                } catch (jsonError) {
                    const errorText = await response.text();
                    console.error('Response Text:', errorText);
                    alert(`Error: ${errorText || 'Failed to delete the product.'}`);
                }
            } else {
                alert('Product deleted successfully!');
                onClose();
                window.location.reload();
            }
        } catch (error) {
            console.error('Error:', error);
            alert('An error occurred while trying to delete the product. Please try again.');
        } finally {
            setIsLoading(false);
        }
    };

    if (!isOpen) return null;
    return (
        <>
            <div
                id="deleteModal"
                tabIndex={-1}
                aria-hidden="true"
                className={`${isOpen ? 'flex' : 'hidden'} overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full`}
            >
                <div className="relative p-4 w-full max-w-md max-h-full">
                    <div className="relative p-4 text-center bg-white rounded-lg shadow dark:bg-gray-800 sm:p-5">
                        <button
                            onClick={onClose}
                            type="button"
                            className="text-gray-400 absolute top-2.5 right-2.5 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 ml-auto inline-flex items-center dark:hover:bg-gray-600 dark:hover:text-white"
                            data-modal-toggle="deleteModal"
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
                        <svg
                            className="text-gray-400 dark:text-gray-500 w-11 h-11 mb-3.5 mx-auto"
                            aria-hidden="true"
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
                        <p className="mb-4 text-gray-500 dark:text-gray-300">
                            Are you sure you want to delete this item?
                        </p>
                        <div className="flex justify-center items-center space-x-4">
                            <button
                                onClick={onClose}
                                data-modal-toggle="deleteModal"
                                type="button"
                                className="py-2 px-3 text-sm font-medium text-gray-500 bg-white rounded-lg border border-gray-200 hover:bg-gray-100 focus:ring-4 focus:outline-none focus:ring-primary-300 hover:text-gray-900 focus:z-10 dark:bg-gray-700 dark:text-gray-300 dark:border-gray-500 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-600"
                            >
                                No, cancel
                            </button>
                            <button
                                type="submit"
                                className="py-2 px-3 text-sm font-medium text-center text-white bg-red-600 rounded-lg hover:bg-red-700 focus:ring-4 focus:outline-none focus:ring-red-300 dark:bg-red-500 dark:hover:bg-red-600 dark:focus:ring-red-900"
                                onClick={handleDelete}
                                disabled={isLoading}
                            >
                                {isLoading ? 'Deleting...' : "Yes, I'm sure"}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
};

export default DeleteProductModel;
