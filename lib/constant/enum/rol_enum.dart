import 'package:contracting_management_dashbord/model/user/user_model.dart';

enum RolEnum {
  admin('admin');

  const RolEnum(this.value);
  final String value;
}

enum PermissionCategoryEnum {
  users('users', 'شاشة المستخدمين'),
  boxes('boxes', 'شاشة الصناديق'),
  units('units', 'شاشة الوحدات السكنية'),
  projects('projects', 'شاشة المشاريع'),
  archives('archives', 'شاشة الأرشيف'),
  bonds('bonds', 'شاشة السندات'),
  bills('bills', 'شاشة الفواتير المبيعة'),
  customers('customers', 'شاشة الزبائن'),
  projectTypes('project-types', 'شاشة نوع المشاريع'),
  settings('settings', 'شاشة الاعدادات العامة'),

  dashboard('dashboard', 'شاشة الداشبورد');

  final String name;
  final String displayName;

  const PermissionCategoryEnum(this.name, this.displayName);

  // Optional: a method to retrieve PermissionCategory by id
  static PermissionCategoryEnum? getById(String name) {
    return PermissionCategoryEnum.values.firstWhere(
      (action) => action.name == name,
    );
  }
}

enum PermeationEnum {
  addPermission(1, 'add-permission', ' إضافة صلاحية', null),
  addRole(2, 'add-role', ' إضافة دور', null),
  showUsers(3, 'show-users', 'عرض المستحدمين', PermissionCategoryEnum.users),
  addUser(4, 'add-user', 'إضافة مستخدم', PermissionCategoryEnum.users),
  editUser(5, 'edit-user', 'تعديل المستخدم', PermissionCategoryEnum.users),
  deleteUser(6, 'delete-user', 'حذف المستخدم', PermissionCategoryEnum.users),
  changeUserState(
    7,
    'change-user-state',
    'تغيير حالة المستخدم',
    PermissionCategoryEnum.users,
  ),
  showBoxes(8, 'show-boxes', 'عرض الصناديق', PermissionCategoryEnum.boxes),
  addBox(9, 'add-box', 'إضافة صندوق', PermissionCategoryEnum.boxes),
  editBox(10, 'edit-box', 'تعديل الصندوق', PermissionCategoryEnum.boxes),
  deleteBox(11, 'delete-box', 'حذف الصندوق', PermissionCategoryEnum.boxes),
  showUnits(
    12,
    'show-units',
    'عرض الوحدات السكنية',
    PermissionCategoryEnum.units,
  ),
  addUnit(13, 'add-unit', 'إضافة وحدة سكنية', PermissionCategoryEnum.units),
  editUnit(14, 'edit-unit', 'تعديل الوحدة سكنية', PermissionCategoryEnum.units),
  deleteUnit(
    15,
    'delete-unit',
    'حذف الوحدة سكنية',
    PermissionCategoryEnum.units,
  ),
  showProjects(
    16,
    'show-projects',
    'عرض المشاريع',
    PermissionCategoryEnum.projects,
  ),
  addProject(17, 'add-project', 'إضافة مشروع', PermissionCategoryEnum.projects),
  editProject(
    18,
    'edit-project',
    'تعديل المشروع',
    PermissionCategoryEnum.projects,
  ),
  deleteProject(
    19,
    'delete-project',
    'حذف المشروع',
    PermissionCategoryEnum.projects,
  ),
  showArchives(
    20,
    'show-archives',
    'عرض الأرشيف',
    PermissionCategoryEnum.archives,
  ),
  addArchive(21, 'add-archive', 'إضافة ارشيف', PermissionCategoryEnum.archives),
  editArchive(
    22,
    'edit-archive',
    'تعديل الارشيف',
    PermissionCategoryEnum.archives,
  ),
  deleteArchive(
    23,
    'delete-archive',
    'حذف الارشيف',
    PermissionCategoryEnum.archives,
  ),
  showBonds(24, 'show-bonds', 'عرض السندات', PermissionCategoryEnum.bonds),
  addBondDebit(
    25,
    'add-bond-debit',
    'إضافة سند ايداع',
    PermissionCategoryEnum.bonds,
  ),
  addBondCredit(
    26,
    'add-bond-credit',
    'إضافة سند سحب',
    PermissionCategoryEnum.bonds,
  ),
  approveBond(
    27,
    'approve-bond',
    'مصادقة السند (الموافقة عليه)',
    PermissionCategoryEnum.bonds,
  ),
  editBond(28, 'edit-bond', 'تعديل السند', PermissionCategoryEnum.bonds),
  deleteBond(29, 'delete-bond', 'حذف السند', PermissionCategoryEnum.bonds),
  showBills(
    30,
    'show-bills',
    'عرض الفواتير المبيعة',
    PermissionCategoryEnum.bills,
  ),
  addBill(31, 'add-bill', 'إضافة فاتورة المبيع', PermissionCategoryEnum.bills),
  editBill(
    32,
    'edit-bill',
    'تعديل الفاتورة المبيع',
    PermissionCategoryEnum.bills,
  ),
  deleteBill(
    33,
    'delete-bill',
    'حذف الفاتورة المبيع',
    PermissionCategoryEnum.bills,
  ),
  showCustomers(
    34,
    'show-customers',
    'عرض الزبائن',
    PermissionCategoryEnum.customers,
  ),
  addCustomer(
    35,
    'add-customer',
    'إضافة زبون',
    PermissionCategoryEnum.customers,
  ),
  editCustomer(
    36,
    'edit-customer',
    'تعديل الزبون',
    PermissionCategoryEnum.customers,
  ),
  deleteCustomer(
    37,
    'delete-customer',
    'حذف الزبون',
    PermissionCategoryEnum.customers,
  ),
  saleToCustomer(
    38,
    'sale-to-customer',
    'البيع الى الزبون',
    PermissionCategoryEnum.customers,
  ),
  showProjectTypes(
    39,
    'show-project-types',
    'عرض نوع المشاريع',
    PermissionCategoryEnum.projectTypes,
  ),
  addProjectType(
    40,
    'add-project-type',
    'إضافة نوع المشروع',
    PermissionCategoryEnum.projectTypes,
  ),
  editProjectType(
    41,
    'edit-project-type',
    'تعديل نوع المشروع',
    PermissionCategoryEnum.projectTypes,
  ),
  deleteProjectType(
    42,
    'delete-project-type',
    'حذف نوع المشروع',
    PermissionCategoryEnum.projectTypes,
  ),

