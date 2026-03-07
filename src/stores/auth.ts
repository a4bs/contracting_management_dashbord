import { defineStore } from 'pinia';
import { post } from '@/service/axios';
import authApi from '@/constant/app-api';
import APP_KEY from '@/constant/app-key';
import { UserModel } from '@/types/user_type';
import { UserTool } from '@/tools/user_tool';

export const useAuthStore = defineStore('auth', {
    state: () => ({
        user: UserTool.getUser() as UserModel | null,
    }),

    getters: {
        isLoggedIn: (state) => !!state.user,
        userInfo: (state) => state.user,
    },

    actions: {
        /**
         * تسجيل الدخول
         */
        async login(credentials: any) {
            try {
                // استدعاء الـ API الخاص بتسجيل الدخول
                const response = await post(authApi.login, credentials);

                // التحقق من حالة الرد من الـ API
                if (!response.status) {
                    throw new Error(response.message || 'فشل تسجيل الدخول');
                }

                // البيانات موجودة داخل response.data
                const userData = response.data;

                // تحويل البيانات إلى UserModel
                const user = UserModel.fromJson(userData);

                // حفظ البيانات في State
                this.user = user;

                // حفظ بيانات الاستجابة الكاملة (التي تحتوي على التوكن) في localStorage
                localStorage.setItem(APP_KEY.userInfo, JSON.stringify(userData));

                return user;
            } catch (error: any) {
                console.error('Login failed:', error.message);
                throw error;
            }
        },

        /**
         * تسجيل الخروج
         */
        logout() {
            this.user = null;
            UserTool.logout();
        },

        /**
         * تحديث بيانات المستخدم من التخزين المحلي
         */
        refreshUser() {
            this.user = UserTool.getUser();
        }
    }
});