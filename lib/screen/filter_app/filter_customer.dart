import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class CustomerFilterKey {
  static const String name = 'name';
  static const String phone1 = 'phone1';
  static const String phone2 = 'phone2';
  static const String address = 'address';
  static const String idCard = 'id_card';
}

class FilterCustomer extends GetView<FilterCustomerController> {
  final Function(Map<String, dynamic>)? onFilterSubmit;
  const FilterCustomer({super.key, this.onFilterSubmit});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: controller.formKey,
        initialValue: controller.hasFile.value
            ? Map<String, dynamic>.from(controller.data)
            : <String, dynamic>{},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Text(
              'تصفية العملاء',
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
                      name: CustomerFilterKey.name,
                      labelText: 'اسم العميل',
                      prefixWidget: const Icon(Icons.person),
                    ),
                    const SizedBox(height: 16),
                    AppTextFiled(
                      name: CustomerFilterKey.phone1,
                      labelText: 'رقم الهاتف 1',
                      prefixWidget: const Icon(Icons.phone),
                    ),
                    const SizedBox(height: 16),
                    AppTextFiled(
                      name: CustomerFilterKey.phone2,
                      labelText: 'رقم الهاتف 2',
                      prefixWidget: const Icon(Icons.phone),
                    ),
                    const SizedBox(height: 16),
                    AppTextFiled(
                      name: CustomerFilterKey.address,
                      labelText: 'العنوان',
                      prefixWidget: const Icon(Icons.location_on),
                    ),
                    const SizedBox(height: 16),
                    AppTextFiled(
                      name: CustomerFilterKey.idCard,
                      labelText: 'رقم الهوية',
                      prefixWidget: const Icon(Icons.credit_card),
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
                    } else {
                      controller.data.clear();
                    }
                    Get.back(); // Close the dialog after submitting
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

class FilterCustomerController extends GetxController {
  final formKey = GlobalKey<FormBuilderState>();
  var hasFile = false.obs;
  var data = <String, dynamic>{}.obs;
}
