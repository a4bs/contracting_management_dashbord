import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/constant/enum/transaction_type_enum.dart';
import 'package:contracting_management_dashbord/controller/bond_controller/bond_controller.dart';
import 'package:contracting_management_dashbord/controller/box_controller/box_controller.dart';
import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/controller/staff_controller/staff_controller.dart';
import 'package:contracting_management_dashbord/model/bond/bond_key.dart';
import 'package:contracting_management_dashbord/model/bond/bond_model.dart';
import 'package:contracting_management_dashbord/model/bond/filter_bond.dart';
import 'package:contracting_management_dashbord/screen/filter_app/filter_bound.dart';
import 'package:contracting_management_dashbord/screen/shar_screens/shear_screen_to_draft.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/widget/app_date_field.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:contracting_management_dashbord/widget/file_upload_widget.dart';
import 'package:contracting_management_dashbord/widget/select_drop_don.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BoundDraftScreen extends GetView<BondController> {
  BoundDraftScreen({super.key});
  final BoxController boxController = Get.find<BoxController>();
  final ProjectController projectController = Get.find<ProjectController>();
  final StaffController staffController = Get.find<StaffController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text("مسودة سند إيداع", style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      width: double.infinity,
                      text: 'اضافة مسودة',
                      icon: Icons.add_circle_outline,
                      onPressed: () async {
                        dilog_add_creadit();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      width: double.infinity,
                      text: 'بحث  ',
                      icon: Icons.search,
                      backgroundColor: Colors.teal,
                      onPressed: () async {
                        Get.dialog(
                          Dialog(
                            child: FilterBondDilog(
                              onFilterSubmit: (data) async {
                                controller.filterBondToDraft.value =
                                    FilterBond.fromJson(data);
                                await controller.pageDataPagnationController
                                    .refreshItems(
                                      (page, limit) => controller.filterBonds(
                                        controller.filterBondToDraft.value,
                                      ),
                                    );
                                Get.back();
                              },
                              filterBond: controller.filterBondToDraft.value,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      width: double.infinity,
                      text: 'تحديث البيانات',
                      icon: Icons.refresh,
                      backgroundColor: Colors.teal,
                      onPressed: () async {
                        controller.pageDataPagnationController.refreshItems(
                          (page, limit) => controller.filterBonds(
                            controller.filterBondToDraft.value,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: ShearScreenToDraft(
                  filterBond: controller.filterBondToDraft.value,
                  pageDataPagnationController:
                      controller.pageDataPagnationController,
                  onApprove: (bond) {
                    dilog_add_creadit(bond: bond);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dilog_add_creadit({BondModel? bond}) {
    Get.dialog(
      Dialog(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: FormBuilder(
            initialValue: bond != null
                ? {
                    ...(Map<String, dynamic>.from(bond.toJson())
                      ..remove(BondAddKey.installmentDateAt)),
                    BondAddKey.amount: AppTool.formatMoney(
                      bond.amount.toString(),
                    ),
                  }
                : {},
            key: controller.keyFormToAddCreadit,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("اضافة مسودة", style: TextStyle(fontSize: 20)),
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    SelectDropDon(
                      name: BondAddKey.bondTypeId,
                      value: bond?.bondTypeId,
                      required: true,
                      label: ' نوع المسودة',
                      onTap: () async => [
                        {
                          "name": TransactionTypeEnum.credit.label,
                          "id": TransactionTypeEnum.credit.id,
                        },
                        {
                          "name": TransactionTypeEnum.debit.label,
                          "id": TransactionTypeEnum.debit.id,
                        },
                      ],
                      cardInfo: (item) => DropdownMenuEntry(
                        value: item['id'],
                        label: item['name'].toString(),
                      ),
                    ),
                    SizedBox(height: 10),
                    AppTextFiled(
                      validator: [
                        FormBuilderValidators.required(
                          errorText: 'الاسم مطلوب',
                        ),
                      ],
                      labelText: 'الاسم',
                      name: BondAddKey.title,
                    ),
                    SizedBox(height: 10),
                    AppTextFiled(
                      isEnable: bond == null,
                      isMony: true,
                      validator: [
                        FormBuilderValidators.required(
                          errorText: 'المبلغ مطلوب',
                        ),
                      ],
                      labelText: 'المبلغ',
                      name: BondAddKey.amount,
                    ),
                    SizedBox(height: 10),
                    SelectDropDon(
                      name: BondAddKey.projectId,
                      value: bond?.projectId,
                      // required: true,
                      label: 'المشروع',
                      onTap: () => projectController.getAllProjects(),
                      cardInfo: (item) => DropdownMenuEntry(
                        value: item.id,
                        label: item.name.toString(),
                      ),
                    ),
                    SizedBox(height: 10),
                    SelectDropDon(
                      name: BondAddKey.boxId,
                      required: true,
                      value: bond?.boxId,
                      label: 'الصندوق',
                      onTap: () => boxController.getAllBoxes(),
                      cardInfo: (item) => DropdownMenuEntry(
                        value: item.id,
                        label: item.name.toString(),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(height: 10),
                    SelectDropDon(
                      name: BondAddKey.staffId,

                      label: 'الموظف',
                      onTap: () => staffController.getAllStaff(),
                      cardInfo: (item) => DropdownMenuEntry(
                        value: item.id,
                        label: item.name.toString(),
                      ),
                    ),
                    SizedBox(height: 10),
                    AppDateField(
                      format: DateFormat('yyyy-MM-dd'),
                      initialValue: bond?.installmentDateAt != null
                          ? DateTime.tryParse(bond!.installmentDateAt!)
                          : null,
                      valueTransformer: (value) => value != null
                          ? DateFormat('yyyy-MM-dd').format(value)
                          : null,
                      validator: [
                        FormBuilderValidators.required(
                          errorText: 'التاريخ مطلوب',
                        ),
                      ],
                      labelText: 'التاريخ',
                      name: BondAddKey.installmentDateAt,
                    ),
                    SizedBox(height: 10),
                    AppTextFiled(
                      validator: [
                        FormBuilderValidators.required(
                          errorText: 'الملاحظة مطلوبة',
                        ),
                      ],
                      labelText: 'ملاحظة',
                      name: BondAddKey.note,
                    ),
                    SizedBox(height: 10),
                    FileUploadWidget(
                      name: BondAddKey.file,
                      uploadUrl: AppApi.bond.uploadFile,
                      label: ' صوره للسند',
                      defaultLinks: bond?.filePaths?.isNotEmpty == true
                          ? bond!.filePaths!
                          : null,
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      width: double.infinity,
                      text: bond == null ? 'اضافة' : 'تصديق السند',
                      onPressed: () async {
                        if (controller.keyFormToAddCreadit.currentState!
                            .validate()) {
                          controller
                              .keyFormToAddCreadit
                              .currentState!
                              .fields[BondAddKey.amount]!
                              .setValue(
                                controller
                                    .keyFormToAddCreadit
                                    .currentState!
                                    .fields[BondAddKey.amount]!
                                    .value
                                    .toString()
                                    .replaceAll(",", ""),
                              );
                          if (bond != null) {
                            await controller.updateBond(bond.id, {
                              ...(controller
                                  .keyFormToAddCreadit
                                  .currentState!
                                  .instantValue),
                              BondAddKey.isDraft: false,
                            });
                          } else {
                            await controller.addBond({
                              ...controller
                                  .keyFormToAddCreadit
                                  .currentState!
                                  .instantValue,
                              BondAddKey.isDraft: true,
                            });
                          }
                          controller.pageDataPagnationController.refreshItems(
                            (page, limit) => controller.filterBonds(
                              controller.filterBondToDraft.value,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
