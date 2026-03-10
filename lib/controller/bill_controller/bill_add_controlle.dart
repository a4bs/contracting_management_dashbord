import 'package:contracting_management_dashbord/constant/enum/transaction_type_enum.dart';
import 'package:contracting_management_dashbord/controller/bill_controller/bill_controller.dart';
import 'package:contracting_management_dashbord/model/bill/bill_filter.dart';
import 'package:contracting_management_dashbord/model/bill/bill_key.dart';
import 'package:contracting_management_dashbord/model/bond/bond_key.dart';
import 'package:contracting_management_dashbord/model/bond/bond_model.dart';
import 'package:contracting_management_dashbord/model/box/box_model.dart';
import 'package:contracting_management_dashbord/model/customer/customer_key.dart';
import 'package:contracting_management_dashbord/model/customer/customer_model.dart';
import 'package:contracting_management_dashbord/model/percentage/percentage_model.dart';
import 'package:contracting_management_dashbord/model/project/project_model.dart';
import 'package:contracting_management_dashbord/model/unit/unit_model.dart';
import 'package:contracting_management_dashbord/repo/bill_repo.dart';
import 'package:contracting_management_dashbord/repo/percentage_repo.dart';
import 'package:contracting_management_dashbord/repo/unit_repo.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class BillAddController extends GetxController {
  final UnitRepo _repo = UnitRepo();
  final PercentageRepo _percentageRepo = PercentageRepo();
  final BillRepo _billRepo = BillRepo();
  final billController = Get.find<BillController>();
  var isCreateNewCustomer = true.obs;
  var currentStep = 0.obs;
  var installmentType = Rxn<int>();
  var customerModel = CustomerModel().obs;
  var projectModel = ProjectModel().obs;
  var unitModel = UnitModel().obs;
  var boxModel = BoxModel().obs;
  var listBound = <BondModel>[].obs;
  final GlobalKey<FormBuilderState> formKeyToAddCustomer =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> formKeyToChangeUnitCost =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> formKeyToAddBill =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> formKeyGenrate =
      GlobalKey<FormBuilderState>();
  updateUnit(id, data) async {
    try {
      final response = await _repo.updateUnit(id, data);
      unitModel.value.cost = UnitModel.fromJson(response.data).cost;
      formKeyToAddBill.currentState!.fields[BillAddKey.salePrice]!.didChange(
        AppTool.formatMoney(unitModel.value.cost.toString()),
      );
      Get.back();
      CustomToast.showInfo(
        title: "تم تحديث الوحدة",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  int getTotalPrice() {
    double cost =
        double.tryParse(unitModel.value.cost.toString().replaceAll(',', '')) ??
        0;
    var downPaymentVal =
        formKeyToAddBill.currentState?.fields[BillAddKey.downPayment]?.value;
    double downPayment =
        double.tryParse(downPaymentVal.toString().replaceAll(',', '')) ?? 0;
    double resuilt = cost - downPayment;
    return resuilt.toInt();
  }

  generateBound() async {
    listBound.clear();
    listBound.refresh();
    await Future.delayed(const Duration(milliseconds: 100), () {});

    double totalMoney = getTotalPrice().toDouble();
    double totlailAfterBanqMoney = totalMoney;
    if ((totalMoney - 117950250) <= 0) {
      CustomToast.showWarning(
        title: 'انتباه',
        description: "السعر المتبقي اقل من قيمة اقرض لذالك لم تظف قيمة اقرض",
        autoCloseDuration: Duration(seconds: 5),
      );
    } else {
      totlailAfterBanqMoney = totalMoney - 117950250;
      DateTime date = DateTime.now();
      BondModel data = BondModel(
        id: 0,
        downPayment: '117950250',
        note: '  دفعة قرض المصرفي',
        title: '  دفعة قرض المصرفي',
      );
      if (installmentType.value == 1) {
        data.installmentDateAt = AppTool.formatDate(
          date.add(const Duration(days: 30)),
        );
      }
      listBound.add(data);
    }
    int count = int.parse(
      formKeyGenrate.currentState!.fields['count_generate']!.value,
    );

    double endMone = (totlailAfterBanqMoney / count);

    for (int i = 0; i < count; i++) {
      listBound.add(
        BondModel(
          id: i + 1,
          boxId: boxModel.value.id,
          installmentDateAt: AppTool.formatDate(DateTime.now()),
          downPayment: endMone.toInt().toString(),
          note: 'دفعه ${i + 1}',
          title: 'دفعه ${i + 1}',
        ),
      );
    }
    listBound.refresh();
  }

  Future<List<PercentageModel>> getPercentage() async {
    List<PercentageModel> list = [];
    try {
      final response = await _percentageRepo.getAllPercentages();
      list = (response.data as List<dynamic>)
          .map((e) => PercentageModel.fromJson(e))
          .toList();
    } catch (e) {
      CustomToast.showError(title: "خطأ", description: e.toString());
      return [];
    }
    return list;
  }

  saveBill() async {
    Map<String, dynamic> dataSend = {'bonds': []};

    if (isCreateNewCustomer.value) {
      dataSend.addAll(formKeyToAddCustomer.currentState!.instantValue);
    } else {
      dataSend.addAll({CustomerAddKey.customerId: customerModel.value.id});
    }
    for (var element in listBound) {
      Map<String, dynamic> dataBound = {
        BondAddKey.title: element.title,
        BondAddKey.downPayment: element.downPayment.toString().replaceAll(
          ',',
          '',
        ),
        BondAddKey.amount: (element.amount ?? 0).toString().replaceAll(',', ''),
        BondAddKey.note: element.note,
        BondAddKey.boxId: boxModel.value.id,
        BondAddKey.isScheduledInstallment: installmentType.value,
        BondAddKey.bondTypeId: TransactionTypeEnum.credit.id,
        BondAddKey.projectId: projectModel.value.id,
        BondAddKey.installmentDateAt: element.installmentDateAt,
        BondAddKey.percentageId: element.percentageId,
      };
      dataBound.removeWhere((key, value) => value == null);
      dataSend['bonds'].add(dataBound);
    }
    Map<String, dynamic> dataBill = {
      BillAddKey.note:
          formKeyToAddBill.currentState!.fields[BillAddKey.note]!.value,
      BillAddKey.isScheduledInstallment: installmentType.value,
      BillAddKey.salePrice: formKeyToAddBill
          .currentState!
          .fields[BillAddKey.salePrice]!
          .value
          .toString()
          .replaceAll(',', ''),
      BillAddKey.downPayment: formKeyToAddBill
          .currentState!
          .fields[BillAddKey.downPayment]!
          .value
          .toString()
          .replaceAll(',', ''),
      BillAddKey.plot:
          formKeyToAddBill.currentState!.fields[BillAddKey.plot]!.value,
      BillAddKey.boxId: boxModel.value.id,
      BillAddKey.unitId: unitModel.value.id,
      BillAddKey.projectId: projectModel.value.id,
      BillAddKey.customerId: customerModel.value.id,
    };

    dataSend.addAll(dataBill);
    // print(dataSend);
    try {
      final response = await _billRepo.addAdvanceBonds(dataSend);
      CustomToast.showSuccess(
        title: "تم الانشاء بنجاح",
        description: response.message,
      );
      clearAll();
      Get.back();
      billController.billDataController.refreshItems(
        (page, limit) =>
            billController.filterBills(BillFilter(page: page, limit: limit)),
      );
    } catch (e) {
      CustomToast.showError(title: "خطأ", description: e.toString());
    } finally {}
  }

  clearAll() {
    customerModel.value = CustomerModel();
    boxModel.value = BoxModel();
    unitModel.value = UnitModel();
    listBound.clear();
    currentStep.value = 0;
    listBound.refresh();
    isCreateNewCustomer.value = true;
    installmentType.value = 1;
    if (formKeyToAddBill.currentState != null) {
      formKeyToAddBill.currentState!.reset();
    }
    if (formKeyToAddCustomer.currentState != null) {
      formKeyToAddCustomer.currentState!.reset();
    }
    if (formKeyGenrate.currentState != null) {
      formKeyGenrate.currentState!.reset();
    }
  }
}
