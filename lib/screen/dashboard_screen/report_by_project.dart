import 'package:contracting_management_dashbord/controller/project_controller/project_report_controller.dart';
import 'package:contracting_management_dashbord/model/project/project_model.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/widget/select_drop_don.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProjectReportView extends StatelessWidget {
  const ProjectReportView({super.key});

  String formatMoney(dynamic amount) {
    if (amount == null) return "0 د.ع";
    final num val = amount is num
        ? amount
        : (num.tryParse(amount.toString().replaceAll(',', '')) ?? 0);
    final formatter = NumberFormat("#,###.##");
    return "${formatter.format(val)} د.ع";
  }

  String formatCompact(dynamic amount) {
    if (amount == null) return "0 د.ع";
    final num val = amount is num
        ? amount
        : (num.tryParse(amount.toString().replaceAll(',', '')) ?? 0);
    final formatter = NumberFormat("#,###");
    return "${formatter.format(val)} د.ع";
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectReportController());
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,

      body: Obx(() {
        if (controller.isLoading.value && controller.projects.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Selector
              _buildProjectSelector(controller),
              const SizedBox(height: 24),

              // Show content only if project is selected
              if (controller.selectedProject.value != null) ...[
                // Top Stats Cards with Progress Circles
                if (isMobile)
                  _buildTopStatsCardsMobile(controller)
                else
                  _buildTopStatsCards(controller),
                const SizedBox(height: 24),

                // Charts - Stacked vertically on mobile
                if (isMobile) ...[
                  _buildWeeklyChart(controller, isMobile: true),
                  const SizedBox(height: 24),
                  _buildUnitsDistributionChart(controller, isMobile: true),
                ] else ...[
                  // Charts Row for tablet/desktop
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Weekly Transactions Chart
                      Expanded(
                        flex: 2,
                        child: _buildWeeklyChart(controller, isMobile: false),
                      ),
                      const SizedBox(width: 16),
                      // Units Distribution Pie Chart
                      Expanded(
                        child: _buildUnitsDistributionChart(
                          controller,
                          isMobile: false,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),

                // Financial Summary Cards
                // _buildFinancialSummaryCards(controller),
                const SizedBox(height: 24),

                // Progress Bars Section
                if (isMobile)
                  _buildProgressBarsSectionMobile(controller)
                else
                  _buildProgressBarsSection(controller),
                const SizedBox(height: 32),

                // Sales Analysis Section
                if (isMobile)
                  _buildSalesAnalysisSectionMobile(controller, isMobile: true)
                else
                  _buildSalesAnalysisSection(controller, isMobile: false),
                const SizedBox(height: 32),

                // Tables Section
                _buildTablesSection(controller),
              ] else
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48),
                    child: Column(
                      children: [
                        Icon(
                          Icons.analytics,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "اختر مشروعاً لعرض التقرير",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProjectSelector(ProjectReportController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "اختر المشروع",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SelectDropDon<ProjectModel>(
            name: 'project',
            label: 'اختر مشروعاً',
            onTap: () async => controller.projects,
            cardInfo: (project) => DropdownMenuEntry(
              value: project.id ?? 0,
              label: project.name ?? "مشروع #${project.id}",
            ),
            onSelected: (projectId) {
              final project = controller.projects.firstWhereOrNull(
                (p) => p.id == projectId,
              );
              if (project != null) {
                controller.selectProject(project);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopStatsCards(ProjectReportController controller) {
    final project = controller.selectedProject.value!;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            "إجمالي الإيداعات  ",
            formatCompact(controller.boxDeposits),
            Colors.green,
            controller.depositsPercentage,
            Icons.trending_up,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            "إجمالي السحوبات  ",
            formatCompact(controller.boxWithdrawals),
            Colors.red,
            controller.withdrawalsPercentage,
            Icons.trending_down,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            "الرصيد الحالي  ",
            formatCompact(project.balance),
            Colors.blue,
            controller.balancePercentage,
            Icons.account_balance_wallet,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            "الوحدات المباعة",
            "${controller.soldUnitsCount}",
            Colors.teal,
            controller.salesPercentage.toInt(),
            Icons.home_work,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    int percentage,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        value: percentage / 100,
                        strokeWidth: 4,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                    Text(
                      "$percentage",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(
    ProjectReportController controller, {
    bool isMobile = false,
  }) {
    final weeklyData = controller.getWeeklyData();
    final maxY = weeklyData.fold(0.0, (max, day) {
      final dayMax = [
        day['deposits']!,
        day['withdrawals']!,
      ].reduce((a, b) => a > b ? a : b);
      return dayMax > max ? dayMax : max;
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "الحركة المالية الأسبوعية",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "آخر 7 أيام",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.amber.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: isMobile ? 200 : 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY > 0 ? maxY * 1.2 : 100,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = [
                          'السبت',
                          'الأحد',
                          'الاثنين',
                          'الثلاثاء',
                          'الأربعاء',
                          'الخميس',
                          'الجمعة',
                        ];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              days[value.toInt()],
                              style: TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY > 0 ? maxY / 5 : 20,
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (index) {
                  final dayData = weeklyData[index];
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: dayData['deposits']!,
                        color: Colors.green,
                        width: 12,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                      BarChartRodData(
                        toY: dayData['withdrawals']!,
                        color: Colors.red,
                        width: 12,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem("إيداعات", Colors.green),
              const SizedBox(width: 24),
              _buildLegendItem("سحوبات", Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildUnitsDistributionChart(
    ProjectReportController controller, {
    bool isMobile = false,
  }) {
    final sold = controller.soldUnitsCount;
    final available = controller.availableUnitsCount;
    final total = sold + available;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "توزيع الوحدات",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: isMobile ? 150 : 200,
            child: total > 0
                ? PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 60,
                      sections: [
                        PieChartSectionData(
                          value: sold.toDouble(),
                          title: '$sold',
                          color: Colors.teal,
                          radius: 50,
                          titleStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: available.toDouble(),
                          title: '$available',
                          color: Colors.indigo,
                          radius: 50,
                          titleStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      "لا توجد بيانات",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              _buildPieLegendItem("مباعة", sold, Colors.teal),
              const SizedBox(height: 8),
              _buildPieLegendItem("متاحة", available, Colors.indigo),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "${controller.salesPercentage.toStringAsFixed(1)}%",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.lightPrimary,
              ),
            ),
          ),
          Center(
            child: Text(
              "نسبة المبيعات",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieLegendItem(String label, int value, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 13)),
        const Spacer(),
        Text(
          "$value وحدة",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBarsSection(ProjectReportController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "نسبة المبيعات",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildProgressBar(
                "نسبة الوحدات المباعة",
                controller.salesPercentage.toInt(),
                Colors.teal,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Text(
                      "${controller.soldUnitsCount}",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "وحدة مباعة",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Text(
                      "${controller.availableUnitsCount}",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "وحدة متاحة",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSalesAnalysisSection(
    ProjectReportController controller, {
    bool isMobile = false,
  }) {
    final expectedSales = controller.totalExpectedSales;
    final actualCollected = controller.totalActualCollected;
    final collectionPercentage = controller.collectionPercentage;
    final remaining = controller.remainingToCollect;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "تحليل المبيعات",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - Stats Cards
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // Expected Sales Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.attach_money,
                            color: Colors.blue,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "مبالغ المبيعات المتوقعة",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatMoney(expectedSales),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "مجموع تكلفة الوحدات",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Actual Collected Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.account_balance_wallet,
                                color: Colors.green,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "المال الحقيقي المحصل",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatMoney(actualCollected),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(color: Colors.grey.shade200),
                        const SizedBox(height: 12),
                        // Breakdown
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.receipt_long,
                                        size: 16,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "فواتير العملاء",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatCompact(controller.boxBillDebit),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey.shade200,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.people,
                                        size: 16,
                                        color: Colors.purple,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "مديونية العملاء",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatCompact(controller.boxCustomerDebit),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Remaining Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.pending_actions,
                            color: Colors.orange,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "المبلغ المتبقي",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatMoney(remaining),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "المطلوب تحصيله",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
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
            const SizedBox(width: 16),
            // Right side - Pie Chart
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Text(
                      "نسبة التحصيل",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: isMobile ? 200 : 250,
                      child: expectedSales > 0
                          ? PieChart(
                              PieChartData(
                                sectionsSpace: 2,
                                centerSpaceRadius: 60,
                                sections: [
                                  PieChartSectionData(
                                    value: actualCollected,
                                    title:
                                        '${collectionPercentage.toStringAsFixed(1)}%',
                                    color: Colors.green,
                                    radius: 60,
                                    titleStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  PieChartSectionData(
                                    value: remaining > 0 ? remaining : 0.1,
                                    title: remaining > 0
                                        ? '${(100 - collectionPercentage).toStringAsFixed(1)}%'
                                        : '',
                                    color: Colors.orange.shade300,
                                    radius: 60,
                                    titleStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Text(
                                "لا توجد بيانات",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "محصل",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            Text(
                              formatCompact(actualCollected),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "متبقي",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            Text(
                              formatCompact(remaining),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        "${collectionPercentage.toStringAsFixed(1)}%",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightPrimary,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "نسبة التحصيل",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressBar(String title, int percentage, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "$percentage%",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTablesSection(ProjectReportController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Withdrawals
        _buildSectionTitle("السحوبات", Icons.arrow_upward, Colors.red),
        const SizedBox(height: 16),
        _buildWithdrawalsTable(controller),
        const SizedBox(height: 32),

        // Deposits
        _buildSectionTitle("الإيداعات", Icons.arrow_downward, Colors.green),
        const SizedBox(height: 16),
        _buildDepositsTable(controller),
        const SizedBox(height: 32),

        // Units
        _buildSectionTitle("الوحدات", Icons.home, Colors.blue),
        const SizedBox(height: 16),
        _buildUnitsTable(controller),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildWithdrawalsTable(ProjectReportController controller) {
    if (controller.withdrawals.isEmpty) {
      return _buildEmptyState("لا توجد سحوبات");
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
          columns: [
            DataColumn(
              label: Text(
                "المعرف",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "العنوان",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "المبلغ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "التاريخ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "الحالة",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: controller.withdrawals.take(10).map((bond) {
            return DataRow(
              cells: [
                DataCell(Text("#${bond.id}", style: TextStyle())),
                DataCell(Text(bond.title ?? "-", style: TextStyle())),
                DataCell(
                  Text(
                    formatMoney(bond.amount),
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                DataCell(
                  Text(
                    bond.createdAt?.substring(0, 10) ?? "-",
                    style: TextStyle(),
                  ),
                ),
                DataCell(_buildStatusBadge(bond.isApprove == true)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDepositsTable(ProjectReportController controller) {
    if (controller.deposits.isEmpty) {
      return _buildEmptyState("لا توجد إيداعات");
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
          columns: [
            DataColumn(
              label: Text(
                "المعرف",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "العنوان",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "المبلغ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "العميل",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "التاريخ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: controller.deposits.take(10).map((bond) {
            return DataRow(
              cells: [
                DataCell(Text("#${bond.id}", style: TextStyle())),
                DataCell(Text(bond.title ?? "-", style: TextStyle())),
                DataCell(
                  Text(
                    formatMoney(bond.amount),
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                DataCell(Text(bond.customer?.name ?? "-", style: TextStyle())),
                DataCell(
                  Text(
                    bond.createdAt?.substring(0, 10) ?? "-",
                    style: TextStyle(),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildUnitsTable(ProjectReportController controller) {
    if (controller.units.isEmpty) {
      return _buildEmptyState("لا توجد وحدات");
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
          columns: [
            DataColumn(
              label: Text(
                "المعرف",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "الاسم",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "السعر",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "العميل",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "الحالة",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: controller.units.map((unit) {
            final isSold = unit.customers != null && unit.customers!.isNotEmpty;
            return DataRow(
              cells: [
                DataCell(Text("#${unit.id}", style: TextStyle())),
                DataCell(Text(unit.name ?? "-", style: TextStyle())),
                DataCell(Text(formatMoney(unit.cost), style: TextStyle())),
                DataCell(
                  Text(
                    unit.customers != null && unit.customers!.isNotEmpty
                        ? unit.customers!.first.name ?? "-"
                        : "-",
                    style: TextStyle(),
                  ),
                ),
                DataCell(_buildUnitStatusBadge(isSold)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isApproved) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isApproved
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isApproved ? "موافق" : "معلق",
        style: TextStyle(
          fontSize: 11,
          color: isApproved ? Colors.green : Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUnitStatusBadge(bool isSold) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSold
            ? Colors.teal.withOpacity(0.1)
            : Colors.indigo.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isSold ? "مباع" : "متاح",
        style: TextStyle(
          fontSize: 11,
          color: isSold ? Colors.teal : Colors.indigo,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Text(message, style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  // Mobile-specific methods
  Widget _buildTopStatsCardsMobile(ProjectReportController controller) {
    final project = controller.selectedProject.value!;

    return Column(
      children: [
        _buildStatCardMobile(
          "إجمالي الإيداعات",
          formatCompact(controller.boxDeposits),
          Colors.green,
          controller.depositsPercentage,
          Icons.trending_up,
        ),
        const SizedBox(height: 16),
        _buildStatCardMobile(
          "إجمالي السحوبات",
          formatCompact(controller.boxWithdrawals),
          Colors.red,
          controller.withdrawalsPercentage,
          Icons.trending_down,
        ),
        const SizedBox(height: 16),
        _buildStatCardMobile(
          "الرصيد الحالي",
          formatCompact(project.balance),
          Colors.blue,
          controller.balancePercentage,
          Icons.account_balance_wallet,
        ),
        const SizedBox(height: 16),
        _buildStatCardMobile(
          "الوحدات المباعة",
          "${controller.soldUnitsCount}",
          Colors.teal,
          controller.salesPercentage.toInt(),
          Icons.home_work,
        ),
      ],
    );
  }

  Widget _buildStatCardMobile(
    String title,
    String value,
    Color color,
    int percentage,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 3,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Text(
                  "$percentage",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBarsSectionMobile(ProjectReportController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "نسبة المبيعات",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildProgressBar(
          "نسبة الوحدات المباعة",
          controller.salesPercentage.toInt(),
          Colors.teal,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Text(
                      "${controller.soldUnitsCount}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "وحدة مباعة",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Text(
                      "${controller.availableUnitsCount}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "وحدة متاحة",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSalesAnalysisSectionMobile(
    ProjectReportController controller, {
    bool isMobile = false,
  }) {
    final expectedSales = controller.totalExpectedSales;
    final actualCollected = controller.totalActualCollected;
    final collectionPercentage = controller.collectionPercentage;
    final remaining = controller.remainingToCollect;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "تحليل المبيعات",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Stats Cards stacked vertically
        _buildSalesCardMobile(
          "مبالغ المبيعات المتوقعة",
          formatMoney(expectedSales),
          Icons.attach_money,
          Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildSalesCardMobile(
          "المال الحقيقي المحصل",
          formatMoney(actualCollected),
          Icons.account_balance_wallet,
          Colors.green,
        ),
        const SizedBox(height: 12),
        _buildSalesCardMobile(
          "المبلغ المتبقي",
          formatMoney(remaining),
          Icons.pending_actions,
          Colors.orange,
        ),
        const SizedBox(height: 24),
        // Collection Pie Chart
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Text(
                "نسبة التحصيل",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: expectedSales > 0
                    ? PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 50,
                          sections: [
                            PieChartSectionData(
                              value: actualCollected,
                              title:
                                  '${collectionPercentage.toStringAsFixed(1)}%',
                              color: Colors.green,
                              radius: 50,
                              titleStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            PieChartSectionData(
                              value: remaining > 0 ? remaining : 0.1,
                              title: remaining > 0
                                  ? '${(100 - collectionPercentage).toStringAsFixed(1)}%'
                                  : '',
                              color: Colors.orange.shade300,
                              radius: 50,
                              titleStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          "لا توجد بيانات",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMobileLegendItem("محصل", actualCollected, Colors.green),
                  _buildMobileLegendItem("متبقي", remaining, Colors.orange),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  "${collectionPercentage.toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSalesCardMobile(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLegendItem(String label, dynamic value, Color color) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        Text(
          formatCompact(value),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
