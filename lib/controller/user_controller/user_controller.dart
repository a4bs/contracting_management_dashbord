import 'package:contracting_management_dashbord/controller/app_controller/page_controller.dart';
import 'package:contracting_management_dashbord/model/user/user_model.dart';
import 'package:contracting_management_dashbord/repo/role_repo.dart';
import 'package:contracting_management_dashbord/repo/user_repo.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserRepo _repo = UserRepo();
  final pageDataUser = PaginationController<UserModel>();
  final keyAdd = GlobalKey<FormBuilderState>();
  Future<List<UserModel>?> getAllUsers() async {
    List<UserModel> users = [];
    try {
      final response = await _repo.getAllUsers();
      users = (response.data as List)
          .map((e) => UserModel.fromJson(e))
          .toList();
      return users;
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return null;
    }
  }

  getUserById(id) async {
    try {
      final response = await _repo.getUserById(id);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  addUser(data) async {
    try {
      final response = await _repo.addUser(data);
      UserModel dataUser = UserModel.fromJson(response.data);
      pageDataUser.addItem(dataUser);

      Get.back();
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  updateUser(id, data) async {
    try {
      final response = await _repo.updateUser(id, data);
      UserModel dataUser = UserModel.fromJson(response.data);
      // ignore: invalid_use_of_protected_member
      int index = pageDataUser.items.value.indexWhere(
        (element) => element.id == id,
      );
      pageDataUser.updateItem(index, dataUser);
      Get.back();
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  deleteUser(id) async {
    try {
      final response = await _repo.deleteUser(id);
      // ignore: invalid_use_of_protected_member
      int index = pageDataUser.items.value.indexWhere(
        (element) => element.id == id,
      );
      pageDataUser.removeItem(index);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  getUserLocal() {}

  final RoleRepo _roleRepo = RoleRepo();

  final RxList<PermissionModel> permissionsList = <PermissionModel>[].obs;
  final RxList<PermissionModel> userPermissionsList = <PermissionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllPermissions();
  }

  Future<void> getAllPermissions() async {
    try {
      final response = await _roleRepo.getAllPermissions();
      permissionsList.value = (response.data as List)
          .map((e) => PermissionModel.fromJson(e))
          .toList();
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  Future<void> getUserPermissions(int userId) async {
    try {
      userPermissionsList.clear(); // Clear previous user's permissions
      final response = await _roleRepo.getUserPermissions(userId.toString());
      userPermissionsList.value = (response.data as List)
          .map((e) => PermissionModel.fromJson(e))
          .toList();
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  Future<void> saveUserPermissions(int userId) async {
    try {
      List<int> permissionIds = userPermissionsList.map((e) => e.id!).toList();

      final response = await _roleRepo.updatePermissionsToUser(
        userId.toString(),
        {"permissions": permissionIds},
      );
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }
}
