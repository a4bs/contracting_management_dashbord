import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/model/box/box_key.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:contracting_management_dashbord/widget/select_drop_don.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class FilterBox extends GetView<FilterBoxController> {
  final Function(Map<String, dynamic>)? onFilterSubmit;
  FilterBox({super.key, this.onFilterSubmit});
  final ProjectController _projectController = Get.find();

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
              'تصفية الصناديق',
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
                      name: BoxFilterKey.name,
                      labelText: 'اسم الصندوق',
                      prefixWidget: const Icon(Icons.title),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card for Selects
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
                      name: BoxFilterKey.projectId,
                      label: 'المشروع',
                      onTap: () => _projectController.getAllProjects(),
                      cardInfo: (item) => DropdownMenuEntry(
                        label: item.name.toString(),
                        value: item.id,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SelectDropDon(
                      name: BoxFilterKey.isEnable,
                      label: 'الحالة',
                      icon: Icons.check_circle_outline,
                      onTap: () async {
                        return [
                          const DropdownMenuEntry(value: true, label: 'نشط'),
                          const DropdownMenuEntry(
                            value: false,
                            label: 'غير نشط',
                          ),
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

class FilterBoxController extends GetxController {
  final formKey = GlobalKey<FormBuilderState>();
  var hasFile = false.obs;
  var data = <String, dynamic>{}.obs;
}
