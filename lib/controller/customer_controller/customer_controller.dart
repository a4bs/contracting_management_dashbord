import 'package:contracting_management_dashbord/controller/app_controller/page_controller.dart';
import 'package:contracting_management_dashbord/controller/app_controller/page_data_pagnation_controller.dart';
import 'package:contracting_management_dashbord/model/customer/customer_model.dart';
import 'package:contracting_management_dashbord/model/customer/customer_filter_model.dart';
import 'package:contracting_management_dashbord/model/pagnation_model.dart';
import 'package:contracting_management_dashbord/repo/customer_repo.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController {
  final CustomerRepo _repo = CustomerRepo();
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final PageDataPagnationController<CustomerModel>
  customerPaginationController = PageDataPagnationController<CustomerModel>();
  var selectedCustomer = CustomerModel().obs;
  var filterModel = CustomerFilterModel().obs;

  Future<List<CustomerModel>?> getAllCustomers() async {
    List<CustomerModel> customers = [];
    try {
      final response = await _repo.getAllCustomers();
      PaginationModel paginationModel = PaginationModel.fromJson(response.data);
      customers = (paginationModel.data)
          .map((e) => CustomerModel.fromJson(e))
          .toList();
      return customers;
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
    return [];
  }

  Future<List<CustomerModel>?> getCustomerByFilter(
    CustomerFilterModel filter,
  ) async {
    List<CustomerModel> customers = [];
    try {
      final response = await _repo.getCustomerByFilter(filter);
      PaginationModel paginationModel = PaginationModel.fromJson(response.data);
      customers = (paginationModel.data)
          .map((e) => CustomerModel.fromJson(e))
          .toList();
      return customers;
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
    return [];
  }

  Future<CustomerModel?> getCustomerById(id) async {
    try {
      final response = await _repo.getCustomerById(id);
      // CustomToast.showInfo(title: "تم", description: response.message);
      return CustomerModel.fromJson(response.data);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return null;
    }
  }

  addCustomer(data) async {
    try {
      final response = await _repo.addCustomer(data);
      customerPaginationController.addItem(
        CustomerModel.fromJson(response.data),
      );
      CustomToast.showInfo(
        title: "تم اضافة العميل",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  updateCustomer(id, data) async {
    try {
      final response = await _repo.updateCustomer(id, data);
      int index = customerPaginationController.items.indexWhere(
        (element) => element.id == id,
      );
      if (index != -1) {
        customerPaginationController.updateItem(
          index,
          CustomerModel.fromJson(response.data),
        );
      }
      CustomToast.showInfo(
        title: "تم تعديل العميل",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  uploadCustomerFile(data) async {
    try {
      final response = await _repo.uploadCustomerFile(data);
      CustomToast.showInfo(
        title: "تم رفع ملف العميل",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  deleteCustomer(id) async {
    try {
      final response = await _repo.deleteCustomer(id);
      customerPaginationController.removeItem(
        customerPaginationController.items.indexWhere(
          (element) => element.id == id,
        ),
      );
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }
}
