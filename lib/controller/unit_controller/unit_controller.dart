import 'package:contracting_management_dashbord/controller/app_controller/page_controller.dart';
import 'package:contracting_management_dashbord/model/unit/unit_model.dart';
import 'package:contracting_management_dashbord/repo/unit_repo.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class UnitController extends GetxController {
  final UnitRepo _repo = UnitRepo();
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final PaginationController<UnitModel> unitPaginationController =
      PaginationController<UnitModel>();
  var selectedUnit = UnitModel().obs;

  Future<List<UnitModel>?> getAllUnits() async {
    List<UnitModel> units = [];
    try {
      final response = await _repo.getAllUnits();
      units = (response.data as List)
          .map((e) => UnitModel.fromJson(e))
          .toList();
      return units;
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
    return [];
  }

  Future<UnitModel?> getUnitById(id) async {
    try {
      final response = await _repo.getUnitById(id);
      return UnitModel.fromJson(response.data);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return null;
    }
  }

  addUnit(data) async {
    try {
      final response = await _repo.addUnit(data);
      unitPaginationController.addItem(UnitModel.fromJson(response.data));
      CustomToast.showInfo(
        title: "تم إضافة الوحدة",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  updateUnit(id, data) async {
    try {
      final response = await _repo.updateUnit(id, data);
      int index = unitPaginationController.items.indexWhere(
        (element) => element.id == id,
      );
      if (index != -1) {
        unitPaginationController.updateItem(
          index,
          UnitModel.fromJson(response.data),
        );
      }
      CustomToast.showInfo(
        title: "تم تحديث الوحدة",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  Future<List<UnitModel>> getUnitsByProject(id) async {
    List<UnitModel> units = [];
    try {
      final response = await _repo.getUnitsByProject(id);
      units = (response.data as List)
          .map((e) => UnitModel.fromJson(e))
          .toList();
      unitPaginationController.items.assignAll(units);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
    return units;
  }

  getUnitsByCustomer(id) async {
    try {
      final response = await _repo.getUnitsByCustomer(id);
      List<UnitModel> units = (response.data as List)
          .map((e) => UnitModel.fromJson(e))
          .toList();
      unitPaginationController.items.assignAll(units);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  deleteUnit(id) async {
    try {
      final response = await _repo.deleteUnit(id);
      int index = unitPaginationController.items.indexWhere(
        (element) => element.id == id,
      );
      if (index != -1) {
        unitPaginationController.removeItem(index);
      }
      CustomToast.showInfo(
        title: "تم حذف الوحدة",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }
}
