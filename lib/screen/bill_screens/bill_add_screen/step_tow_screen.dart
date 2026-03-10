import 'package:contracting_management_dashbord/controller/bill_controller/bill_add_controlle.dart';
import 'package:contracting_management_dashbord/controller/box_controller/box_controller.dart';
import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/controller/unit_controller/unit_controller.dart';
import 'package:contracting_management_dashbord/model/bill/bill_key.dart';
import 'package:contracting_management_dashbord/model/box/box_model.dart';
import 'package:contracting_management_dashbord/model/project/project_model.dart';
import 'package:contracting_management_dashbord/model/unit/unit_key.dart';
import 'package:contracting_management_dashbord/model/unit/unit_model.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:contracting_management_dashbord/widget/layout_tablet_phone.dart';

import 'package:contracting_management_dashbord/widget/select_drop_don.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

class StepTowScreen extends GetView<BillAddController> {
  StepTowScreen({super.key});
  final projectController = Get.find<ProjectController>();
  final unitController = Get.find<UnitController>();
  final _boxController = Get.find<BoxController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: FormBuilder(
        key: controller.formKeyToAddBill,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Group 1: Project and Unit
              LayoutTabletPhone(
                children: [
                  SelectDropDon(
                    name: BillAddKey.projectId,
                    label: 'المشروع',
                    required: true,
                    icon: Icons.business,
                    onSelected: (value) {
                      controller.projectModel.value = value;
                    },
                    onTap: () => projectController.getAllProjects(),
                    cardInfo: (ProjectModel e) =>
                        DropdownMenuEntry(value: e, label: e.name.toString()),
                  ),
                  Obx(() {
                    return SelectDropDon(
                      isSearch: true,
                      clearListOnFocus: true,
                      enabled: controller.projectModel.value.id != null,
                      name: BillAddKey.unitId,
                      required: true,
                      label: 'الوحدة',
                      icon: Icons.home_work,
                      onSelected: (value) {
                        UnitModel unitModel = value as UnitModel;
                        controller.unitModel.value = unitModel;
                        controller.formKeyToAddBill.currentState!.patchValue({
                          BillAddKey.salePrice: AppTool.formatMoney(
                            unitModel.cost.toString(),
                          ),
                        });
                      },
                      onTap: () => unitController.getUnitsByProject(
                        controller.projectModel.value.id!,
                      ),
                      cardInfo: (UnitModel e) => DropdownMenuEntry(
                        enabled: e.customers!.isEmpty,
                        value: e,
                        label: e.customers!.isEmpty
                            ? e.name.toString()
                            : '  مباعى   ${e.name}',
                        labelWidget: e.customers!.isEmpty
                            ? Text(e.name.toString())
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '    ${e.name} (مباعة) ',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  const Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),

              // Group 2: Pricing and Box
              LayoutTabletPhone(
                children: [
                  Obx(() {
                    return Row(
                      children: [
                        Expanded(
                          child: AppTextFiled(
                            initialValue: intl.NumberFormat.decimalPattern()
                                .format(
                                  num.tryParse(
                                        controller.unitModel.value.cost ?? '0',
                                      ) ??
                                      0,
                                ),
                            isEnable: false,
                            name: BillAddKey.salePrice,
                            labelText: 'سعر البيع',
                            icon: Icons.monetization_on_outlined,
                            isMony: true,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_note, color: Colors.blue),
                          tooltip: 'تغيير سعر الوحدة الأصلي',
                          onPressed: () => buildDialogChangeUnitCost(),
                        ),
                      ],
                    );
                  }),
                  SelectDropDon(
                    name: BillAddKey.boxId,
                    label: 'القاصة',
                    required: true,
                    icon: Icons.account_balance_wallet_outlined,
                    onSelected: (value) {
                      controller.boxModel.value = value;
                    },
                    value: controller.projectModel.value.boxId,
                    onTap: () => _boxController.getAllBoxes(),
                    cardInfo: (BoxModel e) =>
                        DropdownMenuEntry(value: e, label: e.name.toString()),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Group 3: Map Type and Payment Type
              LayoutTabletPhone(
                children: [
                  SelectDropDon(
                    name: BillAddKey.plot,
                    required: true,
                    label: 'نوع الخارطة',
                    icon: Icons.map_outlined,
                    onTap: () async {
                      return [
                        DropdownMenuEntry(value: 'A', label: 'A'),
                        DropdownMenuEntry(value: 'B', label: 'B'),
                        DropdownMenuEntry(value: 'C', label: 'C'),
                      ];
                    },
                    cardInfo: (item) => DropdownMenuEntry(
                      value: item.value,
                      label: item.label.toString(),
                    ),
                  ),
                  SelectDropDon<dynamic>(
                    key: const ValueKey('payment_type_select'),
                    name: "payment_type",
                    required: true,
                    label: "نوع الدفع / القسط",
                    icon: Icons.payments_outlined,
                    onTap: () async {
                      return [
                        const DropdownMenuEntry<dynamic>(
                          value: -1,
                          label: "شراء مباشر (بدون أقساط)",
                        ),
                        const DropdownMenuEntry<dynamic>(
                          value: 1,
                          label: "أقساط مجدولة (بتواريخ)",
                        ),
                        const DropdownMenuEntry<dynamic>(
                          value: 0,
                          label: "أقساط بالنسب (نسبة مئوية)",
                        ),
                      ];
                    },
                    cardInfo: (item) => item,
                    onSelected: (val) {
                      if (val == -1) {
                        controller.installmentType.value = -1;
                        final salePrice = controller
                            .formKeyToAddBill
                            .currentState
                            ?.fields[BillAddKey.salePrice]
                            ?.value;
                        if (salePrice != null) {
                          controller
                              .formKeyToAddBill
                              .currentState
                              ?.fields[BillAddKey.downPayment]
                              ?.didChange(salePrice);
                        }
                      } else if (val == 1) {
                        controller.installmentType.value = 1;
                      } else if (val == 0) {
                        controller.installmentType.value = 0;
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Group 4: Down Payment and Note
              Obx(() {
                final isDirect = controller.installmentType.value == -1;
                return AppTextFiled(
                  name: BillAddKey.downPayment,
                  labelText: "الدفعة المقدمة (واصل)",
                  isMony: true,
                  icon: Icons.price_check,
                  isEnable: !isDirect,
                  validator: [
                    FormBuilderValidators.required(errorText: "مطلوب"),
                    (val) {
                      if (val == null || val.isEmpty) return null;
                      final cleaned = val.toString().replaceAll(',', '');
                      final downPayment = double.tryParse(cleaned);
                      if (downPayment == null) return null;

                      final salePriceStr = controller
                          .formKeyToAddBill
                          .currentState
                          ?.fields[BillAddKey.salePrice]
                          ?.value
                          ?.toString();
                      if (salePriceStr != null) {
                        final salePriceCleaned = salePriceStr.replaceAll(
                          ',',
                          '',
                        );
                        final salePrice = double.tryParse(salePriceCleaned);
                        if (salePrice != null && downPayment > salePrice) {
                          return "الدفعة المقدمة لا يمكن أن تتجاوز سعر البيع";
                        }
                      }
                      return null;
                    },
                  ],
                );
              }),
              const SizedBox(height: 16),
              AppTextFiled(
                name: BillAddKey.note,
                labelText: "ملاحظات",
                icon: Icons.note_alt_outlined,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildDialogChangeUnitCost() {
    return Get.dialog(
      AlertDialog(
        title: const Text('تغيير سعر الوحدة الأصلي'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: FormBuilder(
          key: controller.formKeyToChangeUnitCost,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextFiled(
                initialValue: intl.NumberFormat.decimalPattern().format(
                  num.tryParse(controller.unitModel.value.cost ?? '0') ?? 0,
                ),
                name: BillAddKey.unitCost,
                labelText: 'سعر الوحدة',
                icon: Icons.edit_calendar_outlined,
                isMony: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          CustomButton(
            backgroundColor: Colors.blue,
            onPressed: () async {
              if (controller.formKeyToChangeUnitCost.currentState!
                  .saveAndValidate()) {
                await controller.updateUnit(controller.unitModel.value.id!, {
                  UnitUpdateKey.id: controller.unitModel.value.id!,
                  UnitUpdateKey.name: controller.unitModel.value.name,
                  UnitUpdateKey.projectId: controller.unitModel.value.projectId,
                  UnitUpdateKey.percentageId:
                      controller.unitModel.value.percentage?.id,
                  UnitUpdateKey.cost: int.parse(
                    controller
                        .formKeyToChangeUnitCost
                        .currentState!
                        .value[BillAddKey.unitCost]
                        .toString()
                        .replaceAll(',', ''),
                  ),
                });
              }
            },
            text: 'حفظ',
          ),
        ],
      ),
    );
  }
}
