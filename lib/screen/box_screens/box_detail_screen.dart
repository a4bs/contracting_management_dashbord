import 'package:contracting_management_dashbord/constant/enum/transaction_type_enum.dart';
import 'package:contracting_management_dashbord/controller/bill_controller/bill_controller.dart';
import 'package:contracting_management_dashbord/controller/bond_controller/bond_controller.dart';
import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/model/bill/bill_filter.dart';
import 'package:contracting_management_dashbord/model/bill/bill_model.dart';
import 'package:contracting_management_dashbord/model/bond/bond_model.dart';
import 'package:contracting_management_dashbord/model/bond/filter_bond.dart';
import 'package:contracting_management_dashbord/model/box/box_model.dart';
import 'package:contracting_management_dashbord/screen/shar_screens/shear_screen_to_creadit.dart';
import 'package:contracting_management_dashbord/screen/shar_screens/shear_screen_to_debit.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/widget/app_bar_widget.dart';
import 'package:contracting_management_dashbord/widget/layout_tablet_phone.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BoxDetailScreen extends GetView<ProjectController> {
  final BoxModel box;
  final bool withAppBar;
  BoxDetailScreen({super.key, required this.box, this.withAppBar = true});
  final BondController _bondController = Get.find();
  final BillController _billController = Get.find();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final padding = isMobile ? 8.0 : 12.0;

    return Scaffold(
      appBar: withAppBar ? CustomAppBar(title: 'تفاصيل القاصه') : null,
      body: Container(
        padding: EdgeInsets.all(padding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(isMobile),
              SizedBox(height: isMobile ? 12 : 16),
              LayoutTabletPhone(
                children: [
                  _buildStatCard(
                    title: 'اجمالي الايداعات',
                    amount: box.debit ?? 0,
                    color: Colors.green,
                    icon: Icons.arrow_downward_rounded,
                  ),
                  _buildStatCard(
                    title: 'اجمالي السحوبات',
                    amount: box.credit ?? 0,
                    color: Colors.red,
                    icon: Icons.arrow_upward_rounded,
                  ),
                  _buildStatCard(
                    title: 'الرصيد الحالي',
                    amount: (box.credit ?? 0) - (box.debit ?? 0),
                    color: AppColors.lightPrimary,
                    icon: Icons.account_balance_wallet_rounded,
                    isHighlight: true,
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 12 : 16),

              SizedBox(
                height:
                    MediaQuery.of(context).size.height - (isMobile ? 150 : 180),
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        labelStyle: TextStyle(
                          fontSize: isMobile ? 13 : 15,
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: const [
                          Tab(text: "الايداعات"),
                          Tab(text: "السحبات"),
                          Tab(text: "الفواتي"),
                        ],
                      ),
                      SizedBox(height: isMobile ? 8 : 12),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ShearScreenToCredit(
                              filterBond: FilterBond(
                                projectId: controller.selectedProject.value.id,
                                boxId: box.id,
                                bondTypeId: TransactionTypeEnum.credit.id,
                              ),
                              pageDataPagnationController:
                                  _bondController.pageDataPagnationController,
                            ),
                            ShearScreenToDebit(
                              filterBond: FilterBond(
                                boxId: box.id,
                                projectId: controller.selectedProject.value.id,
                                bondTypeId: TransactionTypeEnum.debit.id,
                              ),
                              pageDataPagnationController:
                                  _bondController.pageDataPagnationController,
                            ),
                            _buildBill(
                              box.id,
                              controller.selectedProject.value.id,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 10 : 12),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.savings_rounded,
              size: isMobile ? 20 : 24,
              color: AppColors.lightPrimary,
            ),
          ),
          SizedBox(width: isMobile ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  box.name ?? "بدون اسم",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (box.project != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.business_rounded,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        box.project?.name ?? "",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required num amount,
    required Color color,
    required IconData icon,
    bool isHighlight = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return Container(
          decoration: BoxDecoration(
            color: isHighlight ? color : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
            border: isHighlight
                ? null
                : Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              key: Key(title), // Preserve state if needed
              maintainState: true,
              shape: const Border(), // Remove default border
              collapsedShape: const Border(), // Remove default collapsed border
              tilePadding: EdgeInsets.all(isMobile ? 8 : 12),
              leading: Container(
                padding: EdgeInsets.all(isMobile ? 8 : 10),
                decoration: BoxDecoration(
                  color: isHighlight
                      ? Colors.white.withOpacity(0.2)
                      : color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isHighlight ? Colors.white : color,
                  size: isMobile ? 18 : 22,
                ),
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: isMobile ? 12 : 14,
                  color: isHighlight
                      ? Colors.white.withOpacity(0.9)
                      : Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                AppTool.formatMoney(amount.toString()),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: isHighlight ? Colors.white : Colors.black87,
                ),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: isHighlight ? Colors.white70 : Colors.grey[400],
              ),
              children: [
                // Placeholder for future details or just empty for now
                if (isHighlight)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "الصافي",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget build_card_bound(BondModel bond, int typeId) {
    final isCredit = typeId == TransactionTypeEnum.credit.id;
    final color = isCredit ? Colors.green : Colors.red;
    final icon = isCredit
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;
    final label = TransactionTypeEnum.fromId(typeId)?.label ?? "";

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 12,
            vertical: isMobile ? 4 : 6,
          ),
          padding: EdgeInsets.all(isMobile ? 12 : 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 10 : 12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: isMobile ? 20 : 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'قيمة السند: ${AppTool.formatMoney(bond.downPayment.toString())}',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: isMobile ? 12 : 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'قيمة النقد: ${AppTool.formatMoney(bond.amount.toString())}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: isMobile ? 12 : 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bond.note ?? bond.title ?? "بدون وصف",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        if (bond.createdAt != null) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              AppTool.formatDate(
                                DateTime.parse(bond.createdAt.toString()),
                              ),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBill(int? boxId, int? projectId) {
    return FutureBuilder<List<BillModel>>(
      future: _billController.filterBills(
        BillFilter(projectId: projectId, boxId: boxId),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "حدث خطأ أثناء تحميل الفواتير",
              style: TextStyle(fontFamily: 'Cairo'),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  size: 48,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  "لا توجد فواتير",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        final bills = snapshot.data!;
        return ListView.builder(
          primary: false, // Fix PrimaryScrollController error
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: bills.length,
          itemBuilder: (context, index) {
            return build_card_bill(bills[index]);
          },
        );
      },
    );
  }

  Widget build_card_bill(BillModel bill) {
    const color = AppColors.lightTertiary; // Using a distinct color for bills
    const icon = Icons.receipt_long_rounded;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 12,
            vertical: isMobile ? 4 : 6,
          ),
          padding: EdgeInsets.all(isMobile ? 12 : 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 10 : 12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: isMobile ? 20 : 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'المبلغ : ${AppTool.formatMoney(bill.salePrice.toString())}',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: isMobile ? 13 : 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            'المدفوع : ${AppTool.formatMoney(bill.downPayment.toString())}',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: isMobile ? 12 : 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bill.note ?? "فاتورة مبيعات",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        if (bill.createdAt != null) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              AppTool.formatDate(
                                DateTime.parse(bill.createdAt.toString()),
                              ),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
