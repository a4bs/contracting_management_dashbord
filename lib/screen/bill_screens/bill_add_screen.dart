import 'package:contracting_management_dashbord/controller/bill_controller/bill_add_controlle.dart';
import 'package:contracting_management_dashbord/model/customer/customer_model.dart';
import 'package:contracting_management_dashbord/screen/bill_screens/bill_add_screen/step_one_screen.dart';
import 'package:contracting_management_dashbord/screen/bill_screens/bill_add_screen/step_three_screen.dart';
import 'package:contracting_management_dashbord/screen/bill_screens/bill_add_screen/step_tow_screen.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillAddScreen extends GetView<BillAddController> {
  BillAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // If we are on phone (screen width < 600), we wrap in Scaffold with AppBar
    return Scaffold(
      appBar: AppBar(title: Text('إضافة فاتورة')),
      body: Obx(
        () => Stepper(
          type: StepperType.horizontal,
          currentStep: controller.currentStep.value,
          onStepTapped: (index) {
            // next_and_save(index);
          },
          onStepContinue: () {
            next_and_save(controller.currentStep.value);
          },
          onStepCancel: () {
            controller.currentStep.value--;
          },
          controlsBuilder: (context, controlsDetails) {
            final bool isFirstStep = controlsDetails.currentStep == 0;
            final bool isLastStep = controlsDetails.currentStep == 2;

            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button
                  Expanded(
                    child: Container(
                      height: 50,
                      child: CustomButton(
                        backgroundColor: isFirstStep
                            ? Colors.grey.shade300
                            : Colors.grey.shade600,
                        onPressed: isFirstStep
                            ? () async {}
                            : () async {
                                controller.currentStep.value--;
                              },
                        icon: Icons.arrow_back_ios_rounded,
                        text: 'السابق',
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Next/Save Button
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CustomButton(
                        onPressed: () async {
                          await next_and_save(controlsDetails.currentStep);
                        },
                        icon: isLastStep
                            ? Icons.check_circle_outline
                            : Icons.arrow_forward_ios_rounded,
                        text: isLastStep ? 'حفظ' : 'التالي',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          steps: [
            Step(title: Text('العميل'), content: StepOneScreen()),
            Step(title: Text('الوحدة'), content: StepTowScreen()),
            Step(title: Text('الإيصالات'), content: StepThreeScreen()),
          ],
        ),
      ),
    );
  }

  next_and_save(int index) async {
    if (index == 0) {
      if (controller.formKeyToAddCustomer.currentState != null &&
              controller.formKeyToAddCustomer.currentState!.validate() ||
          controller.customerModel.value.id != null) {
        controller.currentStep.value++;
        if (controller.formKeyToAddCustomer.currentState != null) {
          controller.customerModel.value = CustomerModel.fromJson(
            controller.formKeyToAddCustomer.currentState!.fields.map((
              key,
              value,
            ) {
              return MapEntry(key, value.value);
            }),
          );
        }
      } else {
        CustomToast.showWarning(
          title: 'تنبيه',
          description: 'الرجاء ملء جميع الحقول',
        );
      }
    }
    if (index == 1) {
      if (controller.formKeyToAddBill.currentState != null &&
          controller.formKeyToAddBill.currentState!.validate()) {
        controller.currentStep.value++;
        // controller.listBound.clear();
      } else {
        CustomToast.showWarning(
          title: 'تنبيه',
          description: 'الرجاء ملء جميع الحقول',
        );
      }
    }
    if (index == 2) {
      if (controller.listBound.isEmpty) {
        CustomToast.showError(
          title: 'تنبيه',
          description: 'الرجاء إضافة إيصالات',
        );
      }
      if (controller.installmentType.value == 0) {
        bool isNotselec = controller.listBound.any(
          (element) => element.percentageId == null,
        );
        if (isNotselec) {
          CustomToast.showError(
            title: 'تنبيه',
            description: 'الرجاء إضافة نسبة',
          );
        } else {
          await controller.saveBill();
        }
      } else {
        await controller.saveBill();
      }
    }
  }
}
