import 'package:contracting_management_dashbord/constant/enum/screen_size_enum.dart';
import 'package:contracting_management_dashbord/controller/app_controller/page_data_pagnation_controller.dart';
import 'package:contracting_management_dashbord/controller/bond_controller/bond_controller.dart';
import 'package:contracting_management_dashbord/model/bond/bond_model.dart';
import 'package:contracting_management_dashbord/model/bond/filter_bond.dart';
import 'package:contracting_management_dashbord/screen/shar_screens/display_groub_file.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/widget/future_pagination_table_widget.dart';
import 'package:contracting_management_dashbord/widget/futuer_pagnation_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShearScreenToCredit extends GetView<BondController> {
  final FilterBond filterBond;
  final Function(BondModel)? onTap;
  final PageDataPagnationController<BondModel> pageDataPagnationController;
  ShearScreenToCredit({
    super.key,
    required this.filterBond,
    required this.pageDataPagnationController,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenSize = ScreenSize.fromWidth(constraints.maxWidth);
          return screenSize == ScreenSize.mobile ||
                  screenSize == ScreenSize.tablet
              ? _layout_phone()
              : _layout_descktop();
        },
      ),
    );
  }

  Widget _layout_phone() {
    return FutuerPagnationPageWidget(
      handelData: (page, limit) =>
          controller.filterBonds(filterBond.copyWith(page: page, limit: limit)),
      controller: pageDataPagnationController,
      cardInfo: (item, index) => _card_phone(item, index),
    );
  }

  Widget _layout_descktop() {
    return FuturePaginationTableWidget(
      handelData: (page, limit) =>
          controller.filterBonds(filterBond.copyWith(page: page, limit: limit)),
      controller: pageDataPagnationController,
      columns: [
        DataColumn(label: Text("#")),
        DataColumn(label: Text("العنوان")),
        DataColumn(label: Text("الزبون")),
        DataColumn(label: Text("الصندوق")),
        DataColumn(label: Text("المبلغ المطلوب")),
        DataColumn(label: Text("المبلغ الواصل")),
        DataColumn(label: Text("المبلغ المتبقي")),
        DataColumn(label: Text("التاريخ")),
        DataColumn(label: Text("ملاحظة")),
        DataColumn(label: Text("المرفقات")),
        DataColumn(label: Text("الحالة")),
        if (onTap != null) DataColumn(label: Text("الإجراء")),
      ],
      buildRow: (data, index) {
        return DataRow(
          color: data.customer != null
              ? WidgetStateProperty.all(Colors.grey.shade300)
              : WidgetStateProperty.all(Colors.white),
          cells: [
            DataCell(Text('${index + 1}')),
            DataCell(Text(data.title.toString())),
            DataCell(Text(data.customer?.name.toString() ?? "-")),
            DataCell(Text(data.box?.name.toString() ?? "-")),
            DataCell(
              Text(
                '${data.customer != null ? AppTool.formatMoney(data.downPayment.toString()) : "-"}',
              ),
            ),
            DataCell(Text('${AppTool.formatMoney(data.amount.toString())}')),
            DataCell(
              Text(
                '${data.customer != null ? AppTool.formatMoney((double.parse(data.downPayment.toString()) - double.parse(data.amount.toString())).toString()) : "-"}',
              ),
            ),
            DataCell(
              Text(
                '${AppTool.formatDate(DateTime.parse(data.createdAt.toString()))}',
              ),
            ),
            DataCell(Text(data.note.toString())),
            DataCell(
              InkWell(
                onTap: () {
                  Get.dialog(
                    Scaffold(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      appBar: AppBar(
                        title: const Text('المرفقات'),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                      ),
                      body: DisplayGroubFile(files: data.filePaths ?? []),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.file_upload,
                      color: (data.filePaths ?? []).isNotEmpty
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      (data.filePaths ?? []).isNotEmpty
                          ? 'عرض المرفقات'
                          : 'لا يوجد مرفقات',
                      style: TextStyle(
                        color: (data.filePaths ?? []).isNotEmpty
                            ? Colors.blue
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DataCell(_buildApprovalStatus(data)),
            if (onTap != null)
              DataCell(
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => onTap!(data),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _card_phone(BondModel item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "#${index + 1}",
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    item.title ?? "بدون عنوان",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // Customer & Box
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.customer?.name ?? "-",
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.inventory_2,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.box?.name ?? "-",
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "التاريخ",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  Text(
                    item.createdAt != null
                        ? AppTool.formatDate(
                            DateTime.parse(item.createdAt.toString()),
                          )
                        : "-",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),
          // Financials
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "المبلغ المطلوب",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(
                      item.customer != null
                          ? AppTool.formatMoney(item.downPayment.toString())
                          : "-",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "الواصل",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(
                      AppTool.formatMoney(item.amount.toString()),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "المتبقي",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(
                      AppTool.formatMoney(
                        (double.parse(item.downPayment.toString()) -
                                double.parse(item.amount.toString()))
                            .toString(),
                      ),
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // Note
          if (item.note != null && item.note!.isNotEmpty) ...[
            Text(
              "ملاحظة:",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.note!,
              style: TextStyle(color: Colors.grey.shade700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
          ],

          const Divider(),
          // Footer Actions
          Row(
            children: [
              Expanded(child: _buildApprovalStatus(item)),
              const SizedBox(width: 12),
              InkWell(
                onTap: () {
                  Get.dialog(
                    Scaffold(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      appBar: AppBar(
                        title: const Text('المرفقات'),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                      ),
                      body: DisplayGroubFile(files: item.filePaths ?? []),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: (item.filePaths ?? []).isNotEmpty
                        ? Colors.blue.shade50
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.attach_file,
                    color: (item.filePaths ?? []).isNotEmpty
                        ? Colors.blue
                        : Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalStatus(BondModel bond) {
    bool isApproved = bond.customer != null ? true : false;

    if (!isApproved) {
      return Container(child: const Text('-'));
    }

    String isPaid = '';
    Color statusColor;
    Color textColor;

    double amount = double.tryParse(bond.amount.toString()) ?? 0;
    double downPayment = double.tryParse(bond.downPayment.toString()) ?? 0;

    if (amount == downPayment) {
      isPaid = 'تم الدفع';
      statusColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green;
    } else if (amount != 0 && amount < downPayment) {
      isPaid = 'دفع جزئي';
      statusColor = Colors.orange.withOpacity(0.1);
      textColor = Colors.orange;
    } else {
      isPaid = 'لم يتم الدفع';
      statusColor = Colors.red.withOpacity(0.1);
      textColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.5)),
      ),
      child: Text(
        isPaid,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
