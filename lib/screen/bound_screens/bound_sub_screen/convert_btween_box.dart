import 'dart:io';

import 'package:contracting_management_dashbord/constant/enum/transaction_type_enum.dart';
import 'package:contracting_management_dashbord/controller/bond_controller/bond_controller.dart';
import 'package:contracting_management_dashbord/controller/box_controller/box_controller.dart';
import 'package:contracting_management_dashbord/model/bond/bond_key.dart';
import 'package:contracting_management_dashbord/model/bond/filter_bond.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/cards/cards_bound.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:contracting_management_dashbord/widget/futuer_pagnation_page_widget.dart';
import 'package:contracting_management_dashbord/widget/layout_tablet_phone.dart';
import 'package:contracting_management_dashbord/widget/select_drop_don.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class ConvertBtweenBox extends GetView<BondController> {
  ConvertBtweenBox({super.key});
  final BoxController boxController = Get.find<BoxController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          // Form Card - Compact
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FormBuilder(
              key: controller.formKeyToConvertBox,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sync_alt_rounded,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'تحويل بين الصناديق',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Form Fields
                  LayoutTabletPhone(
                    children: [
                      AppTextFiled(
                        validator: [
                          FormBuilderValidators.required(errorText: 'مطلوب'),
                        ],
                        labelText: 'العنوان',
                        name: BondAddKey.title,
                      ),
                      AppTextFiled(
                        isMony: true,
                        validator: [
                          FormBuilderValidators.required(errorText: 'مطلوب'),
                        ],
                        labelText: 'المبلغ',
                        name: BondAddKey.amount,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  LayoutTabletPhone(
                    children: [
                      SelectDropDon(
                        name: BondAddKey.boxId,
                        required: true,
                        label: 'من صندوق',
                        onTap: () => boxController.getAllBoxes(),
                        onSelected: (value) {
                          controller.idBoxFrom.value = value;
                          controller.idBoxFrom.refresh();
                        },
                        onClear: () {
                          controller.idBoxFrom.value = 0;
                          controller.idBoxFrom.refresh();
                        },
                        cardInfo: (item) => DropdownMenuEntry(
                          value: item.id,
                          label: item.name.toString(),
                        ),
                      ),
                      SelectDropDon(
                        name: BondAddKey.boxIdTo,
                        required: true,
                        label: 'إلى صندوق',
                        onTap: () => boxController.getAllBoxes(),
                        onSelected: (value) {
                          controller.idBoxTo.value = value;
                          controller.idBoxTo.refresh();
                        },
                        onClear: () {
                          controller.idBoxTo.value = 0;
                          controller.idBoxTo.refresh();
                        },
                        cardInfo: (item) => DropdownMenuEntry(
                          enabled: item.id != controller.idBoxFrom.value,
                          value: item.id,
                          label: item.name.toString(),
                          labelWidget: Text(item.name.toString()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Submit Button
                  CustomButton(
                    width: double.infinity,
                    text: 'تحويل',
                    onPressed: () => _handleConvert(),
                  ),
                ],
              ),
            ),
          ),

          if (!Platform.isAndroid)
            Expanded(
              child: Obx(() {
                final hasFromBox = controller.idBoxFrom.value != 0;
                final hasToBox = controller.idBoxTo.value != 0;

                if (!hasFromBox && !hasToBox) {
                  return _buildEmptyState();
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Row(
                    children: [
                      if (hasFromBox)
                        Expanded(
                          child: _buildBondList(
                            controller.idBoxFrom.value,
                            TransactionTypeEnum.debit,
                            controller.pageDataPagnationController2,
                            'السحوبات',
                            Colors.red,
                            Icons.arrow_upward_rounded,
                          ),
                        ),
                      if (hasFromBox && hasToBox) const SizedBox(width: 12),
                      if (hasToBox)
                        Expanded(
                          child: _buildBondList(
                            controller.idBoxTo.value,
                            TransactionTypeEnum.credit,
                            controller.pageDataPagnationController,
                            'الإيداعات',
                            Colors.green,
                            Icons.arrow_downward_rounded,
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildBondList(
    int boxId,
    TransactionTypeEnum type,
    dynamic paginationController,
    String title,
    Color color,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // List Header
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: color,
                  ),
                ),
              ],
            ),
          ),

          // List Content
          Expanded(
            child: FutuerPagnationPageWidget(
              handelData: (page, limit) => controller.filterBonds(
                FilterBond(
                  page: page,
                  limit: limit,
                  bondTypeId: type.id,
                  boxId: boxId,
                ),
              ),
              cardInfo: (item, index) => CardsBound(bond: item),
              controller: paginationController,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'اختر الصناديق لعرض السندات',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleConvert() async {
    if (controller.formKeyToConvertBox.currentState!.validate()) {
      // Clean amount value
      controller.formKeyToConvertBox.currentState!.fields[BondAddKey.amount]!
          .setValue(
            controller
                .formKeyToConvertBox
                .currentState!
                .fields[BondAddKey.amount]!
                .value
                .toString()
                .replaceAll(",", ""),
          );

      // Convert
      await controller.convertBoundToBox({
        ...controller.formKeyToConvertBox.currentState!.instantValue,
        BondAddKey.bondTypeId: TransactionTypeEnum.credit.id,
      });

      // Refresh lists
      controller.pageDataPagnationController.refreshItems(
        (page, limit) => controller.filterBonds(
          FilterBond(
            page: page,
            limit: limit,
            boxId: controller.idBoxFrom.value,
            bondTypeId: TransactionTypeEnum.credit.id,
          ),
        ),
      );

      controller.pageDataPagnationController2.refreshItems(
        (page, limit) => controller.filterBonds(
          FilterBond(
            page: page,
            limit: limit,
            boxId: controller.idBoxTo.value,
            bondTypeId: TransactionTypeEnum.debit.id,
          ),
        ),
      );

      // Reset form
      controller.formKeyToConvertBox.currentState!.reset();
    }
  }
}
