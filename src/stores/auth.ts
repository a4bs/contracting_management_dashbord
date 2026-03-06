import { defineStore } from 'pinia';
import api from '../services/api';
import { API_ROUTES } from '../constants/apiRoutes';

export interface User {
    id: number;
    name: string;
    username: string;
    email: string;
    role: string;
    company_id: number | null;
}

export const useAuthStore = defineStore('auth', {
    state: () => ({
        user: JSON.parse(localStorage.getItem('user') || 'null') as User | null,
        token: localStorage.getItem('token') || null as string | null,
        loading: false,
    }),
    getters: {
        isAuthenticated: (state) => !!state.token && !!state.user,
        isSuperAdmin: (state) => state.user?.role === 'SUPER_ADMIN',
    },
    actions: {
        async login(credentials: any) {
            this.loading = true;
            try {
                const response: any = await api.post(API_ROUTES.LOGIN, credentials);
                if (response.status) {
                    this.token = response.data.token;
                    this.user = response.data;

                    localStorage.setItem('token', this.token as string);
                    localStorage.setItem('user', JSON.stringify(this.user));

                    return true;
                }
                return false;
            } catch (error) {
                throw error;
            } finally {
                this.loading = false;
            }
        },
        async fetchUser() {
            if (!this.token) return;
            try {
                const response: any = await api.get(API_ROUTES.CURRENT_USER);
                if (response.status) {
                    this.user = response.data;
                    localStorage.setItem('user', JSON.stringify(this.user));
                }
            } catch (error) {
                this.logout();
            }
        },
        async logout() {
            try {
                if (this.token) {
                    await api.post(API_ROUTES.LOGOUT);
                }
            } catch (err) {
                // Ignored
            } finally {
                this.token = null;
                this.user = null;
                localStorage.removeItem('token');
                localStorage.removeItem('user');
                window.location.href = '/login';
            }
        }
    }
});
