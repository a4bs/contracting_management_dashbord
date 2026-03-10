import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/controller/customer_controller/customer_controller.dart';
import 'package:contracting_management_dashbord/model/customer/customer_key.dart';
import 'package:contracting_management_dashbord/model/customer/customer_model.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:contracting_management_dashbord/widget/file_upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class AddCustomerDialog extends GetView<CustomerController> {
  final CustomerModel? customer;
  const AddCustomerDialog({Key? key, this.customer}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    // String? uploadedFileLink = customer?.files?.firstOrNull; // Unused now

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
                customer == null ? "إضافة عميل جديد" : "تعديل بيانات العميل",
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
                  CustomerAddKey.name: customer?.name,
                  CustomerAddKey.idCard: customer?.idCard,
                  CustomerAddKey.address: customer?.address,
                  CustomerAddKey.phone1: customer?.phone1,
                  CustomerAddKey.phone2: customer?.phone2,
                  // Ensure initial value for file is provided if editing (assuming customer.files works)
                  if (customer?.files != null && customer!.files!.isNotEmpty)
                    CustomerAddKey.file: customer!.files,
                },
                child: Column(
                  children: [
                    AppTextFiled(
                      name: CustomerAddKey.name,
                      labelText: "اسم العميل الكامل",
                      validator: [
                        FormBuilderValidators.required(
                          errorText: "هذا الحقل مطلوب",
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextFiled(
                            name: CustomerAddKey.idCard,
                            labelText: "رقم الهوية / البطاقة الموحدة",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppTextFiled(
                            name: CustomerAddKey.address,
                            labelText: "العنوان",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextFiled(
                            name: CustomerAddKey.phone1,
                            labelText: "رقم الهاتف 1",
                            isNumber: true,
                            validator: [
                              FormBuilderValidators.required(
                                errorText: "مطلوب",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppTextFiled(
                            name: CustomerAddKey.phone2,
                            labelText: "رقم الهاتف 2 (اختياري)",
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    FileUploadWidget(
                      name: CustomerAddKey.file,
                      label: "ملف العميل (الهوية / العقد)",
                      uploadUrl: AppApi.customer.uploadFile,
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
                    text: customer == null ? "إضافة" : "حفظ التعديلات",
                    backgroundColor: AppColors.lightPrimary,
                    onPressed: () async {
                      if (controller.formKey.currentState?.saveAndValidate() ??
                          false) {
                        final data = Map<String, dynamic>.from(
                          controller.formKey.currentState!.value,
                        );
                        // File list is already in data via FormBuilder

                        if (customer == null) {
                          await controller.addCustomer(data);
                        } else {
                          await controller.updateCustomer(
                            customer!.id.toString(),
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
