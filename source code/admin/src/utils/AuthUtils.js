import { toast } from 'react-toastify';

export const handleSubmit = async (
    e,
    username,
    password,
    setLoading,
    setIsAuthenticated,
    navigate
) => {
    e.preventDefault();
    setLoading(true);

    try {
        const response = await fetch('http://127.0.0.1:8080/staffLogin', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ username, password }),
        });

        const data = await response.json();
        setLoading(false);

        if (response.ok) {
            const token = data.token;
            console.log('Token', token);
            if (token == null) {
                setIsAuthenticated(false);
            } else {
                localStorage.setItem('token', token);
                setIsAuthenticated(true);
                navigate('/'); // Navigate to the desired page after successful login
                return token; // Return token after successful login
            }
        } else {
            alert(data.message);
            // toast.error(data.message || 'Login failed. Please try again.');
        }
    } catch (error) {
        setLoading(false);
        toast.error('An error occurred. Please try again.');
    }
};

export const handleRegister = async (
    e,
    name,
    username,
    password,
    confirmPassword,
    role,
    setLoading,
    navigate
) => {
    e.preventDefault();
    setLoading(true);

    if (password !== confirmPassword) {
        setLoading(false);
        toast.error('Passwords do not match.');
        return;
    }

    // Convert role to int
    const roleInt = parseInt(role, 10);

    const requestBody = { name, username, password, role: roleInt };

    console.log('Request Body:', requestBody);

    try {
        const response = await fetch('http://127.0.0.1:8080/staff', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(requestBody), // Include role
        });

        const data = await response.json();
        setLoading(false);

        if (response.ok) {
            toast.success('Registration successful. Please log in.');
            navigate('/signin');  // Navigate to the sign-in page after successful registration
        } else {
            toast.error(data.message || 'Registration failed. Please try again.');
        }
    } catch (error) {
        setLoading(false);
        toast.error('An error occurred. Please try again.');
    }
};

export const getStoredAuthToken = () => {
    const token = localStorage.getItem('token');
    return token ? token : null;
};

