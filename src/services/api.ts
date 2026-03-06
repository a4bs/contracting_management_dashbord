import axios from 'axios';
import { useToast } from 'vue-toast-notification';
import 'vue-toast-notification/dist/theme-sugar.css';

const $toast = useToast();

const api = axios.create({
    baseURL: import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000',
    headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
    },
});

api.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem('token');
        if (token && config.headers) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

api.interceptors.response.use(
    (response) => {
        return response.data;
    },
    (error) => {
        const errorMessage = error.response?.data?.message || 'حدث خطأ غير متوقع';

        if (error.response?.status === 401) {
            if (error.config?.url !== '/api/login') {
                $toast.error('انتهت الجلسة، يرجى تسجيل الدخول مجدداً.', { position: 'bottom-right' });
                localStorage.removeItem('token');
                localStorage.removeItem('user');
                if (window.location.pathname !== '/login') {
                    window.location.href = '/login';
                }
            }
        } else if (error.response?.status === 422) {
            // Validation error
            const errors = error.response?.data?.errors;
            if (errors) {
                Object.values(errors).forEach((errArray: any) => {
                    if (Array.isArray(errArray)) {
                        errArray.forEach((msg: string) => $toast.error(msg, { position: 'bottom-right' }));
                    }
                });
            } else {
                $toast.error(errorMessage, { position: 'bottom-right' });
            }
        } else {
            $toast.error(errorMessage, { position: 'bottom-right' });
        }
        return Promise.reject(error);
    }
);

export default api;
