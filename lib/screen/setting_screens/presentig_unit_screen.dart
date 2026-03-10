import 'package:contracting_management_dashbord/controller/percentage_controller/percentage_controller.dart';
import 'package:contracting_management_dashbord/model/percentage/percentage_model.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:contracting_management_dashbord/widget/futuer_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class PresentigUnitScreen extends GetView<PercentageController> {
  const PresentigUnitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDialog(),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        label: const Text(
          "إضافة نسبة",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      body: FutuerPageWidget(
        controller: controller.paginationController,
        cardInfo: (data, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Material(
              color: Colors.transparent,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.percent_rounded,
                    color: Colors.purple,
                    size: 24,
                  ),
                ),
                title: Text(
                  data.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Cairo',
                    color: Color(0xFF1E293B),
                  ),
                ),
                subtitle: Text(
                  "${data.percent}%",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
                trailing: IconButton(
                  onPressed: () => _showDialog(model: data),
                  icon: const Icon(Icons.edit_rounded, color: Colors.grey),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ),
            ),
          );
        },
        handelData: () {
          return controller.getAllPercentages();
        },
      ),
    );
  }

  void _showDialog({PercentageModel? model}) {
    final GlobalKey<FormBuilderState> localFormKey =
        GlobalKey<FormBuilderState>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: FormBuilder(
            key: localFormKey,
            initialValue: {
              'name': model?.name,
              'percent': model?.percent.toString(),
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          Get.context!,
                        ).primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        model == null ? Icons.add_rounded : Icons.edit_rounded,
                        color: Theme.of(Get.context!).primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      model == null ? "إضافة نسبة جديدة" : "تعديل النسبة",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        color: Theme.of(Get.context!).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AppTextFiled(
                  validator: [
                    FormBuilderValidators.required(
                      errorText: 'الرجاء إدخال الاسم',
                    ),
                  ],
                  name: 'name',
                  labelText: 'الاسم',
                ),
                const SizedBox(height: 16),
                AppTextFiled(
                  validator: [
                    FormBuilderValidators.required(
                      errorText: 'الرجاء إدخال النسبة',
                    ),
                    FormBuilderValidators.numeric(
                      errorText: 'الرجاء إدخال رقم صحيح',
                    ),
                  ],
                  name: 'percent',
                  labelText: 'النسبة',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  width: double.infinity,
                  text: 'حفظ التغييرات',
                  onPressed: () async {
                    if (localFormKey.currentState!.saveAndValidate()) {
                      final data = localFormKey.currentState!.value;
                      // Ensure percent is a number
                      final processedData = Map<String, dynamic>.from(data);
                      if (processedData['percent'] is String) {
                        processedData['percent'] =
                            int.tryParse(processedData['percent']) ?? 0;
                      }

                      if (model == null) {
                        await controller.addPercentage(processedData);
                      } else {
                        await controller.updatePercentage(
                          model.id!,
                          processedData,
                        );
                      }
                      Get.back(); // Close dialog after success
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
