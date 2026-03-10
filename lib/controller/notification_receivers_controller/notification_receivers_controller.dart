import 'package:contracting_management_dashbord/controller/app_controller/page_data_pagnation_controller.dart';
import 'package:contracting_management_dashbord/model/notification_receivers/notification_receivers_model.dart';
import 'package:contracting_management_dashbord/repo/notification_receivers_repo.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class NotificationReceiversController extends GetxController {
  final NotificationReceiversRepo _repo = NotificationReceiversRepo();
   PageDataPagnationController<NotificationReceiversModel> pageDataController =
      PageDataPagnationController<NotificationReceiversModel>();
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

 Future<List<NotificationReceiversModel>>  getAllReceivers() async {
  List<NotificationReceiversModel> receivers = [];
    try {
      final response = await _repo.getAllReceivers();
      receivers = (response.data as List<dynamic>).map((e) => NotificationReceiversModel.fromJson(e)).toList();
       
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
    return receivers;
  }

  getReceiver(id) async {
    try {
      final response = await _repo.getReceiver(id);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  addReceiver(Map<String, dynamic> data) async {
    try {
      // Create a copy to avoid modifying the original map if it's immutable
      final Map<String, dynamic> processedData = Map.from(data);
      
      // Convert boolean to 1/0 as expected by the API
      if (processedData.containsKey('is_enabled') && processedData['is_enabled'] is bool) {
        processedData['is_enabled'] = processedData['is_enabled'] ? 1 : 0;
      }

      final response = await _repo.addReceiver(processedData);
      CustomToast.showInfo(title: "تم الاضافة", description: response.message);
      pageDataController.refreshItems((page, limit)=>getAllReceivers());
      Get.back();
      formKey.currentState!.reset();
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  updateReceiver({required dynamic id, required int isEnabled}) async {
    try {
      final response = await _repo.updateReceiver(id: id, isEnabled: isEnabled);
      CustomToast.showInfo(title: "تم", description: response.message);
      pageDataController.refreshItems((page, limit)=>getAllReceivers());
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  deleteReceiver(id) async {
    try {
      final response = await _repo.deleteReceiver(id);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }
}
