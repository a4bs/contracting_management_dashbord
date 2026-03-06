export const API_ROUTES = {
    // Auth
    LOGIN: '/api/login',
    LOGOUT: '/api/logout',
    CURRENT_USER: '/api/user',

    // Companies (Super Admin)
    COMPANIES: '/api/super-admin/companies',
    COMPANY_DETAILS: (id: string | number) => `/api/super-admin/companies/${id}`,

    // Heavy Equipment (Super Admin / Other Role)
    HEAVY_EQUIPMENT_EQUIPMENT: '/api/heavy-equipment/equipment',
    HEAVY_EQUIPMENT_DRIVERS: '/api/heavy-equipment/drivers',
    HEAVY_EQUIPMENT_OPERATIONS: '/api/heavy-equipment/operations',
    HEAVY_EQUIPMENT_EXPENSES: '/api/heavy-equipment/expenses',
};
