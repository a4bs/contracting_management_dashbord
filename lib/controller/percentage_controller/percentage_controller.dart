import 'package:contracting_management_dashbord/controller/app_controller/page_controller.dart';
import 'package:contracting_management_dashbord/model/percentage/percentage_model.dart';
import 'package:contracting_management_dashbord/repo/percentage_repo.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class PercentageController extends GetxController {
  final PercentageRepo _repo = PercentageRepo();
  final PaginationController<PercentageModel> paginationController =
      PaginationController<PercentageModel>();
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  Future<List<PercentageModel>> getAllPercentages() async {
    List<PercentageModel> percentages = [];
    try {
      final response = await _repo.getAllPercentages();
      percentages = (response.data as List)
          .map((e) => PercentageModel.fromJson(e))
          .toList();
      paginationController.items.assignAll(percentages);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
    return percentages;
  }

  getPercentageById(int id) async {
    try {
      final response = await _repo.getPercentageById(id);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  addPercentage(data) async {
    try {
      final response = await _repo.addPercentage(data);
      CustomToast.showInfo(title: "تم", description: response.message);
      paginationController.addItem(PercentageModel.fromJson(response.data));
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  updatePercentage(int id, data) async {
    try {
      final response = await _repo.updatePercentage(id, data);
      CustomToast.showInfo(title: "تم", description: response.message);
      PercentageModel newdata = PercentageModel.fromJson(response.data);
      int index = paginationController.items.indexWhere((e) => e.id == id);
      if (index != -1) {
        paginationController.updateItem(index, newdata);
      }
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  deletePercentage(int id) async {
    try {
      final response = await _repo.deletePercentage(id);
      CustomToast.showInfo(title: "تم", description: response.message);
      int index = paginationController.items.indexWhere((e) => e.id == id);
      if (index != -1) {
        paginationController.removeItem(index);
      }
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }
}
