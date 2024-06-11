import React, { useEffect, useState } from "react";

const ModalEdit = ({ isOpen, onClose, apiEndpoint, token, medicineId }) => {
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
                method: 'GET',
                headers: {
                    'Authorization': `${token}`,
                    'Content-Type': 'application/json'
                }
            });

            if (response.status === 401) {
                throw new Error('Unauthorized access. Please check your token.');
            }

            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }

            const data = await response.json();
            setProductDetails(data.data);
        } catch (error) {
            console.error('Error fetching product details:', error.message);
        } finally {
            setIsLoading(false);
        }
    };

    useEffect(() => {
        if (isOpen && medicineId) {
            fetchProductDetails();
        }

        const handleKeyDown = (e) => {
            if (e.key === 'Escape') {
                onClose();
            }
        };

        if (isOpen) {
            window.addEventListener('keydown', handleKeyDown);
        } else {
            window.removeEventListener('keydown', handleKeyDown);
        }

        return () => {
            window.removeEventListener('keydown', handleKeyDown);
        };
    }, [isOpen, medicineId]);

    const handleChange = (e) => {
        const { name, value } = e.target;
        setProductDetails((prevDetails) => {
            let newValue = value;

            const [mainKey, subKey] = name.split(".");
            if (subKey) {
                return {
                    ...prevDetails,
                    [mainKey]: {
                        ...prevDetails[mainKey],
                        [subKey]: newValue,
                    },
                };
            }

            return {
                ...prevDetails,
                [name]: newValue,
            };
        });
    };


    const handleSubmit = async (e) => {
        e.preventDefault();
        setIsLoading(true);

        try {
            const url = `${apiEndpoint}/${medicineId}`;

            // Make a copy of productDetails to avoid mutating state directly
            const updatedProductDetails = { ...productDetails };

            // Convert SizeCircumference to an integer if it exists
            if (updatedProductDetails.SizeCircumference) {
                updatedProductDetails.SizeCircumference = parseInt(updatedProductDetails.SizeCircumference, 10);
            }

            // Convert updatedProductDetails to JSON string
            const body = JSON.stringify(updatedProductDetails);

            const response = await fetch(url, {
                method: 'PUT',
                headers: {
                    'Authorization': `${token}`,
                    'Content-Type': 'application/json'
                },
                body: body,
            });

            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }

            const data = await response.json();
            console.log('Product updated:', data);
            onClose();
            window.location.reload();
        } catch (error) {
            console.error('Error updating product details:', error.message);
        } finally {
            setIsLoading(false);
        }
    };




    if (!isOpen) return null;

    return (
        <div
            id="updateProductModal"
            tabIndex={-1}
            aria-hidden="true"
            className="fixed inset-0 z-50 flex items-center justify-center w-full h-full bg-black bg-opacity-50"
        >
            <div className="relative p-4 w-full max-w-2xl max-h-full">
                <div className="relative p-4 bg-white rounded-lg shadow dark:bg-gray-800 sm:p-5">
                    <div className="flex justify-between items-center pb-4 mb-4 rounded-t border-b sm:mb-5 dark:border-gray-600">
                        <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                            Update Nurse Report : {productDetails?.patient?.name}
                        </h3>
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
                    {isLoading ? (
                        <div className="flex justify-center items-center h-full">
                            <span className="text-gray-900 dark:text-white">Loading...</span>
                        </div>
                    ) : (
                        <form onSubmit={handleSubmit}>
                            <div className="grid gap-4 mb-4 sm:grid-cols-2">
                                <div>
                                    <label
                                        htmlFor="temperature"
                                        className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                                    >
                                        Temperature
                                    </label>
                                    <input
                                        type="text"
                                        name="temperature"
                                        id="temperature"
                                        defaultValue={productDetails?.temperature || ""}
                                        onChange={handleChange}
                                        className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                        placeholder="none"
                                    />
                                </div>
                                <div>
                                    <label
                                        htmlFor="systole"
                                        className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                                    >
                                        Systole
                                    </label>
                                    <input
                                        type="text"
                                        name="systole"
                                        id="systole"
                                        defaultValue={productDetails?.systole || ""}
                                        onChange={handleChange}
                                        className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                        placeholder="none"
                                    />
                                </div>
                                <div>
                                    <label
                                        htmlFor="diastole"
                                        className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                                    >
                                        Diastole
                                    </label>
                                    <input
                                        type="text"
                                        name="diastole"
                                        id="diastole"
                                        defaultValue={productDetails?.diastole || ""}
                                        onChange={handleChange}
                                        className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus
                                        dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                        placeholder="none"
                                    />
                                </div>
                                <div>
                                    <label
                                        htmlFor="pulse"
                                        className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                                    >
                                        Pulse
                                    </label>
                                    <input
                                        type="text"
                                        name="pulse"
                                        id="pulse"
                                        defaultValue={productDetails?.pulse || ""}
                                        onChange={handleChange}
                                        className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                        placeholder="none"
                                    />
                                </div>
                                <div>
                                    <label
                                        htmlFor="respiration"
                                        className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                                    >
                                        Respiration
                                    </label>
                                    <input
                                        type="text"
                                        name="respiration"
                                        id="respiration"
                                        defaultValue={productDetails?.respiration || ""}
                                        onChange={handleChange}
                                        className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                        placeholder="none"
                                    />
                                </div>
                                <div>
                                    <label
                                        htmlFor="abdominal_circumference"
                                        className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                                    >
                                        Abdominal Circumference
                                    </label>
                                    <input
                                        type="number"
                                        value={productDetails?.SizeCircumference || 0}
                                        name="SizeCircumference"
                                        id="SizeCircumference"
                                        onChange={handleChange}
                                        className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                        placeholder="none"
                                    />
                                </div>
                                <div>
                                    <label
                                        htmlFor="allergy"
                                        className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                                    >
                                        Allergy
                                    </label>
                                    <input
                                        type="text"
                                        name="allergy"
                                        id="allergy"
                                        defaultValue={productDetails?.allergy || ""}
                                        onChange={handleChange}
                                        className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                        placeholder="none"
                                    />
                                </div>


                            </div>
                            <div className="flex items-center space-x-4">
                                <button
                                    type="submit"
                                    className="text-white bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800"
                                >
                                    Update product
                                </button>
                                <button
                                    type="button"
                                    className="text-red-600 inline-flex items-center hover:text-white border border-red-600 hover:bg-red-600 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:border-red-500 dark:text-red-500 dark:hover:text-white dark:hover:bg-red-600 dark:focus:ring-red-900"
                                    onClick={() => {
                                    }}
                                >
                                    <svg
                                        className="mr-1 -ml-1 w-5 h-5"
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

                        </form>
                    )}
                </div>
            </div>
        </div>
    );
};

export default ModalEdit;
