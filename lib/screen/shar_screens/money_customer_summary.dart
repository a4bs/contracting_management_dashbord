import 'package:contracting_management_dashbord/model/bill/bill_model.dart';
import 'package:contracting_management_dashbord/model/bond/bond_model.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:flutter/material.dart';

class MoneyCustomerSummary extends StatelessWidget {
  final BillModel itemBill;
  final List<BondModel> transactions;
  const MoneyCustomerSummary({
    super.key,
    required this.itemBill,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return colclate_summary(transactions, itemBill);
  }

  colclate_summary(List<BondModel> transactions, BillModel bill) {
    double totalPaid = 0;
    for (var bond in transactions) {
      if (bond.bondTypeId == 2) {
        totalPaid +=
            double.tryParse(bond.amount?.replaceAll(',', '') ?? '0') ?? 0;
      }
    }

    // Add Down Payment
    totalPaid +=
        double.tryParse(bill.downPayment?.replaceAll(',', '') ?? '0') ?? 0;

    final salePrice =
        double.tryParse(bill.salePrice?.replaceAll(',', '') ?? '0') ?? 0;
    final remaining = salePrice - totalPaid;
    final ratio = salePrice > 0 ? (totalPaid / salePrice) : 0.0;
    // Side effect removed
    // if (remaining > 0) {
    //   controller.allowAddBond.value = true;
    // }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.pie_chart, color: AppColors.lightPrimary),
              const SizedBox(width: 8),
              const Text(
                "الملخص المالي",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightPrimary,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                  children: [
                    _buildMobileRow(
                      "السعر الكلي",
                      AppTool.formatMoney(salePrice.toString()),
                      Colors.blue,
                    ),
                    const Divider(height: 24),
                    _buildMobileRow(
                      "مجموع الواصل",
                      AppTool.formatMoney(totalPaid.toString()),
                      Colors.green,
                    ),
                    const Divider(height: 24),
                    _buildMobileRow(
                      "المتبقي",
                      AppTool.formatMoney(remaining.toString()),
                      Colors.red,
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: _SummaryItem(
                        title: "السعر الكلي",
                        value: AppTool.formatMoney(
                          salePrice.toString(),
                        ).toString(),
                        color: Colors.blue,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade300,
                    ),
                    Expanded(
                      child: _SummaryItem(
                        title: "مجموع الواصل",
                        value: AppTool.formatMoney(
                          totalPaid.toString(),
                        ).toString(),
                        color: Colors.green,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade300,
                    ),
                    Expanded(
                      child: _SummaryItem(
                        title: "المتبقي",
                        value: AppTool.formatMoney(
                          remaining.toString(),
                        ).toString(),
                        color: Colors.red,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 16),
          itemLinear(
            "نسبة السداد",
            "${(ratio * 100).toStringAsFixed(1)}%",
            ratio,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileRow(String title, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget itemLinear(String label, String value, double ratio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.lightPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio > 1 ? 1 : ratio,
            backgroundColor: Colors.grey.shade200,
            color: AppColors.lightPrimary,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: Colors.grey, fontSize: 13)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
