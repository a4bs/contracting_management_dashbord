import 'package:contracting_management_dashbord/constant/enum/rol_enum.dart';
import 'package:contracting_management_dashbord/constant/enum/transaction_type_enum.dart';
import 'package:contracting_management_dashbord/controller/bill_controller/bill_controller.dart';
import 'package:contracting_management_dashbord/controller/bond_controller/bond_controller.dart';
import 'package:contracting_management_dashbord/controller/percentage_controller/percentage_controller.dart';
import 'package:contracting_management_dashbord/controller/unit_controller/unit_controller.dart';
import 'package:contracting_management_dashbord/model/bill/bill_model.dart';
import 'package:contracting_management_dashbord/model/bond/bond_key.dart';
import 'package:contracting_management_dashbord/model/bond/bond_model.dart';
import 'package:contracting_management_dashbord/model/bond/filter_bond.dart';
import 'package:contracting_management_dashbord/model/customer/customer_model.dart';
import 'package:contracting_management_dashbord/screen/shar_screens/money_customer_summary.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/tool/user_tool.dart';
import 'package:contracting_management_dashbord/widget/app_bar_widget.dart';
import 'package:contracting_management_dashbord/widget/app_date_field.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:contracting_management_dashbord/widget/dilog_check_user.dart';
import 'package:contracting_management_dashbord/widget/futuer_pagnation_page_widget.dart';
import 'package:contracting_management_dashbord/widget/layout_tablet_phone.dart';
import 'package:contracting_management_dashbord/widget/select_drop_don.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BillDetailScreen extends GetView<BillController> {
  final BillModel itemBill;
  final bool withoutappbar;
  BillDetailScreen({
    super.key,
    required this.itemBill,
    this.withoutappbar = false,
  });

  final UnitController unitController = Get.find();
  final BondController boundController = Get.find();
  final PercentageController percentageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !withoutappbar ? CustomAppBar(title: "تفاصيل الفاتورة") : null,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView(
          children: [
            Obx(
              () =>
                  controller.isAddBondAllowed(
                        boundController.pageDataPagnationController.items,
                        itemBill,
                      ) &&
                      UserTool.checkPer(PermeationEnum.addBondCredit)
                  ? Container(
                      padding: EdgeInsets.all(16),
                      child: CustomButton(
                        isShow: UserTool.checkPer(PermeationEnum.addBondCredit),
                        text: "إضافة سند",
                        onPressed: () async {
                          build_dilog_add_bond_payment();
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            LayoutTabletPhone(
              children: [
                build_card_customer(itemBill.customer!),
                build_card_unit(itemBill.unit!.id),
              ],
            ),
            build_card_bill(),
            const SizedBox(height: 16),
            const Divider(),

            Obx(
              () => MoneyCustomerSummary(
                transactions:
                    // ignore: invalid_use_of_protected_member
                    boundController.pageDataPagnationController.items.value,
                itemBill: itemBill,
              ),
            ),

            const Divider(),
            build_card_bound_box(),
          ],
        ),
      ),
    );
  }

  build_card_customer(CustomerModel customer) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Theme(
        data: Get.theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: Get.theme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                "تفاصيل العميل",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.account_circle_outlined,
                    "الاسم",
                    customer.name.toString(),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.phone,
                    "الهاتف 1",
                    customer.phone1.toString(),
                  ),
                  if (customer.phone2 != null &&
                      customer.phone2.toString().isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.phone_iphone,
                      "الهاتف 2",
                      customer.phone2.toString(),
                    ),
                  ],
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    "العنوان",
                    customer.address.toString(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  build_card_unit(id) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Theme(
        data: Get.theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.home_work,
                  color: Get.theme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                "تفاصيل الوحدة",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          children: [
            FutureBuilder(
              future: unitController.getUnitById(id.toString()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final unit = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          Icons.label_outline,
                          "اسم الوحدة",
                          unit.name.toString(),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          Icons.attach_money,
                          "السعر",
                          unit.cost.toString(),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          Icons.percent,
                          "النسبة",
                          unit.percentage?.name.toString() ?? "N/A",
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          Icons.apartment,
                          "المشروع",
                          unit.project?.name.toString() ?? "N/A",
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
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
        Container(
          margin: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 20, color: Colors.grey.shade400),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //-------- build card bill
  build_card_bill() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Theme(
        data: Get.theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.receipt,
                  color: Get.theme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                "تفاصيل الفاتورة",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.note_alt_outlined,
                    "ملاحظات",
                    (itemBill.note ?? 'لا توجد ملاحظة').toString(),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.monetization_on_outlined,
                    "سعر الشراء",
                    (AppTool.formatMoney(
                      itemBill.salePrice.toString(),
                    )).toString(),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.payments_outlined,
                    "الدفعه الاولى",
                    (AppTool.formatMoney(
                      itemBill.downPayment.toString(),
                    )).toString(),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.schedule_outlined,
                    "نظام الدفع",
                    ((itemBill.isScheduledInstallment == true)
                            ? 'بالتقسيط'
                            : 'بواسطة نسبة الانجاز')
                        .toString(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------- build card bound box
  build_card_bound_box() {
    return SizedBox(
      height: 700,
      child: FutuerPagnationPageWidget(
        handelData: (page, per) => boundController.filterBonds(
          FilterBond(customerId: itemBill.customerId),
        ),
        controller: boundController.pageDataPagnationController,
        cardInfo: (item, index) {
          return build_card_bound_box_item(item);
        },
      ),
    );
  }

  build_card_bound_box_item(BondModel item) {
    double target = double.tryParse(item.downPayment.toString()) ?? 0;
    double paid = double.tryParse(item.amount.toString()) ?? 0;
    double remaining = target - paid;
    String status = get_status(target, paid);

    Color statusColor;
    if (paid == 0) {
      statusColor = Colors.red;
    } else if (target == paid) {
      statusColor = Colors.green;
    } else {
      statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Theme(
        data: Get.theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: EdgeInsets.zero,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Title and Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.title ?? "بدون عنوان",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1F2937),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Row 2: Metrics Grid
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildCompactMetric(
                      "المطلوب",
                      AppTool.formatMoney(item.downPayment.toString()),
                      Colors.grey.shade700,
                    ),
                  ),
                  Expanded(
                    child: _buildCompactMetric(
                      "الواصل",
                      AppTool.formatMoney(item.amount.toString()),
                      Colors.green.shade700,
                    ),
                  ),
                  if (remaining > 0)
                    Expanded(
                      child: _buildCompactMetric(
                        "المتبقي",
                        AppTool.formatMoney(remaining.toString()),
                        Colors.red.shade700,
                      ),
                    ),
                ],
              ),
            ],
          ),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Details Section
                        _buildInfoRow(
                          Icons.numbers,
                          "رقم السند",
                          item.id.toString(),
                        ),
                        const SizedBox(height: 12),
                        if (itemBill.isScheduledInstallment == true)
                          _buildInfoRow(
                            Icons.event,
                            "تاريخ الاستحقاق",
                            item.installmentDateAt != null
                                ? AppTool.formatDate(
                                    DateTime.parse(
                                      item.installmentDateAt.toString(),
                                    ),
                                  )
                                : "   لا يوجد تاريخ استحقاق",
                          ),
                        if (itemBill.isScheduledInstallment == false)
                          _buildInfoRow(
                            Icons.percent,
                            "النسبة المنجزة",
                            "${item.percentageId ?? 0}%",
                          ),
                        if (item.note != null &&
                            item.note!.isNotEmpty &&
                            item.note != "null") ...[
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.note_alt_outlined,
                            "ملاحظات",
                            item.note!,
                          ),
                        ],

                        // Action Buttons
                        const SizedBox(height: 20),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              if (UserTool.checkPer(PermeationEnum.editBond))
                                _buildActionButton(
                                  label: "تعديل على المبلغ المطلوب",
                                  icon: Icons.check_circle_outline,
                                  color: Colors.green,
                                  onTap: () =>
                                      build_dilog_edit_on_payment(item),
                                ),
                              const SizedBox(width: 10),
                              if (UserTool.checkPer(PermeationEnum.editBond))
                                _buildActionButton(
                                  label: "تسديد",
                                  icon: Icons.check_circle_outline,
                                  color: Colors.green,
                                  onTap: () => build_dilog_add_payment(item),
                                ),
                              const SizedBox(width: 8),
                              if (UserTool.checkPer(PermeationEnum.editBond))
                                _buildActionButton(
                                  label: "تسديد جزئي",
                                  icon: Icons.payments_outlined,
                                  color: Colors.blue,
                                  onTap: () => build_dilog_edit_payment(item),
                                ),
                              const SizedBox(width: 8),
                              if (UserTool.checkPer(PermeationEnum.deleteBond))
                                _buildActionButton(
                                  label: "الغاء",
                                  icon: Icons.cancel_outlined,
                                  color: Colors.orange,
                                  onTap: () => build_dilog_cancel_payment(item),
                                ),
                              const SizedBox(width: 8),
                              if (UserTool.checkPer(PermeationEnum.deleteBond))
                                _buildActionButton(
                                  label: "حذف",
                                  icon: Icons.delete_outline,
                                  color: Colors.red,
                                  onTap: () => build_dilog_delete_payment(item),
                                ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildCompactMetric(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get_status(double downPayment, double amount) {
    if (amount == 0) {
      return 'غير واصل';
    } else if (downPayment == amount) {
      return 'واصل';
    } else if (downPayment > amount) {
      return 'دفع جزئي';
    }
    return 'قيد المعالجة';
  }

  build_dilog_add_payment(BondModel item) {
    showConfirmationDialog(
      title: "تأكيد",
      message: "هل انت متاكد من تسديد هذا السند؟",
      onConfirm: () async {
        await controller.payBill(item);
        await boundController.pageDataPagnationController.refreshItems(
          (page, limit) => boundController.filterBonds(
            FilterBond(customerId: item.customerId),
          ),
        );
      },
    );
  }

  build_dilog_edit_payment(BondModel item) {
    Get.dialog(
      Dialog(
        child: Container(
          width: Get.width * 0.5,
          padding: EdgeInsets.all(16),
          child: FormBuilder(
            key: controller.formToUpdateBond,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "تعديل السند",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                AppTextFiled(
                  isMony: true,
                  validator: [
                    FormBuilderValidators.required(errorText: "المبلغ مطلوب"),
                  ],
                  name: BondUpdateKey.amount,
                  labelText: "المبلغ",
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: "الغاء",
                        onPressed: () async {
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: "تأكيد",
                        onPressed: () async {
                          if (controller.formToUpdateBond.currentState!
                              .saveAndValidate()) {
                            await controller.updateBondAmount(item);
                            await boundController.pageDataPagnationController
                                .refreshItems(
                                  (page, limit) => boundController.filterBonds(
                                    FilterBond(customerId: item.customerId),
                                  ),
                                );
                            Get.back();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  build_dilog_edit_on_payment(BondModel item) {
    Get.dialog(
      Dialog(
        child: Container(
          width: Get.width * 0.5,
          padding: EdgeInsets.all(16),
          child: FormBuilder(
            initialValue: {
              BondUpdateKey.downPayment: AppTool.formatMoney(
                item.downPayment.toString(),
              ),
            },
            key: controller.formToONDUpdateBond,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  " تعديل على المبلغ المطلوب   ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                AppTextFiled(
                  isMony: true,
                  validator: [
                    FormBuilderValidators.required(errorText: "المبلغ مطلوب"),
                  ],
                  name: BondUpdateKey.downPayment,
                  labelText: "المبلغ",
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: "الغاء",
                        onPressed: () async {
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: "تأكيد",
                        onPressed: () async {
                          if (controller.formToONDUpdateBond.currentState!
                              .saveAndValidate()) {
                            await controller.updateONDonBondAmount(item);
                            await boundController.pageDataPagnationController
                                .refreshItems(
                                  (page, limit) => boundController.filterBonds(
                                    FilterBond(customerId: item.customerId),
                                  ),
                                );
                            Get.back();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  build_dilog_delete_payment(BondModel item) {
    showConfirmationDialog(
      title: "تأكيد",
      message: "هل انت متاكد من حذف هذا السند؟",
      onConfirm: () async {
        await controller.deletebound(item.id!, itemBill);
        await boundController.pageDataPagnationController.refreshItems(
          (page, limit) => boundController.filterBonds(
            FilterBond(customerId: item.customerId),
          ),
        );
      },
    );
  }

  build_dilog_cancel_payment(BondModel item) {
    showConfirmationDialog(
      title: "تأكيد",
      message: "هل انت متاكد من الغاء هذا السند؟",
      onConfirm: () async {
        await controller.cancelBill(item);
        await boundController.pageDataPagnationController.refreshItems(
          (page, limit) => boundController.filterBonds(
            FilterBond(customerId: item.customerId),
          ),
        );
      },
    );
  }

  //---- add bond
  build_dilog_add_bond_payment() {
    Get.dialog(
      Dialog(
        child: Container(
          width: Get.width * 0.5,
          padding: EdgeInsets.all(16),
          child: FormBuilder(
            key: controller.formToAddBond,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "إضافة سند",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                AppTextFiled(
                  validator: [
                    FormBuilderValidators.required(errorText: " العنوان مطلوب"),
                  ],
                  name: BondAddKey.title,
                  labelText: " العنوان  ",
                ),
                const SizedBox(height: 12),
                AppTextFiled(
                  isMony: true,
                  validator: [
                    FormBuilderValidators.required(errorText: "المبلغ   مطلوب"),
                  ],
                  name: BondAddKey.downPayment,
                  labelText: "المبلغ  المطلوب ",
                ),
                const SizedBox(height: 12),
                AppTextFiled(
                  isMony: true,
                  validator: [
                    FormBuilderValidators.required(errorText: "المبلغ مطلوب"),
                  ],
                  name: BondAddKey.amount,
                  labelText: " المبلغ الواصل",
                ),
                const SizedBox(height: 12),
                AppTextFiled(
                  validator: [
                    FormBuilderValidators.required(errorText: "المبلغ مطلوب"),
                  ],
                  name: BondUpdateKey.note,
                  labelText: "ملاحظات",
                ),
                const SizedBox(height: 12),
                Builder(
                  builder: (context) => itemBill.isScheduledInstallment == true
                      ? AppDateField(
                          format: DateFormat('yyyy-MM-dd'),
                          labelText: 'تاريخ استحقاق الدفعة',
                          validator: [
                            FormBuilderValidators.required(
                              errorText: "تاريخ الاستحقاق مطلوب",
                            ),
                          ],
                          name: BondAddKey.installmentDateAt,
                        )
                      : SelectDropDon(
                          name: BondAddKey.percentageId,
                          label: 'اختر النسبه التي يستحق بها الدفع',
                          onTap: () => percentageController.getAllPercentages(),

                          cardInfo: (value) => DropdownMenuEntry(
                            value: value.id,
                            label: value.name,
                          ),
                        ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: "الغاء",
                        onPressed: () async {
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: "تأكيد",
                        onPressed: () async {
                          if (controller.formToAddBond.currentState!
                              .saveAndValidate()) {
                            Map<String, dynamic> data = {
                              BondAddKey.title: controller
                                  .formToAddBond
                                  .currentState!
                                  .fields[BondAddKey.title]!
                                  .value,
                              BondAddKey.downPayment: controller
                                  .formToAddBond
                                  .currentState!
                                  .fields[BondAddKey.downPayment]!
                                  .value
                                  .toString()
                                  .replaceAll(',', ''),
                              BondAddKey.amount:
                                  (controller
                                              .formToAddBond
                                              .currentState!
                                              .fields[BondAddKey.amount]!
                                              .value ??
                                          0)
                                      .toString()
                                      .replaceAll(',', ''),
                              BondAddKey.note: controller
                                  .formToAddBond
                                  .currentState!
                                  .fields[BondAddKey.note]!
                                  .value,
                              BondAddKey.customerId: itemBill.customerId,
                              BondAddKey.boxId: itemBill.boxId,
                              BondAddKey.projectId: itemBill.projectId,
                              BondAddKey.isScheduledInstallment:
                                  itemBill.isScheduledInstallment! ? 1 : 0,
                              BondAddKey.bondTypeId:
                                  TransactionTypeEnum.credit.id,
                            };
                            if (itemBill.isScheduledInstallment == true) {
                              data[BondAddKey.installmentDateAt] =
                                  DateFormat('yyyy-MM-dd').format(
                                    controller
                                        .formToAddBond
                                        .currentState!
                                        .fields[BondAddKey.installmentDateAt]!
                                        .value,
                                  );
                            }
                            if (itemBill.isScheduledInstallment == false) {
                              data[BondAddKey.percentageId] = controller
                                  .formToAddBond
                                  .currentState!
                                  .fields[BondAddKey.percentageId]!
                                  .value;
                            }

                            await controller.addBond(
                              data,
                              itemBill.customerId,
                              itemBill,
                            );

                            // Get.back();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
