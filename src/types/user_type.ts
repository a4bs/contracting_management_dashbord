export class UserModel {
    id: number;
    username: string;
    email: string;
    role: string;
    company_id: number;
    token?: string;

    constructor(data: any) {
        this.id = data?.id || 0;
        this.username = data?.username || '';
        this.email = data?.email || '';
        this.role = data?.role || '';
        this.company_id = data?.company_id || 0;
        this.token = data?.token;
    }


    static fromJson(json: any): UserModel {
        return new UserModel(json);
    }
}