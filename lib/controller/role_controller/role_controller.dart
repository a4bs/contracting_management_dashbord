import 'package:contracting_management_dashbord/repo/role_repo.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:get/get.dart';

class RoleController extends GetxController {
  final RoleRepo _repo = RoleRepo();

  // Roles
  getAllRoles() async {
    try {
      final response = await _repo.getAllRoles();
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  getRoleById(String id) async {
    try {
      final response = await _repo.getRoleById(id);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  addRole(data) async {
    try {
      final response = await _repo.addRole(data);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  updateRole(String id, data) async {
    try {
      final response = await _repo.updateRole(id, data);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  deleteRole(String id) async {
    try {
      final response = await _repo.deleteRole(id);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  // Role Permissions
  getRolePermissions(String id) async {
    try {
      final response = await _repo.getRolePermissions(id);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  updateRolePermissions(String id, data) async {
    try {
      final response = await _repo.updateRolePermissions(id, data);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  // Permissions
  getAllPermissions() async {
    try {
      final response = await _repo.getAllPermissions();
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  getPermissionById(String id) async {
    try {
      final response = await _repo.getPermissionById(id);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  getPermissionRoles(String id) async {
    try {
      final response = await _repo.getPermissionRoles(id);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  addPermissionToRole(String roleId, String permissionId) async {
    try {
      final response = await _repo.addPermissionToRole(roleId, permissionId);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  // User Relations
  getUserRoles(String userId) async {
    try {
      final response = await _repo.getUserRoles(userId);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  getUserPermissions(String userId) async {
    try {
      final response = await _repo.getUserPermissions(userId);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  updatePermissionsToUser(String userId, data) async {
    try {
      final response = await _repo.updatePermissionsToUser(userId, data);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  addUserRole(String userId, String roleId) async {
    try {
      final response = await _repo.addUserRole(userId, roleId);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  deleteUserRole(String userId, String roleId) async {
    try {
      final response = await _repo.deleteUserRole(userId, roleId);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  addUserPermission(String userId, String permissionId) async {
    try {
      final response = await _repo.addUserPermission(userId, permissionId);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  deleteUserPermission(String userId, String permissionId) async {
    try {
      final response = await _repo.deleteUserPermission(userId, permissionId);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }
}
