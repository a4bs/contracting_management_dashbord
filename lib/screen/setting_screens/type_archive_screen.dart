import 'package:contracting_management_dashbord/controller/archive_controller/archive_controller.dart';
import 'package:contracting_management_dashbord/model/archive/archive_type_model.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:contracting_management_dashbord/widget/futuer_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class TypeArchiveScreen extends GetView<ArchiveController> {
  const TypeArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDialog(),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        label: const Text(
          "إضافة نوع",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      body: FutuerPageWidget(
        controller: controller.archiveTypePaginationController,
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
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.inventory_2_rounded,
                    color: Colors.orange,
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
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (data.isEnable == true)
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          (data.isEnable == true) ? "مفعل" : "غير مفعل",
                          style: TextStyle(
                            color: (data.isEnable == true)
                                ? Colors.green[700]
                                : Colors.red[700],
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ],
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
          return controller.getArchiveTypes();
        },
      ),
    );
  }

  void _showDialog({ArchiveTypeModel? model}) {
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
              'is_enable': model?.isEnable ?? true,
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
                      model == null ? "إضافة نوع جديد" : "تعديل النوع",
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
                      errorText: 'الرجاء إدخال اسم الأرشيف',
                    ),
                  ],
                  name: 'name',
                  labelText: 'اسم النوع',
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: FormBuilderCheckbox(
                    name: 'is_enable',
                    title: const Text(
                      'تفعيل هذا النوع',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    activeColor: Theme.of(Get.context!).primaryColor,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  width: double.infinity,
                  text: 'حفظ التغييرات',
                  onPressed: () async {
                    if (localFormKey.currentState!.saveAndValidate()) {
                      if (model == null) {
                        await controller.addArchiveType(
                          localFormKey.currentState!.value,
                        );
                      } else {
                        await controller.updateArchiveType(
                          model.id.toString(),
                          localFormKey.currentState!.value,
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
