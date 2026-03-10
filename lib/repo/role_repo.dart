import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';

class RoleRepo {
  // Roles
  Future<ResponseModel> getAllRoles() async {
    final response = await DioNetwork.get(path: AppApi.role.roles);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getRoleById(String id) async {
    final response = await DioNetwork.get(path: AppApi.role.role(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addRole(data) async {
    final response = await DioNetwork.post(
      path: AppApi.role.roles,
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> updateRole(String id, data) async {
    final response = await DioNetwork.put(
      path: AppApi.role.role(id),
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> deleteRole(String id) async {
    final response = await DioNetwork.delete(path: AppApi.role.role(id));
    return ResponseModel.fromJson(response.data);
  }

  // Role Permissions
  Future<ResponseModel> getRolePermissions(String id) async {
    final response = await DioNetwork.get(
      path: AppApi.role.rolePermissions(id),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> updateRolePermissions(String id, data) async {
    final response = await DioNetwork.put(
      path: AppApi.role.updatePermissionsToRole(id),
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  // Permissions
  Future<ResponseModel> getAllPermissions() async {
    final response = await DioNetwork.get(path: AppApi.role.permissions);
    return ResponseModel.fromJson(response.data);
  }

  // User Relations
  Future<ResponseModel> getUserRoles(String userId) async {
    final response = await DioNetwork.get(path: AppApi.role.userRoles(userId));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getUserPermissions(String userId) async {
    final response = await DioNetwork.get(
      path: AppApi.role.userPermissions(userId),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> updatePermissionsToUser(String userId, data) async {
    final response = await DioNetwork.put(
      path: AppApi.role.updatePermissionsToUser(userId),
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addPermissionToRole(
    String roleId,
    String permissionId,
  ) async {
    final response = await DioNetwork.post(
      path: AppApi.role.addPermissionToRole(roleId, permissionId),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getPermissionById(String id) async {
    final response = await DioNetwork.get(path: AppApi.role.permission(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getPermissionRoles(String id) async {
    final response = await DioNetwork.get(
      path: AppApi.role.permissionRoles(id),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addUserRole(String userId, String roleId) async {
    final response = await DioNetwork.post(
      path: AppApi.role.userRole(userId, roleId),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> deleteUserRole(String userId, String roleId) async {
    final response = await DioNetwork.delete(
      path: AppApi.role.userRole(userId, roleId),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addUserPermission(
    String userId,
    String permissionId,
  ) async {
    final response = await DioNetwork.post(
      path: AppApi.role.userPermission(userId, permissionId),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> deleteUserPermission(
    String userId,
    String permissionId,
  ) async {
    final response = await DioNetwork.delete(
      path: AppApi.role.userPermission(userId, permissionId),
    );
    return ResponseModel.fromJson(response.data);
  }
}
