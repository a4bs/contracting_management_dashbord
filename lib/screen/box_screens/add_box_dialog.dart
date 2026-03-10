import 'package:contracting_management_dashbord/controller/box_controller/box_controller.dart';
import 'package:contracting_management_dashbord/model/box/box_key.dart';
import 'package:contracting_management_dashbord/model/box/box_model.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class AddBoxDialog extends GetView<BoxController> {
  final BoxModel? box;
  const AddBoxDialog({Key? key, this.box}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                box == null ? "إضافة قاصة جديدة" : "تعديل بيانات القاصة",
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
                  BoxAddKey.name: box?.name,
                  BoxAddKey.isEnable: box?.isEnable ?? '1',
                },
                child: Column(
                  children: [
                    AppTextFiled(
                      name: BoxAddKey.name,
                      labelText: "اسم القاصة",
                      validator: [
                        FormBuilderValidators.required(errorText: "مطلوب"),
                      ],
                    ),

                    const SizedBox(height: 16),
                    FormBuilderRadioGroup<String>(
                      name: BoxAddKey.isEnable,
                      decoration: const InputDecoration(
                        labelText: "الحالة",
                        labelStyle: TextStyle(fontFamily: 'Cairo'),
                        border: InputBorder.none,
                      ),
                      options: const [
                        FormBuilderFieldOption(
                          value: '1',
                          child: Text(
                            "نشط",
                            style: TextStyle(fontFamily: 'Cairo'),
                          ),
                        ),
                        FormBuilderFieldOption(
                          value: '0',
                          child: Text(
                            "غير نشط",
                            style: TextStyle(fontFamily: 'Cairo'),
                          ),
                        ),
                      ],
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
                    text: box == null ? "إضافة" : "حفظ التعديلات",
                    backgroundColor: AppColors.lightPrimary,
                    onPressed: () async {
                      if (controller.formKey.currentState?.saveAndValidate() ??
                          false) {
                        final data = Map<String, dynamic>.from({
                          ...controller.formKey.currentState!.value,
                          BoxAddKey.parentId: '1',
                        });

                        if (box == null) {
                          await controller.addBox(data);
                        } else {
                          await controller.updateBox(box!.id.toString(), data);
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
