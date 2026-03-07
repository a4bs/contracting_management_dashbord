import axios from 'axios';
import { UserTool } from '@/tools/user_tool';
import type { ApiResponse } from '@/types/response_type';

// Create axios instance
const service = axios.create({
    baseURL: import.meta.env.VITE_API_BASE_URL || '/api', // Default to /api if env not set
    timeout: 15000, // Request timeout
});

// Request interceptor
service.interceptors.request.use(
    (config: any) => {
        // الحصول على التوكن من UserTool
        const token = UserTool.getToken();

        if (token) {
            config.headers['Authorization'] = `Bearer ${token}`;
        }

        // Add Accept header for JSON
        config.headers['Accept'] = 'application/json';

        return config;
    },
    (error: any) => {
        console.error('Request Error:', error);
        return Promise.reject(error);
    }
);

// Response interceptor
service.interceptors.response.use(
    (response: any) => {
        // Return the response data directly as ApiResponse
        return response.data;
    },
    (error: any) => {
        const { response } = error;

        if (response) {
            switch (response.status) {
                case 401:
                    // تسجيل الخروج عبر UserTool
                    UserTool.logout();
                    break;
                case 403:
                    console.error('Access forbidden (403)');
                    break;
                case 404:
                    console.error('Not found (404)');
                    break;
                case 500:
                    console.error('Internal server error (500)');
                    break;
                default:
                    console.error(`Error ${response.status}:`, response.data.message || 'Unknown error');
            }
        } else {
            console.error('Network Error / Timeout:', error.message);
        }

        return Promise.reject(error);
    }
);

/**
 * دالة GET لجلب البيانات
 */
export const get = <T = any>(url: string, params?: any): Promise<ApiResponse<T>> => {
    return service.get(url, { params });
};

/**
 * دالة POST لإضافة بيانات (Add)
 */
export const post = <T = any>(url: string, data?: any): Promise<ApiResponse<T>> => {
    return service.post(url, data);
};

/**
 * دالة PUT لتحديث البيانات
 */
export const put = <T = any>(url: string, data?: any): Promise<ApiResponse<T>> => {
    return service.put(url, data);
};

/**
 * دالة DELETE لحذف البيانات
 */
export const del = <T = any>(url: string): Promise<ApiResponse<T>> => {
    return service.delete(url);
};

export default service;