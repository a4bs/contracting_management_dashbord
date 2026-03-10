import 'package:contracting_management_dashbord/controller/user_controller/user_controller.dart';
import 'package:contracting_management_dashbord/model/user/user_model.dart';
import 'package:contracting_management_dashbord/model/user/user_key.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class AddUserDialog extends StatelessWidget {
  final UserModel? user;
  AddUserDialog({super.key, this.user});

  final UserController controller = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    final isEditing = user != null;

    return Dialog(
      backgroundColor: AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? "تعديل مستخدم" : "إضافة مستخدم جديد",
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightOnSurface,
                ),
              ),
              const SizedBox(height: 20),
              FormBuilder(
                key: controller.keyAdd,
                initialValue: isEditing
                    ? {
                        UserAddKey.username: user?.username,
                        UserAddKey.fullName: user?.fullName,
                        UserAddKey.email: user?.email,
                      }
                    : {},
                child: Column(
                  children: [
                    AppTextFiled(
                      name: UserAddKey.username,
                      isEnglish: true,
                      labelText: 'اسم المستخدم',
                      validator: [
                        FormBuilderValidators.required(
                          errorText: "هذا الحقل مطلوب",
                        ),
                        FormBuilderValidators.minLength(
                          3,
                          errorText:
                              "يجب أن يكون اسم المستخدم على الأقل 3 أحرف",
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppTextFiled(
                      name: UserAddKey.fullName,
                      labelText: 'الاسم الكامل',
                      validator: [
                        FormBuilderValidators.required(
                          errorText: "هذا الحقل مطلوب",
                        ),
                        FormBuilderValidators.minLength(
                          3,
                          errorText:
                              "يجب أن يكون الاسم الكامل على الأقل 3 أحرف",
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppTextFiled(
                      name: UserAddKey.email,
                      labelText: 'البريد الالكتروني',
                      validator: [
                        FormBuilderValidators.required(
                          errorText: "هذا الحقل مطلوب",
                        ),
                        FormBuilderValidators.email(
                          errorText: "بريد الكتروني غير صالح",
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppTextFiled(
                      name: UserAddKey.password,
                      labelText: 'كلمة المرور',
                      isPassword: true,
                      prefixWidget: IconButton(
                        icon: const Icon(Icons.password),
                        tooltip: "توليد كلمة مرور",
                        onPressed: () {
                          final pass = AppTool.generatePassword();
                          controller
                              .keyAdd
                              .currentState
                              ?.fields[UserAddKey.password]
                              ?.didChange(pass);
                        },
                      ),
                      validator: isEditing
                          ? []
                          : [
                              FormBuilderValidators.required(
                                errorText: "هذا الحقل مطلوب",
                              ),
                              FormBuilderValidators.minLength(
                                8,
                                errorText:
                                    "كلمة المرور يجب أن تكون 8 أحرف على الأقل",
                              ),
                              (value) {
                                if (value == null || value.isEmpty) return null;
                                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                  return "يجب أن تحتوي على حرف كبير واحد على الأقل";
                                }
                                return null;
                              },
                              (value) {
                                if (value == null || value.isEmpty) return null;
                                if (!RegExp(r'[a-z]').hasMatch(value)) {
                                  return "يجب أن تحتوي على حرف صغير واحد على الأقل";
                                }
                                return null;
                              },
                              (value) {
                                if (value == null || value.isEmpty) return null;
                                if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  return "يجب أن تحتوي على رقم واحد على الأقل";
                                }
                                return null;
                              },
                              (value) {
                                if (value == null || value.isEmpty) return null;
                                if (!RegExp(
                                  r'[!@#$%^&*(),.?":{}|<>]',
                                ).hasMatch(value)) {
                                  return "يجب أن تحتوي على رمز خاص واحد على الأقل";
                                }
                                return null;
                              },
                            ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("إلغاء"),
                  ),
                  const SizedBox(width: 8),
                  CustomButton(
                    text: isEditing ? "حفظ التعديلات" : "إضافة",
                    backgroundColor: AppColors.lightPrimary,
                    onPressed: () async {
                      if (controller.keyAdd.currentState?.saveAndValidate() ??
                          false) {
                        final formData = Map<String, dynamic>.from(
                          controller.keyAdd.currentState!.value,
                        );

                        if (isEditing) {
                          formData[UserGetKey.id] = user!.id;
                          if (formData[UserAddKey.password] == null ||
                              (formData[UserAddKey.password] as String)
                                  .isEmpty) {
                            formData.remove(UserAddKey.password);
                          } else {
                            formData[UserAddKey.passwordConfirmation] =
                                formData[UserAddKey.password];
                          }
                          await controller.updateUser(user!.id, formData);
                        } else {
                          formData[UserAddKey.passwordConfirmation] =
                              formData[UserAddKey.password];
                          await controller.addUser(formData);
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
