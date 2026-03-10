import 'package:contracting_management_dashbord/controller/app_controller/page_controller.dart';
import 'package:contracting_management_dashbord/model/staff/staff_model.dart';
import 'package:contracting_management_dashbord/repo/staff_repo.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class StaffController extends GetxController {
  final StaffRepo _repo = StaffRepo();
  final pageDataStaff = PaginationController<StaffModel>();
  final keyAdd = GlobalKey<FormBuilderState>();

  Future<List<StaffModel>?> getAllStaff() async {
    List<StaffModel> staffList = [];
    try {
      final response = await _repo.getAllStaff();
      staffList = (response.data as List)
          .map((e) => StaffModel.fromJson(e))
          .toList();
      return staffList;
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return null;
    }
  }

  getStaffById(id) async {
    try {
      final response = await _repo.getStaffById(id);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  addStaff(data) async {
    try {
      final response = await _repo.addStaff(data);
      StaffModel dataStaff = StaffModel.fromJson(response.data);
      pageDataStaff.addItem(dataStaff);

      Get.back();
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  updateStaff(id, data) async {
    try {
      final response = await _repo.updateStaff(id, data);
      StaffModel dataStaff = StaffModel.fromJson(response.data);
      // ignore: invalid_use_of_protected_member
      int index = pageDataStaff.items.value.indexWhere(
        (element) => element.id.toString() == id.toString(),
      );
      if (index != -1) {
        pageDataStaff.updateItem(index, dataStaff);
      }
      Get.back();
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  deleteStaff(id) async {
    try {
      final response = await _repo.deleteStaff(id);
      // ignore: invalid_use_of_protected_member
      int index = pageDataStaff.items.value.indexWhere(
        (element) => element.id.toString() == id.toString(),
      );
      if (index != -1) {
        pageDataStaff.removeItem(index);
      }
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }
}
