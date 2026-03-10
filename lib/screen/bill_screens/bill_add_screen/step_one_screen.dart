import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/controller/bill_controller/bill_add_controlle.dart';
import 'package:contracting_management_dashbord/model/customer/customer_key.dart';
import 'package:contracting_management_dashbord/model/customer/customer_model.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/file_upload_widget.dart';
import 'package:contracting_management_dashbord/widget/layout_tablet_phone.dart';
import 'package:contracting_management_dashbord/widget/customer_search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class StepOneScreen extends GetView<BillAddController> {
  StepOneScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: RadioGroup(
              groupValue: controller.isCreateNewCustomer.value,
              onChanged: (value) {
                controller.isCreateNewCustomer.value = value as bool;
                if (controller.isCreateNewCustomer.value == true) {
                  controller.customerModel.value = CustomerModel();
                  controller.formKeyToAddCustomer.currentState!.reset();
                }
              },
              child: Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      value: true,
                      title: Text(' إنشاء عميل جديد'),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      value: false,
                      title: Text(' اختيار عميل موجود'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // _buildCustomerSelectionView(context),
        Obx(
          () => controller.isCreateNewCustomer.value
              ? _buildCustomerCreationView(context)
              : _buildCustomerSelectionView(context),
        ),
      ],
    );
  }

  Widget _buildCustomerSelectionView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.search, color: AppColors.lightPrimary),
              const SizedBox(width: 8),
              Text(
                'البحث عن عميل',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightOnSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 8.0, bottom: 8.0),
              child: Text(
                'اختر العميل',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Obx(() {
            final selectedCustomer = controller.customerModel.value;
            final customerName =
                selectedCustomer.name ?? 'اضغط هنا للبحث واختيار عميل...';
            return InkWell(
              onTap: () async {
                final result = await Get.dialog<CustomerModel>(
                  const CustomerSearchDialog(),
                );
                if (result != null) {
                  controller.customerModel.value = result;
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      customerName,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: selectedCustomer.id == null
                            ? Colors.grey.shade600
                            : Colors.black87,
                      ),
                    ),
                    const Icon(Icons.search, color: Colors.grey),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          Obx(() {
            final customer = controller.customerModel.value;
            if (customer.id != null) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.lightPrimary.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.lightPrimary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: AppColors.lightPrimary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'معلومات العميل',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightOnSurface,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32, thickness: 1),
                    _buildInfoRow(
                      Icons.account_circle_outlined,
                      'الاسم',
                      customer.name ?? '-',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.phone_outlined,
                      'رقم الهاتف',
                      customer.phone1 ?? '-',
                    ),
                    if (customer.phone2 != null &&
                        customer.phone2!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.phone_iphone,
                        'رقم الهاتف 2',
                        customer.phone2!,
                      ),
                    ],
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.location_on_outlined,
                      'العنوان',
                      customer.address ?? '-',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.badge_outlined,
                      'رقم الهوية',
                      customer.idCard ?? '-',
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildCustomerCreationView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: FormBuilder(
        initialValue: controller.isCreateNewCustomer.value
            ? {
                CustomerAddKey.name: controller.customerModel.value.name,
                CustomerAddKey.phone1: controller.customerModel.value.phone1,
                CustomerAddKey.phone2: controller.customerModel.value.phone2,
                CustomerAddKey.address: controller.customerModel.value.address,
                CustomerAddKey.idCard: controller.customerModel.value.idCard,
                CustomerAddKey.file: controller.customerModel.value.files,
              }
            : {},
        key: controller.formKeyToAddCustomer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات العميل الجديد',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Customer Name
            AppTextFiled(
              name: CustomerAddKey.name,
              labelText: 'اسم العميل الكامل',
              validator: [
                FormBuilderValidators.required(errorText: 'هذا الحقل مطلوب'),
              ],
            ),
            const SizedBox(height: 16),

            // ID Card and Address Row - Mobile Friendly: Stack vertically if needed, but row is ok for small fields
            // For better mobile view, let's keep them in Row but ensure Flexible space
            LayoutTabletPhone(
              children: [
                AppTextFiled(
                  name: CustomerAddKey.idCard,
                  labelText: 'رقم الهوية',
                ),
                const SizedBox(width: 12),
                AppTextFiled(
                  name: CustomerAddKey.address,
                  labelText: 'العنوان',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Phone Numbers Row
            LayoutTabletPhone(
              children: [
                AppTextFiled(
                  name: CustomerAddKey.phone1,
                  labelText: 'رقم الهاتف 1',
                  isNumber: true,
                  validator: [
                    FormBuilderValidators.required(errorText: 'مطلوب'),
                    FormBuilderValidators.range(
                      11,
                      11,
                      errorText: 'يجب أن يكون  11 رقم',
                    ),
                    FormBuilderValidators.startsWith(
                      '07',
                      errorText: 'يجب أن يبدأ برقم 07',
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                AppTextFiled(
                  name: CustomerAddKey.phone2,
                  labelText: 'رقم الهاتف 2',
                  isNumber: true,
                  validator: [
                    FormBuilderValidators.required(errorText: 'مطلوب'),
                    FormBuilderValidators.range(
                      11,
                      11,
                      errorText: 'يجب أن يكون  11 رقم',
                    ),
                    FormBuilderValidators.startsWith(
                      '07',
                      errorText: 'يجب أن يبدأ برقم 07',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // File Upload Widget
            FileUploadWidget(
              name: CustomerAddKey.file,
              label: 'ملف العميل (الهوية / العقد)',
              uploadUrl: AppApi.customer.uploadFile,
            ),
            const SizedBox(height: 24),

            // Info Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightPrimary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.lightPrimary.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.lightPrimary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'سيتم حفظ بيانات العميل تلقائياً عند إنشاء الفاتورة',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: Text(
            '$label : ',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.lightOnSurface,
            ),
          ),
        ),
      ],
    );
  }
}
