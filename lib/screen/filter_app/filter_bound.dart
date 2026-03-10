import 'package:contracting_management_dashbord/constant/enum/transaction_type_enum.dart';
import 'package:contracting_management_dashbord/controller/box_controller/box_controller.dart';
import 'package:contracting_management_dashbord/controller/customer_controller/customer_controller.dart';
import 'package:contracting_management_dashbord/controller/percentage_controller/percentage_controller.dart';
import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/controller/user_controller/user_controller.dart';
import 'package:contracting_management_dashbord/model/bond/bond_key.dart';
import 'package:contracting_management_dashbord/model/bond/filter_bond.dart';
import 'package:contracting_management_dashbord/widget/app_date_field.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:contracting_management_dashbord/widget/select_drop_don.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:contracting_management_dashbord/controller/staff_controller/staff_controller.dart';

class FilterBondDilog extends GetView<FilterBondController> {
  final Function(Map<String, dynamic>)? onFilterSubmit;
  final FilterBond filterBond;
  FilterBondDilog({super.key, this.onFilterSubmit, required this.filterBond});
  final BoxController _boxController = Get.find();
  final CustomerController _customerController = Get.find();
  final UserController _userController = Get.find();
  final PercentageController _percentageController = Get.find();
  final StaffController _staffController = Get.find();
  final ProjectController _projectController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: controller.formKey,
        initialValue: filterBond.toJson(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Text(
              'تصفية السندات',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Card for basic text fields and main dropdowns
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
                      name: BondFilterKey.title,
                      labelText: 'عنوان السند',
                      prefixWidget: const Icon(Icons.title),
                    ),
                    const SizedBox(height: 16),
                    SelectDropDon(
                      name: BondFilterKey.bondTypeId,
                      value: filterBond.bondTypeId,
                      label: 'نوع السند',
                      icon: Icons.category,
                      onTap: () async {
                        return TransactionTypeEnum.values
                            .map(
                              (e) => DropdownMenuEntry(
                                value: e.id,
                                label: e.label,
                              ),
                            )
                            .toList();
                      },
                      cardInfo: (item) => DropdownMenuEntry(
                        value: item.value,
                        label: item.label.toString(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SelectDropDon(
                      value: filterBond.boxId,
                      name: BondFilterKey.boxId,
                      label: 'الصندوق',
                      onTap: () => _boxController.getAllBoxes(),
                      cardInfo: (item) => DropdownMenuEntry(
                        label: item.name.toString(),
                        value: item.id,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card for People (User, Customer, Approvals)
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
                      value: filterBond.userId,
                      name: BondFilterKey.userId,
                      label: 'المستخدم',
                      icon: Icons.person,
                      onTap: () => _userController.getAllUsers(),
                      cardInfo: (item) => DropdownMenuEntry(
                        label: item.fullName.toString(),
                        value: item.id,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SelectDropDon(
                      value: filterBond.projectId,
                      name: BondFilterKey.projectId,
                      label: 'المشروع',
                      onTap: () => _projectController.getAllProjects(),
                      cardInfo: (item) => DropdownMenuEntry(
                        label: item.name.toString(),
                        value: item.id,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SelectDropDon(
                      name: BondFilterKey.staffId,
                      label: 'الموظف',
                      onTap: () => _staffController.getAllStaff(),
                      cardInfo: (item) => DropdownMenuEntry(
                        label: item.name.toString(),
                        value: item.id,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SelectDropDon(
                      value: filterBond.customerId,
                      name: BondFilterKey.customerId,
                      label: 'العميل',
                      icon: Icons.people,
                      onTap: () => _customerController.getAllCustomers(),
                      cardInfo: (item) => DropdownMenuEntry(
                        label: item.name.toString(),
                        value: item.id,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SelectDropDon(
                      value: filterBond.approvedBy,
                      name: BondFilterKey.approvedBy,
                      label: 'تمت الموافقة من قبل',
                      icon: Icons.check_circle_outline,
                      onTap: () => _userController.getAllUsers(),
                      cardInfo: (item) => DropdownMenuEntry(
                        label: item.fullName.toString(),
                        value: item.id,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SelectDropDon(
                      value: filterBond.notApprovedBy,
                      name: BondFilterKey.notApprovedBy,
                      label: 'لم تتم الموافقة من قبل',
                      icon: Icons.cancel_outlined,
                      onTap: () => _userController.getAllUsers(),
                      cardInfo: (item) => DropdownMenuEntry(
                        label: item.fullName.toString(),
                        value: item.id,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card for Percentage and Installment Settings
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
                      value: filterBond.percentageId,
                      name: BondFilterKey.percentageId,
                      label: 'النسبة',
                      icon: Icons.percent,
                      onTap: () => _percentageController.getAllPercentages(),
                      cardInfo: (item) => DropdownMenuEntry(
                        label: item.name.toString(),
                        value: item.id,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SelectDropDon(
                      value: filterBond.isScheduledInstallment,
                      key: const ValueKey('is_scheduled_installment_select'),
                      name: BondFilterKey.isScheduledInstallment,
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
                    // Checkbox for Is Complete
                    Card(
                      elevation: 0,
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: FormBuilderCheckbox(
                        name: BondFilterKey.isComplete,
                        title: const Text('مكتمل'),
                        activeColor: Theme.of(context).primaryColor,
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
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
                            name: BondFilterKey.createAtFrom,
                            labelText: 'من تاريخ',
                            icon: Icons.date_range,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppDateField(
                            name: BondFilterKey.createAtTo,
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
                            name: BondFilterKey.installmentDateFrom,
                            labelText: 'من تاريخ',
                            icon: Icons.date_range,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppDateField(
                            name: BondFilterKey.installmentDateTo,
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

class FilterBondController extends GetxController {
  final formKey = GlobalKey<FormBuilderState>();
  var hasFile = false.obs;
  var data = <String, dynamic>{}.obs;
}
