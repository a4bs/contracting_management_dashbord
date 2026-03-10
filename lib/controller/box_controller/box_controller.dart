import 'package:contracting_management_dashbord/controller/app_controller/page_controller.dart';
import 'package:contracting_management_dashbord/model/box/box_model.dart';
import 'package:contracting_management_dashbord/model/box/filter_box_model.dart';
import 'package:contracting_management_dashbord/repo/box_repo.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class BoxController extends GetxController {
  final BoxRepo _repo = BoxRepo();
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  final PaginationController<BoxModel> boxPaginationController =
      PaginationController<BoxModel>();
  var selectedBox = BoxModel().obs;

  Future<List<BoxModel>?> getAllBoxes() async {
    List<BoxModel> boxes = [];
    try {
      final response = await _repo.getAllBoxes();
      boxes = (response.data as List).map((e) => BoxModel.fromJson(e)).toList();
      return boxes;
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
    return [];
  }

  Future<List<BoxModel>?> filterBox(FilterBoxModel filter) async {
    List<BoxModel> boxes = [];
    try {
      final response = await _repo.filterBox(filter);
      boxes = (response.data as List).map((e) => BoxModel.fromJson(e)).toList();
      boxPaginationController.items.assignAll(boxes);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
    return boxes;
  }

  Future<BoxModel?> getBoxById(id) async {
    try {
      final response = await _repo.getBoxById(id);
      return BoxModel.fromJson(response.data);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return null;
    }
  }

  addBox(data) async {
    try {
      final response = await _repo.addBox(data);
      boxPaginationController.addItem(BoxModel.fromJson(response.data));
      CustomToast.showInfo(
        title: "تم إضافة القاصة",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  updateBox(id, data) async {
    try {
      final response = await _repo.updateBox(id, data);
      int index = boxPaginationController.items.indexWhere(
        (element) => element.id == id,
      );
      if (index != -1) {
        boxPaginationController.updateItem(
          index,
          BoxModel.fromJson(response.data),
        );
      }
      CustomToast.showInfo(
        title: "تم تحديث القاصة",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  filterBoxesByProject(id) async {
    try {
      final response = await _repo.filterBoxesByProject(id);
      List<BoxModel> boxes = (response.data as List)
          .map((e) => BoxModel.fromJson(e))
          .toList();
      boxPaginationController.items.assignAll(boxes);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  deleteBox(id) async {
    try {
      final response = await _repo.deleteBox(id);
      int index = boxPaginationController.items.indexWhere(
        (element) => element.id == id,
      );
      if (index != -1) {
        boxPaginationController.removeItem(index);
      }
      CustomToast.showInfo(
        title: "تم حذف القاصة",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }
}
