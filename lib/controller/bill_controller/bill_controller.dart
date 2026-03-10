import 'package:contracting_management_dashbord/controller/app_controller/page_controller.dart';
import 'package:contracting_management_dashbord/controller/app_controller/page_data_pagnation_controller.dart';
import 'package:contracting_management_dashbord/controller/bond_controller/bond_controller.dart';
import 'package:contracting_management_dashbord/model/bill/bill_filter.dart';
import 'package:contracting_management_dashbord/model/bill/bill_model.dart';
import 'package:contracting_management_dashbord/model/bond/bond_key.dart';
import 'package:contracting_management_dashbord/model/bond/bond_model.dart';
import 'package:contracting_management_dashbord/model/bond/filter_bond.dart';
import 'package:contracting_management_dashbord/model/pagnation_model.dart';
import 'package:contracting_management_dashbord/repo/bill_repo.dart';
import 'package:contracting_management_dashbord/repo/bond_repo.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class BillController extends GetxController {
  final BillRepo _repo = BillRepo();
  final BondRepo _bondRepo = BondRepo();
  final formToUpdateBond = GlobalKey<FormBuilderState>();
  final formToAddBond = GlobalKey<FormBuilderState>();
  final formToONDUpdateBond = GlobalKey<FormBuilderState>();

  PageDataPagnationController<BillModel> billDataController =
      PageDataPagnationController<BillModel>();

  var billFilter = BillFilter().obs;
  Future<List<BillModel>> getAllBills() async {
    List<BillModel> bills = [];
    try {
      final response = await _repo.getAllBills();
      bills = (response.data as List)
          .map((e) => BillModel.fromJson(e))
          .toList();
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
    return bills;
  }

  final BondController boundController = Get.find();

  getBillById(id) async {
    try {
      final response = await _repo.getBillById(id);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  addBill(data) async {
    try {
      final response = await _repo.addBill(data);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  updateBill(id, data) async {
    try {
      final response = await _repo.updateBill(id, data);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  deleteBill(id) async {
    try {
      final response = await _repo.deleteBill(id);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  Future<List<BillModel>> filterBills(BillFilter billFilter) async {
    List<BillModel> bills = [];
    try {
      final response = await _repo.filterBills(billFilter);
      PaginationModel paginationResponse = PaginationModel.fromJson(
        response.data,
      );

      bills = (paginationResponse.data)
          .map((e) => BillModel.fromJson(e))
          .toList();
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
    return bills;
  }

  payBill(BondModel bond) async {
    try {
      bond.amount = bond.downPayment;
      final response = await _bondRepo.updateBond(bond.id, bond.toJson());
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  cancelBill(BondModel bond) async {
    try {
      bond.amount = '0';
      final response = await _bondRepo.updateBond(bond.id, bond.toJson());
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  updateBondAmount(BondModel bond) async {
    try {
      bond.amount = formToUpdateBond
          .currentState!
          .fields[BondUpdateKey.amount]!
          .value
          .toString()
          .replaceAll(',', '');
      final response = await _bondRepo.updateBond(bond.id, bond.toJson());
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  updateONDonBondAmount(BondModel bond) async {
    try {
      bond.downPayment = formToONDUpdateBond
          .currentState!
          .fields[BondUpdateKey.downPayment]!
          .value
          .toString()
          .replaceAll(',', '');
      final response = await _bondRepo.updateBond(bond.id, bond.toJson());
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  deletebound(id, BillModel bill) async {
    try {
      final response = await _bondRepo.deleteBond(id);
      CustomToast.showInfo(title: "تم", description: response.message);
      List<int> bondIds = bill.bondIds ?? [];
      bondIds.remove(id);
      syncBonds(bill.id!, {"bond_ids": bondIds});
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  addBond(data, customerId, BillModel bill) async {
    try {
      final response = await _bondRepo.addBond(data);
      CustomToast.showInfo(title: "تم", description: response.message);
      BondModel bond = BondModel.fromJson(response.data);
      boundController.pageDataPagnationController.refreshItems(
        (pahe, item) =>
            boundController.filterBonds(FilterBond(customerId: customerId)),
      );
      List<int> bondIds = bill.bondIds ?? [];
      bondIds.add(bond.id!.toInt());
      await syncBonds(bill.id!, {"bond_ids": bondIds});
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    } finally {
      return '';
    }
  }

  bool isAddBondAllowed(List<BondModel> transactions, BillModel bill) {
    double totalPaid = 0.0;
    for (var bond in transactions) {
      if (bond.bondTypeId == 2) {
        totalPaid +=
            double.tryParse(bond.downPayment?.replaceAll(',', '') ?? '0') ??
            0.0;
      }
    }
    totalPaid +=
        double.tryParse(bill.downPayment?.replaceAll(',', '') ?? '0') ?? 0.0;
    final double salePrice =
        double.tryParse(bill.salePrice?.replaceAll(',', '') ?? '0') ?? 0.0;

    return totalPaid < salePrice;
  }

  syncBonds(idBill, data) async {
    try {
      final response = await _repo.syncBonds(idBill, data);
      CustomToast.showInfo(
        title: "تم مزامنة الفواتير  ",
        description: response.message,
      );
    } on DioException catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }
}
