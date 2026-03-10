import 'package:contracting_management_dashbord/model/bond/bond_model.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/widget/app_date_field.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/select_drop_don.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:contracting_management_dashbord/controller/bill_controller/bill_add_controlle.dart';

class StepThreeScreen extends GetView<BillAddController> {
  const StepThreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColors.darkPrimary,
            ),
            child: Row(
              children: [
                Text(
                  ' السعر المتبقي : ${AppTool.formatMoney(controller.getTotalPrice().toString())}',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.darkOnError,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          FormBuilder(
            key: controller.formKeyGenrate,
            child: AppTextFiled(
              validator: [
                FormBuilderValidators.required(
                  errorText: 'يجب ادخال عدد الدفعات',
                ),
              ],
              name: 'count_generate',
              labelText: 'عدد الدفعات',
              suffixWidget: IconButton(
                onPressed: () {
                  if (controller.formKeyGenrate.currentState!.validate()) {
                    controller.generateBound();
                  }
                },
                icon: Icon(Icons.replay_outlined),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Obx(
              () => Column(
                children: [
                  ...controller.listBound.map((e) => buildBoundData(e)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildBoundData(BondModel data) {
    return Container(
      key: ValueKey('container_${data.id}'),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.darkPrimary.withOpacity(0.3),
          width: 1.5,
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: AppTextFiled(
                  key: ValueKey("t_${data.id}"),
                  name:
                      'title_${data.id ?? DateTime.now().millisecondsSinceEpoch}',
                  labelText: 'العنوان',
                  initialValue: data.title,
                  icon: Icons.title,
                  onChanged: (value) {
                    controller.listBound
                            .firstWhere((element) => element.id == data.id)
                            .title =
                        value;
                    controller.listBound.refresh();
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  bool isEqual = data.amount == data.downPayment;
                  if (isEqual == false) {
                    controller.listBound
                            .firstWhere((element) => element.id == data.id)
                            .amount =
                        data.downPayment;
                    controller.listBound.refresh();
                  } else {
                    controller.listBound
                            .firstWhere((element) => element.id == data.id)
                            .amount =
                        '0';
                    controller.listBound.refresh();
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: data.amount == data.downPayment,
                      onChanged: (value) {
                        bool isEqual = data.amount == data.downPayment;
                        if (isEqual == false) {
                          controller.listBound
                              .firstWhere((element) => element.id == data.id)
                              .amount = data
                              .downPayment;
                          controller.listBound.refresh();
                        } else {
                          controller.listBound
                                  .firstWhere(
                                    (element) => element.id == data.id,
                                  )
                                  .amount =
                              '0';
                          controller.listBound.refresh();
                        }
                      },
                    ),
                    Text(
                      "واصل",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          AppTextFiled(
            key: ValueKey("dp_${data.id}"),
            name:
                'down_payment_${data.id ?? DateTime.now().millisecondsSinceEpoch}',
            labelText: 'المبلغ',
            initialValue: AppTool.formatMoney(data.downPayment.toString()),
            icon: Icons.attach_money,
            isMony: true,
            isNumber: true,
            onChanged: (value) {
              controller.listBound
                      .firstWhere((element) => element.id == data.id)
                      .downPayment =
                  value;
              controller.listBound.refresh();
            },
          ),
          SizedBox(height: 12),
          Obx(
            () => controller.installmentType.value == 1
                ? AppDateField(
                    labelText: 'تاريخ استحقاق الدفعة',

                    name: 'installmentDateAt',
                    initialValue: data.installmentDateAt != null
                        ? DateTime.tryParse(data.installmentDateAt!)
                        : null,
                    onChanged: (value) {
                      controller.listBound
                          .firstWhere((element) => element.id == data.id)
                          .installmentDateAt = value
                          ?.toString();
                      controller.listBound.refresh();
                    },
                  )
                : SelectDropDon(
                    name: 'name',
                    label: 'اختر النسبه التي يستحق بها الدفع',
                    onTap: () => controller.getPercentage(),
                    onSelected: (value) {
                      controller.listBound
                              .firstWhere((element) => element.id == data.id)
                              .percentageId =
                          value;
                      controller.listBound.refresh();
                    },
                    cardInfo: (value) =>
                        DropdownMenuEntry(value: value.id, label: value.name),
                  ),
          ),
          SizedBox(height: 12),
          AppTextFiled(
            key: ValueKey("n_${data.id}"),
            name: 'note_${data.id ?? DateTime.now().millisecondsSinceEpoch}',
            labelText: 'ملاحظات',
            initialValue: data.note,
            icon: Icons.note_alt_outlined,
            maxLines: 3,
            onChanged: (value) {
              controller.listBound
                      .firstWhere((element) => element.id == data.id)
                      .note =
                  value;
              controller.listBound.refresh();
            },
          ),
        ],
      ),
    );
  }
}
