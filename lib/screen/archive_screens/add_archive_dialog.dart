import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/controller/archive_controller/archive_controller.dart';
import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/controller/unit_controller/unit_controller.dart';
import 'package:contracting_management_dashbord/model/archive/archive_key.dart';
import 'package:contracting_management_dashbord/model/archive/archive_model.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
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

class AddArchiveDialog extends GetView<ArchiveController> {
  final ArchiveModel? archive;
  const AddArchiveDialog({Key? key, this.archive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ProjectController>()) {
      Get.lazyPut(() => ProjectController());
    }
    if (!Get.isRegistered<UnitController>()) {
      Get.lazyPut(() => UnitController());
    }

    final projectController = Get.find<ProjectController>();
    final unitController = Get.find<UnitController>();

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
                archive == null
                    ? "إضافة وثيقة للأرشيف"
                    : "تعديل بيانات الأرشيف",
                style: const TextStyle(
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
                  ArchiveAddKey.title: archive?.title,
                  ArchiveAddKey.details: archive?.details,
                  ArchiveAddKey.archiveNumber: archive?.archiveNumber
                      ?.toString(),
                  ArchiveAddKey.projectId: archive?.projectId,
                  ArchiveAddKey.unitId: archive?.unitId,
                  ArchiveAddKey.archiveTypeId: archive?.archiveTypeId,
                  ArchiveAddKey.filePath:
                      (archive?.files != null && archive!.files!.isNotEmpty)
                      ? archive!.files!
                      : null,
                  ArchiveAddKey.date: archive?.date != null
                      ? DateTime.tryParse(archive!.date!)
                      : null,
                },
                child: Column(
                  children: [
                    AppTextFiled(
                      name: ArchiveAddKey.title,
                      labelText: "عنوان الوثيقة",
                      validator: [
                        FormBuilderValidators.required(errorText: "مطلوب"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppTextFiled(
                      isNumber: true,
                      name: ArchiveAddKey.archiveNumber,
                      labelText: "رقم الوثيقة",
                      validator: [
                        FormBuilderValidators.required(errorText: "مطلوب"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppDateField(
                      validator: [
                        FormBuilderValidators.required(errorText: "مطلوب"),
                      ],
                      name: ArchiveAddKey.date,
                      labelText: "تاريخ الوثيقة",
                    ),
                    const SizedBox(height: 16),
                    SelectDropDon(
                      name: ArchiveAddKey.projectId,
                      label: "المشروع",
                      value: archive?.projectId,
                      onTap: () => projectController.getAllProjects(),
                      cardInfo: (item) => DropdownMenuEntry(
                        value: item.id,
                        label: item.name ?? "",
                      ),
                    ),
                    const SizedBox(height: 16),
                    SelectDropDon(
                      name: ArchiveAddKey.unitId,
                      label: "الوحدة",
                      value: archive?.unitId,
                      onTap: () => unitController.getUnitsByProject(
                        controller
                            .formKey
                            .currentState
                            ?.fields[ArchiveAddKey.projectId]
                            ?.value,
                      ),
                      cardInfo: (item) => DropdownMenuEntry(
                        value: item.id,
                        label: item.name ?? "",
                      ),
                    ),
                    const SizedBox(height: 16),
                    SelectDropDon(
                      required: true,
                      name: ArchiveAddKey.archiveTypeId,
                      label: "النوع",
                      value: archive?.archiveTypeId,
                      onTap: () => controller.getArchiveTypes(),
                      cardInfo: (item) =>
                          DropdownMenuEntry(value: item.id, label: item.name),
                    ),
                    const SizedBox(height: 16),
                    AppTextFiled(
                      name: ArchiveAddKey.details,
                      labelText: "تفاصيل الوثيقة",
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),
                    FileUploadWidget(
                      // validator: [
                      //   FormBuilderValidators.required(
                      //     errorText: " الفايل مطلوب",
                      //   ),
                      // ],
                      name: ArchiveAddKey.filePath,
                      label: "إرفاق ملف الوثيقة",
                      uploadUrl: AppApi.archive.uploadFile,
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
                    text: archive == null ? "إضافة" : "حفظ التعديلات",
                    backgroundColor: AppColors.lightPrimary,
                    onPressed: () async {
                      if (controller.formKey.currentState?.saveAndValidate() ??
                          false) {
                        final data = Map<String, dynamic>.from(
                          controller.formKey.currentState!.value,
                        );

                        if (data[ArchiveAddKey.date] is DateTime) {
                          data[ArchiveAddKey.date] = AppTool.formatDate(
                            data[ArchiveAddKey.date],
                          );
                        } else if (data[ArchiveAddKey.date] is String) {
                          // Try to ensure it is in correct format if it returns as string
                          try {
                            data[ArchiveAddKey.date] = AppTool.formatDate(
                              DateTime.parse(data[ArchiveAddKey.date]),
                            );
                          } catch (e) {
                            // ignore or handle error
                          }
                        }

                        if (archive == null) {
                          await controller.addArchive(data);
                        } else {
                          await controller.updateArchive(
                            archive!.id.toString(),
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
