class AppApi {
  static const String login = 'login';

  static final user = ApiUser();
  static final role = ApiRole();
  static final project = ApiProject();
  static final unit = ApiUnit();
  static final box = ApiBox();
  static final bond = ApiBond();
  static final customer = ApiCustomer();
  static final bill = ApiBill();
  static final archive = ApiArchive();
  static final percentage = ApiPercentage();
  static final dashboard = ApiDashboard();
  static final notification = ApiNotification();
  static final notificationReceivers = ApiNotificationReceivers();
  static final projectStatus = ApiProjectStatus();
  static final staff = ApiStaff();

  // Keep old names for backward compatibility if needed,
  // but pointing to the new instances.
  static final userApi = user;
  static final rolAndPermission = role;
  static final apiProject = project;
  static final apiUnit = unit;
  static final apiBox = box;
  static final apiBond = bond;
  static final apiCustomer = customer;
  static final apiBill = bill;
  static final apiArchive = archive;
  static final apiPercentage = percentage;
  static final apiDashboard = dashboard;
}

class ApiUser {
  static const String base = 'user';

  String get all => base;
  String one(dynamic id) => '$base/$id';
  String update(dynamic id) => '$base/$id';
}

class ApiProject {
  static const String base = 'project';
  static const String typeBase = 'project-type';

  // Projects
  String get projects => base;
  String project(String id) => '$base/$id';
  String get projectStatus => 'project-status';
  String updateProject(String id) => '$base/$id';
  String deleteProject(String id) => '$base/$id';

  String getProjectByTypeId({dynamic page, dynamic typeId}) =>
      '$base/filter?project_type_id=${typeId ?? ''}&page=${page ?? ''}';

  String getProjectByFilter() => '$base/filter';

  // Project Types
  String get projectTypes => typeBase;
  String projectType(String id) => '$typeBase/$id';
  String updateProjectType(String id) => '$typeBase/$id';
  String deleteProjectType(String id) => '$typeBase/$id';
}

class ApiRole {
  static const String base = 'role-permission';

  // Roles
  String get roles => '$base/roles';
  String role(String id) => '$roles/$id';
  String rolePermissions(String id) => '$roles/$id/permissions';
  String addPermissionToRole(String roleId, String permissionId) =>
      '$roles/$roleId/permissions/$permissionId';
  String updatePermissionsToRole(String id) => '$roles/$id/permissions';

  // Permissions
  String get permissions => '$base/permissions';
  String permission(String id) => '$permissions/$id';
  String permissionRoles(String id) => '$permissions/$id/roles';

  // User relations
  String userRoles(String userId) => '$base/users/$userId/roles';
  String userRole(String userId, String roleId) =>
      '$base/users/$userId/roles/$roleId';
  String userPermissions(String userId) => '$base/users/$userId/permissions';
  String userPermission(String userId, String permissionId) =>
      '$base/users/$userId/permissions/$permissionId';
  String updatePermissionsToUser(String userId) =>
      '$base/users/$userId/permissions';
}

class ApiUnit {
  static const String base = 'unit';

  String get units => base;
  String one(dynamic id) => '$base/$id';
  String get saleUnit => '$base/sale/unit';
  String get filter => base;

  String unitByProject(dynamic id) => '$base/project/$id';
  String unitByCustomer(dynamic id) => '$base/customer/$id';
  String update(dynamic id) => '$base/$id';
}

class ApiBox {
  static const String base = 'box';

  String get boxes => base;
  String one(dynamic id) => '$base/$id';
  String update(dynamic id) => '$base/$id';
  String filter(dynamic id) => '$base/filter?project_id=$id';
  String get filterAll => '$base/filter';
}

class ApiBond {
  static const String base = 'bond';

  String get bonds => base;
  String one(dynamic id) => '$base/$id';
  String update(dynamic id) => '$base/$id';
  String approve(dynamic id) => '$base/$id/make-approve';
  String approvedUsers(dynamic id) => '$base/$id/approved-users';
  String get filter => '$base/filter';
  String get uploadFile => '$base/upload-file';
  String get convert => '$base/exchange-two-boxes';
}

class ApiCustomer {
  static const String base = 'customer';

  String get customers => '$base/filter';
  String one(dynamic id) => '$base/$id';
  String update(dynamic id) => '$base/$id';
  String get uploadFile => '$base/upload-file';
}

class ApiBill {
  static const String base = 'bill';

  String get bills => base;
  String one(dynamic id) => '$base/$id';
  String update(dynamic id) => '$base/$id';
  String delete(dynamic id) => '$base/$id';
  String get filter => '$base/filter';
  String get advance => '$base/advance';
  String syncBonds(dynamic id) => '$base/$id/sync-bonds';
}

class ApiArchive {
  static const String base = 'archive';

  String get archives => base;
  String one(dynamic id) => '$base/$id';
  String update(dynamic id) => '$base/$id';
  String delete(dynamic id) => '$base/$id';
  String get filter => '$base/filter';
  String get uploadFile => '$base/upload-file';
  // Archive Types
  static const String baseType = 'archive-type';
  String oneArchiveType(dynamic id) => '$baseType/$id';
  String updateArchiveType(dynamic id) => '$baseType/$id';
  String deleteArchiveType(dynamic id) => '$baseType/$id';
  String get getArchiveTypes => '$baseType';
}

class ApiPercentage {
  static const String base = 'percentage';

  String get percentages => base;
  String one(int id) => '$base/$id';
  String update(int id) => '$base/$id';
  String delete(int id) => '$base/$id';
}

class ApiDashboard {
  static const String base = 'dashboard';
  static const String total = '$base/total';
  static const String daily = '$base/daily';

  // Totals
  String get balance => '$total/balance';
  String get boxes => '$total/boxes';
  String get customers => '$total/customers';
  String get units => '$total/units';
  String get users => '$total/users';
  String get projects => '$total/projects';

  // Daily Stats
  String get debitCustomersCount => '$daily/debit-customers-count';
  String get debitCreditBalance => '$daily/debit-credit-balance';
}

class ApiNotification {
  static const String base = 'notification';

  String get all => base;
  String get userNotifications => '$base/user/notifications';
  String get unreadCount => '$base/user/unread-count';
  String get makeAsRead => '$base/make-as-read';
  String get makeAsReadAllBonds => '$base/make-as-read/bonds';
  String delete(dynamic id) => '$base/$id';
}

class ApiNotificationReceivers {
  static const String base = 'notification-receivers';

  String get all => base;
  String one(dynamic id) => '$base/$id';
  String update(dynamic id) => '$base/$id';
  String delete(dynamic id) => '$base/$id';
}

class ApiProjectStatus {
  static const String base = 'project-status';

  String get all => base;
  String one(dynamic id) => '$base/$id';
  String add({dynamic name, dynamic isEnable}) =>
      '$base?name=$name&is_enable=$isEnable';
  String update(dynamic id, {dynamic name, dynamic isEnable}) =>
      '$base/$id?name=$name&is_enable=$isEnable';
  String delete(dynamic id) => '$base/$id';
}

class ApiStaff {
  static const String base = 'staff';

  String get all => base;
  String one(dynamic id) => '$base/$id';
  String update(dynamic id) => '$base/$id';
  String delete(dynamic id) => '$base/$id';
}
