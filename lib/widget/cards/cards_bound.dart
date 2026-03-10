import 'package:contracting_management_dashbord/constant/enum/rol_enum.dart';
import 'package:contracting_management_dashbord/constant/enum/transaction_type_enum.dart';
import 'package:contracting_management_dashbord/controller/bond_controller/bond_controller.dart';
import 'package:contracting_management_dashbord/model/bond/bond_model.dart';
import 'package:contracting_management_dashbord/screen/shar_screens/display_groub_file.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/tool/user_tool.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardsBound extends GetView<BondController> {
  final BondModel bond;
  final bool isShowButtonProvite;
  const CardsBound({
    super.key,
    required this.bond,
    this.isShowButtonProvite = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isCredit = bond.bondTypeId == TransactionTypeEnum.credit.id;
    // Enhanced color palette
    Color statusColor = isCredit
        ? const Color(0xFF22C55E)
        : const Color(0xFFEF4444);
    Color backgroundColor = isCredit
        ? const Color(0xFFF0FDF4)
        : const Color(0xFFFEF2F2);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // More rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Optional: Add detail view action here
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Icon + Title + Date
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        isCredit
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: statusColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bond.title ?? "بدون عنوان",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              height: 1.2,
                              color: Color(0xFF1F2937), // Dark grey
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 12,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  AppTool.formatDate(
                                    DateTime.parse(bond.createdAt.toString()),
                                  ),
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Amount Section (Centerpiece)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "المبلغ",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppTool.formatMoney(bond.amount ?? "0"),
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: statusColor,
                                fontFamily: 'Roboto',
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isCredit ? "ايداع" : "سحب",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Notes Section (if notes exist)
                if (bond.note != null && bond.note!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                    ),
                    child: Text(
                      bond.note!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],

                // Action Footer: Files & Approvals
                if ((bond.filePaths != null && bond.filePaths!.isNotEmpty) ||
                    (isShowButtonProvite &&
                        UserTool.checkPer(PermeationEnum.approveBond))) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                  ),
                  Row(
                    children: [
                      // File Attachment Button
                      if (bond.filePaths != null &&
                          bond.filePaths!.isNotEmpty) ...[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.dialog(
                                Scaffold(
                                  backgroundColor: Colors.black.withOpacity(
                                    0.5,
                                  ),
                                  appBar: AppBar(
                                    title: const Text('المرفقات'),
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                  ),
                                  body: DisplayGroubFile(
                                    files: bond.filePaths!,
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.attachment_rounded,
                                    size: 16,
                                    color: Colors.blue[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "المرفقات (${bond.filePaths!.length})",
                                    style: TextStyle(
                                      color: Colors.blue[600],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (isShowButtonProvite) const SizedBox(width: 12),
                      ],

                      // Approval Button
                      if (isShowButtonProvite &&
                          UserTool.checkPer(PermeationEnum.approveBond))
                        Expanded(child: _buildApprovalStatus()),
                    ],
                  ),
                  // Render the approval button in a separate row if both exist for better touch targets?
                  // Or checking if user hasn't approved yet to show big button
                  if (isShowButtonProvite &&
                      UserTool.checkPer(PermeationEnum.approveBond) &&
                      !bond.hasUserApproved(UserTool.getUser().id ?? 0)) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller.proviteBound(bond.id!);
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
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApprovalStatus() {
    bool approved = bond.hasUserApproved(UserTool.getUser().id ?? 0);
    return Container(
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
            approved
                ? "تم الاعتماد"
                : "${bond.approvalsCount} تم الاعتماد", // Simplified logic for display
            style: TextStyle(
              color: approved ? Colors.green[700] : Colors.orange[800],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
