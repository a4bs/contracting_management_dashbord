import 'package:contracting_management_dashbord/constant/enum/rol_enum.dart';
import 'package:contracting_management_dashbord/constant/enum/screen_size_enum.dart';
import 'package:contracting_management_dashbord/controller/app_controller/page_data_pagnation_controller.dart';
import 'package:contracting_management_dashbord/controller/bond_controller/bond_controller.dart';
import 'package:contracting_management_dashbord/model/bond/bond_model.dart';
import 'package:contracting_management_dashbord/model/bond/filter_bond.dart';
import 'package:contracting_management_dashbord/screen/shar_screens/display_groub_file.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/tool/user_tool.dart';
import 'package:contracting_management_dashbord/widget/dilog_check_user.dart';
import 'package:contracting_management_dashbord/widget/futuer_page_widget.dart';
import 'package:contracting_management_dashbord/widget/future_pagination_table_widget.dart';
import 'package:contracting_management_dashbord/widget/futuer_pagnation_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShearScreenToDebit extends GetView<BondController> {
  final FilterBond filterBond;
  final PageDataPagnationController<BondModel> pageDataPagnationController;
  final Function(BondModel)? onTap;
  ShearScreenToDebit({
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
    return _MobileBondList(
      controller: controller,
      filterBond: filterBond,
      pageDataPagnationController: pageDataPagnationController,
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
        DataColumn(label: Text("الى")),
        DataColumn(label: Text("الصندوق")),
        DataColumn(label: Text("المبلغ")),
        DataColumn(label: Text("التاريخ")),
        DataColumn(label: Text("ملاحظة")),
        DataColumn(label: Text("المرفقات")),
        DataColumn(label: Text("الموافقة")),
        DataColumn(label: Text("  الموافقين")),
        if (onTap != null) DataColumn(label: Text("  الاجراءات")),
      ],
      buildRow: (data, index) {
        return DataRow(
          cells: [
            DataCell(Text('${index + 1}')),
            DataCell(Text(data.title.toString())),
            DataCell(Text(data.staff?.name.toString() ?? "-")),
            DataCell(Text(data.box?.name.toString() ?? "-")),
            DataCell(Text('${AppTool.formatMoney(data.amount.toString())}')),
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
            DataCell(
              (UserTool.checkPer(PermeationEnum.approveBond) &&
                      !data.hasUserApproved(UserTool.getUser().id ?? 0))
                  ? Column(
                      children: [
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              showConfirmationDialog(
                                title: "تأكيد الموافقة",
                                message:
                                    "هل انت متاكد من موافقتك على هذا السند؟",
                                onConfirm: () async {
                                  await controller.proviteBound(data.id!);
                                  pageDataPagnationController.refreshItems(
                                    (page, limit) =>
                                        controller.filterBonds(filterBond),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              "موافقة على السند",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),
            DataCell(_buildApprovalStatus(data)),
            if (onTap != null)
              DataCell(
                IconButton(
                  onPressed: () => onTap!(data),
                  icon: Icon(Icons.edit),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildApprovalStatus(BondModel bond) {
    bool approved = bond.hasUserApproved(UserTool.getUser().id ?? 0);
    return InkWell(
      onTap: () {
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 500,
              height: 600,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "قائمة الموافقين",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FutuerPageWidget(
                      handelData: () async {
                        return await controller.getApprovedUsers(bond.id!);
                      },
                      cardInfo: (item, index) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue.shade100.withOpacity(
                                0.5,
                              ),
                              child: Text(
                                item.approvedBy?.fullName
                                        ?.substring(0, 1)
                                        .toUpperCase() ??
                                    "A",
                                style: TextStyle(
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item.approvedBy!.fullName.toString()}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${AppTool.formatDate(DateTime.parse(item.approvedAt.toString()))}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade400,
                            ),
                          ],
                        ),
                      ),
                      controller: controller.pageDataToApprovedController4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: approved
              ? Colors.green.withOpacity(0.05)
              : Colors.orange.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: approved
                ? Colors.green.withOpacity(0.2)
                : Colors.orange.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              approved ? Icons.check_circle_rounded : Icons.pending_rounded,
              size: 16,
              color: approved ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 6),
            Text(
              "${bond.approvalsCount} تم الاعتماد", // Simplified logic for display
              style: TextStyle(
                color: approved ? Colors.green[700] : Colors.orange[800],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileBondList extends StatefulWidget {
  final FilterBond filterBond;
  final PageDataPagnationController<BondModel> pageDataPagnationController;
  final BondController controller;
  const _MobileBondList({
    required this.filterBond,
    required this.pageDataPagnationController,
    required this.controller,
  });

  @override
  State<_MobileBondList> createState() => _MobileBondListState();
}

class _MobileBondListState extends State<_MobileBondList> {
  @override
  Widget build(BuildContext context) {
    return FutuerPagnationPageWidget(
      controller: widget.pageDataPagnationController,
      handelData: (page, limit) => widget.controller.filterBonds(
        widget.filterBond.copyWith(page: page, limit: limit),
      ),
      cardInfo: (item, index) {
        return _buildBondCard(item, index);
      },
    );
  }

  Widget _buildBondCard(BondModel bond, int index) {
    bool approved = bond.hasUserApproved(UserTool.getUser().id ?? 0);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Status Strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: approved
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "#${index + 1}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: approved ? Colors.green[800] : Colors.orange[800],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        approved
                            ? Icons.check_circle_rounded
                            : Icons.pending_rounded,
                        size: 14,
                        color: approved ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        approved ? "تمت الموافقة" : "بانتظار الموافقة",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: approved ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        bond.title ?? "بدون عنوان",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      AppTool.formatDate(
                        DateTime.parse(bond.createdAt.toString()),
                      ),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.person_outline,
                  "إلى:",
                  bond.staff?.name ?? "-",
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.account_balance_wallet_outlined,
                  "الصندوق:",
                  bond.box?.name ?? "-",
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "المبلغ",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AppTool.formatMoney(bond.amount.toString()),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                if (bond.note != null && bond.note!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    bond.note!,
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Get.dialog(
                            Scaffold(
                              backgroundColor: Colors.black.withOpacity(0.5),
                              appBar: AppBar(
                                title: const Text('المرفقات'),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                              ),
                              body: DisplayGroubFile(
                                files: bond.filePaths ?? [],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.attach_file, size: 18),
                        label: Text(
                          (bond.filePaths ?? []).isNotEmpty
                              ? "المرفقات (${bond.filePaths!.length})"
                              : "لا يوجد مرفقات",
                          style: const TextStyle(fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Show Approval button if applicable
                    if (UserTool.checkPer(PermeationEnum.approveBond) &&
                        !approved)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await widget.controller.proviteBound(bond.id!);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                          ),
                          child: const Text("موافقة"),
                        ),
                      ),
                    if (!(!approved &&
                        UserTool.checkPer(PermeationEnum.approveBond)))
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showApprovalDialog(bond);
                          },
                          icon: Icon(
                            Icons.info_outline,
                            size: 18,
                            color: approved ? Colors.green : Colors.orange,
                          ),
                          label: Text(
                            "التفاصيل",
                            style: TextStyle(
                              color: approved ? Colors.green : Colors.orange,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: approved
                                  ? Colors.green.withOpacity(0.5)
                                  : Colors.orange.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    );
  }

  void _showApprovalDialog(BondModel bond) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 500,
          height: 600,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "قائمة الموافقين",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              Expanded(
                child: FutuerPageWidget(
                  handelData: () async {
                    return await widget.controller.getApprovedUsers(bond.id!);
                  },
                  cardInfo: (item, index) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue.shade100.withOpacity(
                            0.5,
                          ),
                          child: Text(
                            item.approvedBy?.fullName
                                    ?.substring(0, 1)
                                    .toUpperCase() ??
                                "A",
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.approvedBy!.fullName.toString()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${AppTool.formatDate(DateTime.parse(item.approvedAt.toString()))}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.check_circle, color: Colors.green.shade400),
                      ],
                    ),
                  ),
                  controller: widget.controller.pageDataToApprovedController4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
