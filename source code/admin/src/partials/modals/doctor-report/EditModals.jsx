import React, { useEffect, useState } from "react";

const ModalEdit = ({ isOpen, onClose, apiEndpoint, token, medicineId, apiMedicine }) => {
    const [isLoading, setIsLoading] = useState(false);
    const [reportDetails, setReportDetails] = useState({
        disease: '',
        amount: 0,
        medicine_id: 0
    });
    const [medicines, setMedicines] = useState([]);

    const fetchReportDetails = async () => {
        setIsLoading(true);
        try {
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
            setReportDetails(data.data); // Assuming the data structure has {data: {...}}
        } catch (error) {
            console.error('Error fetching report details:', error.message);
        } finally {
            setIsLoading(false);
        }
    };

    const fetchMedicines = async () => {
        try {
            const url = `http://127.0.0.1:8080/medicines`; // Ensure this URL is correct
            console.log(url)
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
                const errorText = await response.text();
                throw new Error(`HTTP error! Status: ${response.status}, Response: ${errorText}`);
            }

            const responseText = await response.text();
            console.log('Response Text:', responseText); // Log the full response text

            try {
                const data = JSON.parse(responseText);
                console.log('Parsed Data:', data); // Log the parsed JSON data
                setMedicines(data.medicine || []); // Ensure data.medicine is an array
            } catch (e) {
                console.error('Failed to parse JSON response:', responseText);
                throw new Error('Failed to parse JSON response: ' + responseText);
            }
        } catch (error) {
            console.error('Error fetching medicines:', error.message);
        }
    };

    useEffect(() => {
        if (isOpen && medicineId) {
            fetchReportDetails();
            fetchMedicines();
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
        setReportDetails((prevDetails) => ({
            ...prevDetails,
            [name]: name === "medicine_id" ? parseInt(value, 10) : value,
        }));
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setIsLoading(true);

        try {
            const url = `${apiEndpoint}/${medicineId}`;
            const body = JSON.stringify(reportDetails);

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
            console.log('Report updated:', data);
            onClose();
            window.location.reload();
        } catch (error) {
            console.error('Error updating report details:', error.message);
        } finally {
            setIsLoading(false);
        }
    };

    const handleDelete = async (medicineId) => {
        setIsLoading(true);

        try {
            const url = `${apiEndpoint}/${medicineId}`;

            const response = await fetch(url, {
                method: 'DELETE',
                headers: {
                    'Authorization': `${token}`,
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }

            console.log('Report deleted');
            onClose();
            window.location.reload();
        } catch (error) {
            console.error('Error deleting report:', error.message);
        } finally {
            setIsLoading(false);
        }
    };

    if (!isOpen) return null;

    return (
        <div
            id="updateReportModal"
            tabIndex={-1}
            aria-hidden="true"
            className="fixed inset-0 z-50 flex items-center justify-center w-full h-full bg-black bg-opacity-50"
        >
            <div className="relative p-4 w-full max-w-2xl max-h-full">
                <div className="relative p-4 bg-white rounded-lg shadow dark:bg-gray-800 sm:p-5">
                    <div className="flex justify-between items-center pb-4 mb-4 rounded-t border-b sm:mb-5 dark:border-gray-600">
                        <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                            Update Doctor Report: {reportDetails?.patient?.name}
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
                                        htmlFor="disease"
                                        className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                                    >
                                        Disease
                                    </label>
                                    <input
                                        type="text"
                                        name="disease"
                                        id="disease"
                                        value={reportDetails.disease} // Fixing the case to match state
                                        onChange={handleChange}
                                        className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                        placeholder="Enter disease"
                                    />
                                </div>
                                <div>
                                    <label
                                        htmlFor="amount"
                                        className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                                    >
                                        Amount
                                    </label>
                                    <input
                                        type="number"
                                        name="amount"
                                        id="amount"
                                        value={reportDetails.amount} // Fixing the case to match state
                                        onChange={handleChange}
                                        className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                        placeholder="Enter amount"
                                    />
                                </div>
                                <div>
                                    <label
                                        htmlFor="medicine_id"
                                        className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                                    >
                                        Medicine
                                    </label>
                                    <select
                                        name="medicine_id"
                                        id="medicine_id"
                                        value={reportDetails.medicine_id} // Fixing the case to match state
                                        onChange={handleChange}
                                        className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                    >
                                        <option value="">Select Medicine</option>
                                        {medicines?.map((medicine) => (
                                            <option key={medicine.id} value={medicine.id}>
                                                {medicine.name}
                                            </option>
                                        ))}
                                    </select>
                                </div>
                            </div>
                            <div className="flex items-center space-x-4">
                                <button
                                    type="submit"
                                    className="text-white bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800"
                                >
                                    Update Report
                                </button>
                                <button
                                    type="button"
                                    className="text-red-600 bg-transparent border border-red-600 hover:bg-red-600 hover:text-white focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:border-red-500 dark:text-red-500 dark:hover:text-white dark:hover:bg-red-600 dark:focus:ring-red-900"
                                    onClick={() => handleDelete(medicineId)}
                                >
                                    Delete Report
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
