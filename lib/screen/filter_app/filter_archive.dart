import 'package:contracting_management_dashbord/controller/archive_controller/archive_controller.dart';
import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/controller/unit_controller/unit_controller.dart';
import 'package:contracting_management_dashbord/model/archive/archiv_filter_model.dart';
import 'package:contracting_management_dashbord/model/archive/archive_key.dart';
import 'package:contracting_management_dashbord/widget/app_date_field.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:contracting_management_dashbord/widget/select_drop_don.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class FilterArchive extends GetView<FilterArchiveController> {
  final ArchiveFilterModel? archiveFilterModel;
  final Function(Map<String, dynamic>)? onFilterSubmit;
  FilterArchive({super.key, this.onFilterSubmit, this.archiveFilterModel});
  final ArchiveController _archiveController = Get.find();
  final ProjectController _projectController = Get.find();
  final UnitController _unitController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: controller.formKey,
        // ignore: invalid_use_of_protected_member
        initialValue: archiveFilterModel?.toJson() ?? {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Text(
              'تصفية الأرشيف',
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
                      name: ArchiveFilterKey.title,
                      labelText: 'عنوان الأرشيف',
                      prefixWidget: const Icon(Icons.title),
                    ),
                    const SizedBox(height: 16),
                    AppTextFiled(
                      name: ArchiveFilterKey.details,
                      labelText: 'التفاصيل',
                      prefixWidget: const Icon(Icons.description),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    AppTextFiled(
                      name: ArchiveFilterKey.archiveNumber,
                      labelText: 'رقم الأرشيف',
                      prefixWidget: const Icon(Icons.confirmation_number),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date Range
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
                      'الفترة الزمنية',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AppDateField(
                            name: ArchiveFilterKey.dateFrom,
                            labelText: 'من تاريخ',
                            icon: Icons.date_range,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppDateField(
                            name: ArchiveFilterKey.dateTo,
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

            // Selects
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
                      value: archiveFilterModel?.archiveTypeId,
                      name: ArchiveFilterKey.archiveTypeId,
                      label: 'نوع الأرشيف',
                      onTap: () => _archiveController.getArchiveTypes(),
                      cardInfo: (item) =>
                          DropdownMenuEntry(label: item.name, value: item.id),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SelectDropDon(
                            value: archiveFilterModel?.projectId,
                            name: ArchiveFilterKey.projectId,
                            label: 'المشروع',
                            onTap: () => _projectController.getAllProjects(),
                            onSelected: (value) {
                              controller.projectid.value = value;
                            },
                            cardInfo: (item) => DropdownMenuEntry(
                              label: item.name.toString(),
                              value: item.id,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(
                            () => SelectDropDon(
                              value: archiveFilterModel?.unitId,
                              enabled: controller.projectid.value != 0,
                              name: ArchiveFilterKey.unitId,
                              label: 'الوحدة',
                              onTap: () => _unitController.getUnitsByProject(
                                controller.projectid.value,
                              ),
                              cardInfo: (item) => DropdownMenuEntry(
                                label: item.name.toString(),
                                value: item.id,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Checkbox
            Obx(
              () => Card(
                elevation: 0,
                color: Theme.of(
                  context,
                ).colorScheme.surfaceVariant.withOpacity(0.3),
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
                  await onFilterSubmit?.call(
                    controller.formKey.currentState!.instantValue,
                  );

                  if (controller.hasFile.value) {
                    controller.data.value =
                        controller.formKey.currentState!.instantValue;
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

class FilterArchiveController extends GetxController {
  var projectid = 0.obs;
  final formKey = GlobalKey<FormBuilderState>();
  var hasFile = false.obs;
  var data = <String, dynamic>{}.obs;
}
