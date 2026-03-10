import 'package:contracting_management_dashbord/constant/enum/transaction_type_enum.dart';
import 'package:contracting_management_dashbord/controller/app_controller/page_controller.dart';
import 'package:contracting_management_dashbord/controller/app_controller/page_data_pagnation_controller.dart';
import 'package:contracting_management_dashbord/model/bond/approved_bound_user.dart';
import 'package:contracting_management_dashbord/model/bond/bond_model.dart';
import 'package:contracting_management_dashbord/model/bond/filter_bond.dart';
import 'package:contracting_management_dashbord/model/customer/customer_model.dart';
import 'package:contracting_management_dashbord/model/pagnation_model.dart';
import 'package:contracting_management_dashbord/repo/bond_repo.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class BondController extends GetxController {
  final BondRepo _repo = BondRepo();
  PageDataPagnationController<BondModel> pageDataPagnationController =
      PageDataPagnationController<BondModel>();
  PageDataPagnationController<BondModel> pageDataPagnationController2 =
      PageDataPagnationController<BondModel>();
  PageDataPagnationController<BondModel> pageDataPagnationController3 =
      PageDataPagnationController<BondModel>();
  PaginationController<ApprovedBoundUser> pageDataToApprovedController4 =
      PaginationController<ApprovedBoundUser>();
  final keyFormToAddCreadit = GlobalKey<FormBuilderState>();
  final keyFormToAddDebit = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> formKeyToConvertBox =
      GlobalKey<FormBuilderState>();
  var idBoxTo = 0.obs;
  var idBoxFrom = 0.obs;
  var customerModelSelected = CustomerModel().obs;
  var filterBondToDebit = FilterBond(
    page: 1,
    perPage: 10,
    bondTypeId: TransactionTypeEnum.debit.id,
  ).obs;
  var filterBondToCredit = FilterBond(
    page: 1,
    perPage: 10,
    bondTypeId: TransactionTypeEnum.credit.id,
  ).obs;
  var filterBondToDraft = FilterBond(page: 1, perPage: 10, isDraft: true).obs;
  Future<List<BondModel>> getAllBonds() async {
    List<BondModel> bonds = [];
    try {
      final response = await _repo.getAllBonds();
      CustomToast.showInfo(title: "تم", description: response.message);
      bonds = response.data;
      return bonds;
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return bonds;
    }
  }

  getBondById(id) async {
    try {
      final response = await _repo.getBondById(id);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  addBond(data) async {
    try {
      final response = await _repo.addBond(data);
      CustomToast.showInfo(
        title: "تم إضافة السند",
        description: response.message,
      );
      if (keyFormToAddCreadit.currentState != null) {
        keyFormToAddCreadit.currentState?.reset();
      }
      if (keyFormToAddDebit.currentState != null) {
        keyFormToAddDebit.currentState?.reset();
      }
      Get.back();
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  updateBond(id, data) async {
    try {
      final response = await _repo.updateBond(id, data);
      CustomToast.showInfo(title: "تم", description: response.message);
      if (keyFormToAddCreadit.currentState != null) {
        keyFormToAddCreadit.currentState?.reset();
      }
      if (keyFormToAddDebit.currentState != null) {
        keyFormToAddDebit.currentState?.reset();
      }
      Get.back();
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  Future<List<BondModel>> filterBonds(FilterBond filterBond) async {
    List<BondModel> bonds = [];

    final response = await _repo.filterBonds(filterBond);
    PaginationModel paginationModel = PaginationModel.fromJson(response.data);
    bonds = (paginationModel.data).map((e) => BondModel.fromJson(e)).toList();
    pageDataPagnationController.limit.value =
        paginationModel.pagination.lastPage;
    pageDataPagnationController.page.value =
        paginationModel.pagination.currentPage;
    return bonds;
  }

  uploadBondFile(data) async {
    try {
      final response = await _repo.uploadBondFile(data);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  deleteBond(id) async {
    try {
      final response = await _repo.deleteBond(id);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  convertBoundToBox(data) async {
    try {
      final response = await _repo.convertBox(data);
      CustomToast.showInfo(
        title: "تم تحويل القاصة",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  proviteBound(id) async {
    try {
      final response = await _repo.proviteBound(id);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  Future<List<ApprovedBoundUser>> getApprovedUsers(id) async {
    List<ApprovedBoundUser> users = [];
    try {
      final response = await _repo.getApprovedUsers(id);
      users = (response.data as List)
          .map<ApprovedBoundUser>((e) => ApprovedBoundUser.fromJson(e))
          .toList();
      return users;
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return users;
    }
  }
}
