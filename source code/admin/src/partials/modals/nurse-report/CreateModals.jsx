import React, { useState, useEffect } from 'react';
import { jwtDecode } from 'jwt-decode';

const ModalCreate = ({ isOpen, onClose, apiEndpoint }) => {
    const [formData, setFormData] = useState({
        temperature: '',
        systole: '',
        diastole: '',
        pulse: '',
        oxygen_saturation: '',
        respiration: '',
        abdominal_circumference: 0,
        allergy: '',
        patient_id: 0,
    });

    const [staffNurseId, setStaffNurseId] = useState(0);
    const [error, setError] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const [appointments, setAppointments] = useState([]);

    useEffect(() => {
        const token = localStorage.getItem('token');
        if (token) {
            const decodedToken = jwtDecode(token);
            setStaffNurseId(decodedToken.id);
        }
    }, []);


    useEffect(() => {
        const fetchData = async () => {
            const token = localStorage.getItem('token');
            try {
                const response = await fetch('http://127.0.0.1:8080/appointments-approved', {
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
    }, []);

    useEffect(() => {
        const handleEsc = (event) => {
            if (event.key === 'Escape') {
                onClose();
            }
        };

        if (isOpen) {
            window.addEventListener('keydown', handleEsc);
        } else {
            window.removeEventListener('keydown', handleEsc);
        }

        return () => window.removeEventListener('keydown', handleEsc);
    }, [isOpen, onClose]);

    const handleChange = (e) => {
        const { name, value, type } = e.target;
        const val = type === 'number' ? parseInt(value, 10) : value;
        setFormData({
            ...formData,
            [name]: name === 'userId' ? parseInt(val, 10) : val,
        });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();

        if (!formData.temperature || !formData.systole || !formData.diastole || !formData.pulse || !formData.oxygen_saturation || !formData.respiration || !formData.abdominal_circumference || !formData.allergy || formData.userId === 0) {
            alert('Please fill in all required fields.');
            return;
        }

        try {
            const formDataToSend = new FormData();
            formDataToSend.append('temperature', formData.temperature);
            formDataToSend.append('systole', formData.systole);
            formDataToSend.append('diastole', formData.diastole);
            formDataToSend.append('pulse', formData.pulse);
            formDataToSend.append('oxygen_saturation', formData.oxygen_saturation);
            formDataToSend.append('respiration', formData.respiration);
            formDataToSend.append('abdominal_circumference', formData.abdominal_circumference);
            formDataToSend.append('allergy', formData.allergy);
            formDataToSend.append('patient_id', parseInt(formData.patient_id, 10));
            formDataToSend.append('staff_nurse_id', staffNurseId);

            console.log('Form Data to be sent:', {
                temperature: formData.temperature,
                systole: formData.systole,
                diastole: formData.diastole,
                pulse: formData.pulse,
                oxygen_saturation: formData.oxygen_saturation,
                respiration: formData.respiration,
                abdominal_circumference: formData.abdominal_circumference,
                allergy: formData.allergy,
                patient_id: parseInt(formData.userId, 10),
                staff_nurse_id: staffNurseId,
            });

            const token = localStorage.getItem('token');
            const response = await fetch(apiEndpoint, {
                method: 'POST',
                headers: {
                    'Authorization': `${token}`,
                },
                body: formDataToSend,
            });

            const responseData = await response.json();

            if (response.ok) {
                alert('Nurse report created successfully!');
                onClose();
                window.location.reload();
            } else {
                alert(`Error: ${responseData.message}`);
            }
        } catch (error) {
            alert(`Error: ${error.message}`);
        }
    };

    if (!isOpen) return null;
    return (
        <div
            id="createProductModal"
            tabIndex={-1}
            aria-hidden="true"
            className="fixed inset-0 z-50 flex items-center justify-center w-full h-full bg-black bg-opacity-50"
        >
            <div className="relative p-4 w-full max-w-2xl max-h-full">
                <div className="relative p-4 bg-white rounded-lg shadow dark:bg-gray-800 sm:p-5">
                    <div className="flex justify-between items-center pb-4 mb-4 rounded-t border-b sm:mb-5 dark:border-gray-600">
                        <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                            Add Nurse Report
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
                                    value={formData.temperature}
                                    onChange={handleChange}
                                    className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                    placeholder=""
                                    required
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
                                    value={formData.systole}
                                    onChange={handleChange}
                                    className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                    placeholder=""
                                    required
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
                                    value={formData.diastole}
                                    onChange={handleChange}
                                    className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                    placeholder=""
                                    required
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
                                    value={formData.pulse}
                                    onChange={handleChange}
                                    className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                    placeholder=""
                                    required
                                />
                            </div>

                            <div>
                                <label
                                    htmlFor="oxygen_saturation"
                                    className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                                >
                                    Oxygen Saturation
                                </label>
                                <input
                                    type="text"
                                    name="oxygen_saturation"
                                    id="oxygen_saturation"
                                    value={formData.oxygen_saturation}
                                    onChange={handleChange}
                                    className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                    placeholder=""
                                    required
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
                                    value={formData.respiration}
                                    onChange={handleChange}
                                    className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                    placeholder=""
                                    required
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
                                    name="abdominal_circumference"
                                    id="abdominal_circumference"
                                    value={formData.abdominal_circumference}
                                    onChange={handleChange}
                                    className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                    placeholder=""
                                    required
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
                                    value={formData.allergy}
                                    onChange={handleChange}
                                    className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                    placeholder=""
                                    required
                                />
                            </div>

                            <div className="col-span-2">
                                <label
                                    htmlFor="userId"
                                    className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                                >
                                    Patient ID
                                </label>
                                <select
                                    name="userId"
                                    id="userId"
                                    value={formData.userId}
                                    onChange={handleChange}
                                    className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                    required
                                >
                                    <option value="">Select a patient</option>
                                    {appointments.map(appointment => (
                                        <option key={appointment.id} value={appointment.id}>
                                            {appointment.id}
                                        </option>
                                    ))}
                                </select>
                            </div>
                        </div>
                        <button
                            type="submit"
                            className="text-white bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800 inline-flex items-center"
                        >
                            <svg
                                className="mr-1 -ml-1 w-6 h-6"
                                fill="currentColor"
                                viewBox="0 0 20 20"
                                xmlns="http://www.w3.org/2000/svg"
                            >
                                <path
                                    fillRule="evenodd"
                                    d="M10 5a1 1 0 011 1v3h3a1 1 0 110 2h-3v3a1 1 0 11-2 0v-3H6a1 1 0 110-2h3V6a1 1 0 011-1z"
                                    clipRule="evenodd"
                                />
                            </svg>
                            Add new nurse report
                        </button>
                    </form>
                </div>
            </div>
        </div>
    );
};

export default ModalCreate;