  // Bill Payment & Installment Management
  addPaymentToBill(
    43,
    'add-payment-to-bill',
    'إضافة تسديد للفاتورة',
    PermissionCategoryEnum.bills,
  ),
  editBondStatus(
    44,
    'edit-bond-status',
    'تعديل حالة السند (مدفوع/جزئي)',
    PermissionCategoryEnum.bonds,
  ),
  deleteBondFromBill(
    45,
    'delete-bond-from-bill',
    'حذف سند من الفاتورة',
    PermissionCategoryEnum.bills,
  ),

  // Unit Price Management
  editUnitPrice(
    46,
    'edit-unit-price',
    'تعديل سعر الوحدة',
    PermissionCategoryEnum.units,
  ),

  // Advanced Bill Editing
  editBillPrice(
    47,
    'edit-bill-price',
    'تعديل سعر الفاتورة',
    PermissionCategoryEnum.bills,
  ),

  // Settings
  showSettings(
    48,
    'show-settings',
    'عرض الاعدادات العامة',
    PermissionCategoryEnum.settings,
  ),
  editSettings(
    49,
    'edit-settings',
    'تعديل الاعدادات العامة',
    PermissionCategoryEnum.settings,
  ),

  // Dashboard
  showDashboard(
    50,
    'show-dashboard',
    'عرض الداشبورد',
    PermissionCategoryEnum.dashboard,
  );

  final int id;
  final String name;
  final String displayName;
  final PermissionCategoryEnum? category;

  const PermeationEnum(this.id, this.name, this.displayName, this.category);

  // Optional: a method to retrieve Permation by id
  static PermeationEnum? getById(int id) {
    try {
      return PermeationEnum.values.firstWhere((action) => action.id == id);
    } catch (_) {
      return null;
    }
  }

  static PermeationEnum? fromModel(PermissionModel model) {
    if (model.id != null) {
      return getById(model.id!);
    }
    try {
      return PermeationEnum.values.firstWhere((e) => e.name == model.name);
    } catch (_) {
      return null;
    }
  }
}
