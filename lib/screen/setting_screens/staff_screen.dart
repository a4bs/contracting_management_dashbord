import 'package:contracting_management_dashbord/controller/staff_controller/staff_controller.dart';
import 'package:contracting_management_dashbord/model/staff/staff_key.dart';
import 'package:contracting_management_dashbord/model/staff/staff_model.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:contracting_management_dashbord/widget/futuer_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class StaffScreen extends GetView<StaffController> {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDialog(),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        label: const Text(
          "إضافة موظف",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      body: FutuerPageWidget(
        controller: controller.pageDataStaff,
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
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: Colors.teal,
                    size: 24,
                  ),
                ),
                title: Text(
                  data.name ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Cairo',
                    color: Color(0xFF1E293B),
                  ),
                ),
                subtitle: Text(
                  data.job ?? "بدون وصف",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
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
          return controller.getAllStaff();
        },
      ),
    );
  }

  void _showDialog({StaffModel? model}) {
    // Reset form state before showing dialog
    if (controller.keyAdd.currentState != null) {
      controller.keyAdd.currentState!.reset();
    }

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
            key: controller.keyAdd,
            initialValue: {
              StaffGetKey.name: model?.name,
              StaffGetKey.job: model?.job,
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
                      model == null ? "إضافة موظف جديد" : "تعديل الموظف",
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
                  name: StaffGetKey.name,
                  labelText: 'الاسم',
                ),
                const SizedBox(height: 16),
                AppTextFiled(
                  validator: [
                    FormBuilderValidators.required(
                      errorText: 'الرجاء إدخال الوظيفة',
                    ),
                  ],
                  name: StaffGetKey.job,
                  labelText: 'الوظيفة',
                ),
                const SizedBox(height: 30),
                CustomButton(
                  width: double.infinity,
                  text: 'حفظ التغييرات',
                  onPressed: () async {
                    if (controller.keyAdd.currentState!.saveAndValidate()) {
                      if (model == null) {
                        await controller.addStaff(
                          controller.keyAdd.currentState!.value,
                        );
                      } else {
                        await controller.updateStaff(
                          model.id.toString(),
                          controller.keyAdd.currentState!.value,
                        );
                      }
                      // Note: StaffController handles Get.back() internally in some cases,
                      // but it's safe to call it if the controller hasn't yet, or if we want to ensure close.
                      // However, if controller calls it, this might popup another screen.
                      // Checking previous code: I removed Get.back() from previous implementation because I suspected double back.
                      // But effectively here using Get.dialog needs explicit close if the controller doesn't do it.
                      // Safest approach: check if dialog is open.
                      // But typically, simply not calling it if controller does is correct.
                      // Let's assume controller handles it as per previous conversation context.
                      // Actually, in TypeProjectScreen I added Get.back().
                      // Let's verify StaffController behavior from memory/context?
                      // I don't have StaffController source in front of me right now (only parts).
                      // Use similar logic to TypeProjectScreen which *did* call Get.back().
                      // If it closes twice, it's a minor UX bug (closes parent).
                      // Better to ensure it closes.
                      // Wait, I can see my own thought in previous turn: "My StaffController DOES call Get.back(). So I will remove Get.back() here".
                      // So I will NOT add Get.back() here.
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
