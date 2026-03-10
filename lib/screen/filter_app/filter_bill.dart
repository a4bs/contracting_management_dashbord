import 'package:contracting_management_dashbord/controller/box_controller/box_controller.dart';
import 'package:contracting_management_dashbord/controller/customer_controller/customer_controller.dart';
import 'package:contracting_management_dashbord/controller/unit_controller/unit_controller.dart';
import 'package:contracting_management_dashbord/model/bill/bill_key.dart';
import 'package:contracting_management_dashbord/widget/app_date_field.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:contracting_management_dashbord/widget/select_drop_don.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class FilterBill extends GetView<FilterBillController> {
  final Function(Map<String, dynamic>)? onFilterSubmit;
  FilterBill({super.key, this.onFilterSubmit});
  final BoxController _boxController = Get.find();
  final UnitController _unitController = Get.find();
  final CustomerController _customerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: controller.formKey,
        initialValue: controller.hasFile.value ? controller.data : {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Text(
              'تصفية الفواتير',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Card for text fields
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    AppTextFiled(
                      name: BillFilterKey.id,
                      labelText: 'رقم الفاتورة',
                      prefixWidget: const Icon(Icons.numbers),
                    ),
                    const SizedBox(height: 16),
                    AppTextFiled(
                      name: BillFilterKey.note,
                      labelText: 'ملاحظات',
                      prefixWidget: const Icon(Icons.note),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    SelectDropDon(
                      name: BillFilterKey.plot,
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card for Dropdowns and Customer
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SelectDropDon(
                      name: BillFilterKey.boxId,
                      label: 'الصندوق',
                      onTap: () => _boxController.getAllBoxes(),
                      cardInfo: (item) => DropdownMenuEntry(
                        label: item.name.toString(),
                        value: item.id,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SelectDropDon(
                      name: BillFilterKey.unitId,
                      label: 'الوحدة',
                      onTap: () => _unitController.getAllUnits(),
                      cardInfo: (item) => DropdownMenuEntry(
                        label: item.name.toString(),
                        value: item.id,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SelectDropDon(
                      name: BillFilterKey.plot,
                      required: true,
                      label: ' العميل  ',
                      icon: Icons.map_outlined,
                      onTap: () => _customerController.getAllCustomers(),
                      cardInfo: (item) => DropdownMenuEntry(
                        value: item.id,
                        label: item.name.toString(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card for Date Ranges
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تاريخ الإنشاء',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AppDateField(
                            name: BillFilterKey.createdAtFrom,
                            labelText: 'من تاريخ',
                            icon: Icons.date_range,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppDateField(
                            name: BillFilterKey.createdAtTo,
                            labelText: 'إلى تاريخ',
                            icon: Icons.date_range_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'تاريخ القسط',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AppDateField(
                            name: BillFilterKey.installmentDateFrom,
                            labelText: 'من تاريخ',
                            icon: Icons.date_range,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppDateField(
                            name: BillFilterKey.installmentDateTo,
                            labelText: 'إلى تاريخ',
                            icon: Icons.date_range_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Checkbox for Scheduled Installment
            SelectDropDon(
              key: const ValueKey('payment_type_select'),
              name: BillFilterKey.isScheduledInstallment,
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
              cardInfo: (item) => DropdownMenuEntry(
                value: item.value,
                label: item.label.toString(),
              ),
            ),
            const SizedBox(height: 16),

            // Save Search Checkbox
            Obx(
              () => Card(
                elevation: 0,
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CheckboxListTile(
                  title: const Text('حفظ بيانات البحث للاستخدام القادم'),
                  value: controller.hasFile.value,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) {
                    controller.hasFile.value = value!;
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Search Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButton(
                text: 'بحث',
                onPressed: () async {
                  if (controller.formKey.currentState?.saveAndValidate() ??
                      false) {
                    await onFilterSubmit?.call(
                      controller.formKey.currentState!.value,
                    );

                    if (controller.hasFile.value) {
                      controller.data.assignAll(
                        controller.formKey.currentState!.value,
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class FilterBillController extends GetxController {
  final formKey = GlobalKey<FormBuilderState>();
  var hasFile = false.obs;
  var data = <String, dynamic>{}.obs;
}
