import 'package:contracting_management_dashbord/controller/box_controller/box_controller.dart';
import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/model/box/box_model.dart';

import 'package:contracting_management_dashbord/model/project/project_key.dart';
import 'package:contracting_management_dashbord/model/project/project_model.dart';
import 'package:contracting_management_dashbord/model/project/project_type_model.dart';
import 'package:contracting_management_dashbord/model/project_status/project_status_model.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:contracting_management_dashbord/widget/layout_tablet_phone.dart';
import 'package:contracting_management_dashbord/widget/select_drop_don.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddProjectDialog extends GetView<ProjectController> {
  final ProjectModel? project;
  AddProjectDialog({Key? key, this.project}) : super(key: key);
  final _boxController = Get.find<BoxController>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.lightSurface,
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project == null ? "إضافة مشروع" : "تعديل مشروع",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightOnSurface,
                ),
              ),
              const SizedBox(height: 24),
              FormBuilder(
                key: controller.formKey,
                initialValue: {
                  ProjectAddKey.name: project?.name,
                  ProjectAddKey.cost: project?.cost,
                  ProjectAddKey.projectStatusId: project?.projectStatusId,
                  ProjectAddKey.projectTypeId: project?.projectTypeId,
                },
                child: Column(
                  children: [
                    LayoutTabletPhone(
                      children: [
                        AppTextFiled(
                          name: ProjectAddKey.name,
                          labelText: "اسم المشروع",
                          validator: [
                            FormBuilderValidators.required(errorText: "مطلوب"),
                          ],
                        ),
                        const SizedBox(width: 16),
                        AppTextFiled(
                          name: ProjectAddKey.cost,
                          labelText: "الكلفة",
                          isNumber: true,
                          isMony: true,
                          validator: [
                            FormBuilderValidators.required(errorText: "مطلوب"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LayoutTabletPhone(
                      children: [
                        SelectDropDon<ProjectTypeModel>(
                          name: ProjectAddKey.projectTypeId,
                          label: "نوع المشروع",
                          required: true,
                          value: project?.projectTypeId,
                          onSelected: (val) =>
                              controller.checkShowUnitConfig(val),
                          onTap: () async => controller.getAllProjectTypes(),
                          cardInfo: (item) => DropdownMenuEntry(
                            value: item.id,
                            label: item.name ?? '',
                          ),
                        ),

                        const SizedBox(width: 16),
                        SelectDropDon<ProjectStatusModel>(
                          name: ProjectAddKey.projectStatusId,
                          label: "حالة المشروع",
                          required: true,
                          value: project?.projectStatusId,
                          onTap: () async => controller.getAllProjectStatus(),
                          cardInfo: (item) => DropdownMenuEntry(
                            value: item.id ?? 0,
                            label: item.name ?? '',
                          ),
                        ),
                        const SizedBox(width: 16),
                        SelectDropDon<BoxModel>(
                          name: ProjectAddKey.boxId,
                          label: " القاصه التابع لها ",
                          required: true,
                          value: project?.projectStatusId,
                          onTap: () async => _boxController.getAllBoxes(),
                          cardInfo: (item) => DropdownMenuEntry(
                            value: item.id ?? 0,
                            label: item.name ?? '',
                          ),
                        ),
                      ],
                    ),
                    if (project == null)
                      Obx(
                        () => controller.isShowUnitConfig.value
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Divider(),
                                  ),
                                  Text(
                                    "توليد الوحدات (إعداد أولي)",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  LayoutTabletPhone(
                                    children: [
                                      AppTextFiled(
                                        name: ProjectAddKey.unitName,
                                        labelText: "رمز الوحدة",
                                        hintText: "مثال: A",
                                      ),
                                      const SizedBox(width: 12),
                                      AppTextFiled(
                                        name: ProjectAddKey.unitCount,
                                        labelText: "عدد الوحدات",
                                        isNumber: true,
                                      ),
                                      const SizedBox(width: 12),
                                      AppTextFiled(
                                        name: ProjectAddKey.unitCost,
                                        labelText: "كلفة الوحدة",
                                        isNumber: true,
                                        isMony: true,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
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
                    child: Text("إلغاء", style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(width: 12),
                  CustomButton(
                    text: project == null ? "إضافة" : "حفظ التعديلات",
                    backgroundColor: AppColors.lightPrimary,
                    onPressed: () async {
                      if (controller.formKey.currentState?.saveAndValidate() ??
                          false) {
                        final data = controller.formKey.currentState!.value;
                        Map<String, dynamic> finalData = Map.from(data);

                        if (finalData[ProjectAddKey.cost] != null &&
                            finalData[ProjectAddKey.cost] is String) {
                          finalData[ProjectAddKey.cost] =
                              finalData[ProjectAddKey.cost]
                                  .toString()
                                  .replaceAll(',', '');
                        }
                        if (finalData[ProjectAddKey.unitCost] != null &&
                            finalData[ProjectAddKey.unitCost] is String) {
                          finalData[ProjectAddKey.unitCost] =
                              finalData[ProjectAddKey.unitCost]
                                  .toString()
                                  .replaceAll(',', '');
                        }

                        if (project == null) {
                          finalData[ProjectUpdateKey.isEnable] = 1;
                          await controller.addProject(finalData);
                        } else {
                          finalData[ProjectUpdateKey.id] = project!.id;
                          await controller.updateProject(
                            project!.id.toString(),
                            finalData,
                          );
                        }
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
