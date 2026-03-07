import APP_KEY from '@/constant/app-key';
import { UserModel } from '@/types/user_type';

export class UserTool {
    /**
     * الحصول على كائن المستخدم الكامل
     */
    static getUser(): UserModel | null {
        const userInfoRaw = localStorage.getItem(APP_KEY.userInfo);
        if (!userInfoRaw) return null;

        try {
            const userInfo = JSON.parse(userInfoRaw);
            return UserModel.fromJson(userInfo);
        } catch (error) {
            console.error('Error parsing userInfo from localStorage', error);
            return null;
        }
    }

    /**
     * الحصول على التوكن مباشرة
     */
    static getToken(): string | undefined {
        return this.getUser()?.token;
    }

    /**
     * تسجيل الخروج ومسح البيانات
     */
    static logout() {
        localStorage.removeItem(APP_KEY.userInfo);
        window.location.href = '/login';
    }
}