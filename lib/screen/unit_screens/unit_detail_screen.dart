import 'package:contracting_management_dashbord/controller/bill_controller/bill_controller.dart';
import 'package:contracting_management_dashbord/controller/bond_controller/bond_controller.dart';
import 'package:contracting_management_dashbord/model/bill/bill_filter.dart';
import 'package:contracting_management_dashbord/model/bill/bill_model.dart';
import 'package:contracting_management_dashbord/model/bond/bond_model.dart';
import 'package:contracting_management_dashbord/model/bond/filter_bond.dart';
import 'package:contracting_management_dashbord/model/customer/customer_model.dart';
import 'package:contracting_management_dashbord/screen/shar_screens/money_customer_summary.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/widget/app_bar_widget.dart';
import 'package:contracting_management_dashbord/widget/layout_tablet_phone.dart';
import 'package:flutter/material.dart';
import 'package:contracting_management_dashbord/model/unit/unit_model.dart';
import 'package:get/get.dart';

class UnitDetailScreen extends StatelessWidget {
  final UnitModel item;
  UnitDetailScreen({super.key, required this.item});

  final BillController billController = Get.find();
  final BondController bondController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "تفاصيل الوحدة"),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            build_header(item),
            if (item.customers!.isNotEmpty) ...[
              for (var customer in (item.customers ?? []))
                build_card_customer(customer),
            ],
            build_card_bills(),
          ],
        ),
      ),
    );
  }

  Widget build_header(UnitModel item) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.home_filled, color: Colors.blue, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? "بدون اسم",
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.folder_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "المشروع: ${item.project?.name ?? "غير محدد"}",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "السعر: ${AppTool.formatMoney(item.cost ?? "0")}",
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
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
              Expanded(
                child: Text(
                  "تفاصيل العميل",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  overflow: TextOverflow.ellipsis,
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

  build_card_bills() {
    return FutureBuilder(
      future: billController.filterBills(BillFilter(unitId: item.id)),
      builder: (context, snapshotBill) {
        if (snapshotBill.connectionState == ConnectionState.done &&
            snapshotBill.hasData &&
            snapshotBill.data!.isNotEmpty) {
          // Typically one bill per unit, but technically can be multiple.
          // Using column to show all if multiple.
          return Column(
            children: snapshotBill.data!.map((bill) {
              return Column(
                children: [
                  LayoutTabletPhone(children: [build_card_bill(bill)]),
                  const SizedBox(height: 16),
                  const Divider(),
                  FutureBuilder(
                    future: bondController.filterBonds(
                      FilterBond(customerId: bill.customerId, perPage: 1000),
                    ),
                    builder: (context, snapshotBond) {
                      if (snapshotBond.connectionState ==
                          ConnectionState.done) {
                        if (snapshotBond.data != null) {}

                        // Filter bonds for this specific bill client-side using billId OR boxId
                        var billBonds =
                            snapshotBond.data?.where((bond) {
                              bool matchBill =
                                  bond.billId != null && bond.billId == bill.id;
                              bool matchBox =
                                  bill.boxId != null &&
                                  bond.boxId == bill.boxId;
                              return matchBill || matchBox;
                            }).toList() ??
                            [];

                        return Column(
                          children: [
                            MoneyCustomerSummary(
                              transactions: billBonds,
                              itemBill: bill,
                            ),
                            const Divider(),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: billBonds.length,
                              itemBuilder: (context, index) {
                                return build_card_bound_box_item(
                                  billBonds[index],
                                  bill,
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              );
            }).toList(),
          );
        } else if (snapshotBill.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(16),
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
              child: Text(
                "لا توجد فواتير لهذه الوحدة",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  build_card_bill(BillModel bill) {
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
              Expanded(
                child: Text(
                  "تفاصيل الفاتورة",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  overflow: TextOverflow.ellipsis,
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
                    bill.note ?? 'لا توجد ملاحظة',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.monetization_on_outlined,
                    "سعر الشراء",
                    AppTool.formatMoney(bill.salePrice.toString()),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.payments_outlined,
                    "الدفعه الاولى",
                    AppTool.formatMoney(bill.downPayment.toString()),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.schedule_outlined,
                    "نظام الدفع",
                    (bill.isScheduledInstallment == true)
                        ? 'بالتقسيط'
                        : 'بواسطة نسبة الانجاز',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.confirmation_number_outlined,
                    "القطعة",
                    bill.plot ?? "N/A",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  build_card_bound_box_item(BondModel item, BillModel bill) {
    double target = double.tryParse(item.downPayment.toString()) ?? 0;
    double paid = double.tryParse(item.amount.toString()) ?? 0;
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
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Theme(
        data: Get.theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          backgroundColor: Colors.white,
          title: LayoutTabletPhone(
            children: [
              _buildTableCell('العنوان', item.title.toString()),
              _buildTableCell(
                'المطلوب',
                AppTool.formatMoney(item.downPayment.toString()),
              ),
              _buildTableCell(
                'الواصل',
                AppTool.formatMoney(item.amount.toString()),
                valueColor: Colors.green,
              ),
              if (paid != 0 && paid != target)
                _buildTableCell(
                  ' المتبقي',
                  AppTool.formatMoney((target - paid).toString()),
                  valueColor: Colors.red,
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الحالة',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      " ${item.title} ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    "المبلغ المطلوب",
                    AppTool.formatMoney(item.downPayment.toString()),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    "المبلغ المدفوع",
                    AppTool.formatMoney(item.amount.toString()),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    " الحالة  ",
                    status.toString(),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    "المبلغ المتبقي",
                    AppTool.formatMoney((target - paid).toString()),
                  ),
                  const SizedBox(height: 8),
                  if (bill.isScheduledInstallment == true)
                    _buildInfoRow(
                      Icons.calendar_today_outlined,
                      "تاريخ الاستحقاق",
                      AppTool.formatDate(
                        DateTime.tryParse(item.installmentDateAt.toString()) ??
                            DateTime.now(),
                      ),
                    ),
                  if (bill.isScheduledInstallment == false)
                    _buildInfoRow(
                      Icons.percent,
                      "النسبه المنجزه ",
                      item.percentageId.toString(),
                    ),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.numbers, "رقم السند", item.id.toString()),
                  if (item.note != null &&
                      item.note.toString().isNotEmpty &&
                      item.note.toString() != "null") ...[
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.note_alt_outlined,
                      "ملاحظات",
                      item.note.toString(),
                    ),
                  ],
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

  Widget _buildTableCell(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: valueColor ?? Colors.black87,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
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
}
