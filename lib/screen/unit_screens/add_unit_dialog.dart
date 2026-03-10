import 'package:contracting_management_dashbord/controller/percentage_controller/percentage_controller.dart';
import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/controller/unit_controller/unit_controller.dart';
import 'package:contracting_management_dashbord/model/percentage/percentage_model.dart';
import 'package:contracting_management_dashbord/model/project/project_model.dart';
import 'package:contracting_management_dashbord/model/unit/unit_key.dart';
import 'package:contracting_management_dashbord/model/unit/unit_model.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:contracting_management_dashbord/widget/select_drop_don.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class AddUnitDialog extends GetView<UnitController> {
  final UnitModel? unit;
  const AddUnitDialog({Key? key, this.unit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ProjectController>()) {
      Get.lazyPut(() => ProjectController());
    }
    final projectController = Get.find<ProjectController>();
    final percentageController = Get.find<PercentageController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.lightSurface,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                unit == null ? "إضافة وحدة سكنية" : "تعديل بيانات الوحدة",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightOnSurface,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 24),
              FormBuilder(
                key: controller.formKey,
                initialValue: {
                  UnitAddKey.name: unit?.name,
                  UnitAddKey.cost: unit?.cost,
                  UnitAddKey.projectId: unit?.projectId,
                },
                child: Column(
                  children: [
                    AppTextFiled(
                      name: UnitAddKey.name,
                      labelText: "اسم الوحدة",
                      validator: [
                        FormBuilderValidators.required(errorText: "مطلوب"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppTextFiled(
                      name: UnitAddKey.cost,
                      labelText: "الكلفة الإجمالية",
                      isNumber: true,
                      isMony: true,
                      validator: [
                        FormBuilderValidators.required(errorText: "مطلوب"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SelectDropDon<PercentageModel>(
                      name: UnitAddKey.percentageId,
                      label: "  نسبة الانجاز",
                      required: true,
                      value: unit?.percentage?.id,
                      onTap: () async =>
                          percentageController.getAllPercentages(),
                      cardInfo: (item) =>
                          DropdownMenuEntry(value: item.id, label: item.name),
                    ),
                    const SizedBox(height: 16),
                    SelectDropDon<ProjectModel>(
                      name: UnitAddKey.projectId,
                      label: "المشروع التابع له",
                      required: true,
                      value: unit?.projectId,
                      onTap: () async => projectController.getAllProjects(),
                      cardInfo: (item) => DropdownMenuEntry(
                        value: item.id,
                        label: item.name ?? '',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "إلغاء",
                      style: TextStyle(color: Colors.grey, fontFamily: 'Cairo'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CustomButton(
                    text: unit == null ? "إضافة" : "حفظ التعديلات",
                    backgroundColor: AppColors.lightPrimary,
                    onPressed: () async {
                      if (controller.formKey.currentState?.saveAndValidate() ??
                          false) {
                        final data = Map<String, dynamic>.from(
                          controller.formKey.currentState!.value,
                        );

                        // Clean money formatting if needed
                        if (data[UnitAddKey.cost] != null &&
                            data[UnitAddKey.cost] is String) {
                          data[UnitAddKey.cost] = data[UnitAddKey.cost]
                              .toString()
                              .replaceAll(',', '');
                        }

                        if (unit == null) {
                          await controller.addUnit(data);
                        } else {
                          await controller.updateUnit(
                            unit!.id.toString(),
                            data,
                          );
                        }
                        Get.back();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
