import 'package:contracting_management_dashbord/controller/box_controller/box_controller.dart';
import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/model/box/box_model.dart';
import 'package:contracting_management_dashbord/model/project/project_model.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/widget/futuer_page_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ─── helpers ──────────────────────────────────────────────────────────────────

String _fmt(num? v) {
  if (v == null) return '0 د.ع';
  return '${NumberFormat('#,###').format(v)} د.ع';
}

String _compact(num? v) {
  if (v == null) return '0';
  return NumberFormat.compact(locale: 'ar').format(v);
}

const _kRadius = 16.0;
const _kCardRadius = 14.0;

// ── Color tokens ──────────────────────────────────────────────────────────────
const Color _depositColor = Color(0xFF2E7D32); // green-800
const Color _withdrawColor = Color(0xFFC62828); // red-800
const Color _depositBg = Color(0xFFE8F5E9);
const Color _withdrawBg = Color(0xFFFFEBEE);

// ═══════════════════════════════════════════════════════════════════════════════
//  Root screen
// ═══════════════════════════════════════════════════════════════════════════════

class AllReportScreen extends StatelessWidget {
  AllReportScreen({super.key});

  final ProjectController projectController = Get.find<ProjectController>();
  final BoxController boxController = Get.find<BoxController>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 680;

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _ReportPanel(
                          title: 'تقرير المشاريع',
                          icon: Icons.work_outline_rounded,
                          accent: AppColors.lightTertiary,
                          chartBuilder: (items) => _ProjectBarChart(
                            items: items.cast<ProjectModel>(),
                          ),
                          listSlot: FutuerPageWidget<ProjectModel>(
                            handelData: () =>
                                projectController.getAllProjects(),
                            controller: projectController.projectDataController,
                            cardInfo: (item, i) => _ProjectCard(item: item),
                          ),
                          rxItems: projectController.projectDataController.items
                              .cast<dynamic>(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ReportPanel(
                          title: 'تقرير الصناديق',
                          icon: Icons.inventory_2_outlined,
                          accent: AppColors.lightPrimary,
                          chartBuilder: (items) =>
                              _BoxPieChart(items: items.cast<BoxModel>()),
                          listSlot: FutuerPageWidget<BoxModel>(
                            handelData: () => boxController.getAllBoxes(),
                            controller: boxController.boxPaginationController,
                            cardInfo: (item, i) => _BoxCard(item: item),
                          ),
                          rxItems: boxController.boxPaginationController.items
                              .cast<dynamic>(),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: _ReportPanel(
                          title: 'تقرير المشاريع',
                          icon: Icons.work_outline_rounded,
                          accent: AppColors.lightTertiary,
                          chartBuilder: (items) => _ProjectBarChart(
                            items: items.cast<ProjectModel>(),
                          ),
                          listSlot: FutuerPageWidget<ProjectModel>(
                            handelData: () =>
                                projectController.getAllProjects(),
                            controller: projectController.projectDataController,
                            cardInfo: (item, i) => _ProjectCard(item: item),
                          ),
                          rxItems: projectController.projectDataController.items
                              .cast<dynamic>(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _ReportPanel(
                          title: 'تقرير الصناديق',
                          icon: Icons.inventory_2_outlined,
                          accent: AppColors.lightPrimary,
                          chartBuilder: (items) =>
                              _BoxPieChart(items: items.cast<BoxModel>()),
                          listSlot: FutuerPageWidget<BoxModel>(
                            handelData: () => boxController.getAllBoxes(),
                            controller: boxController.boxPaginationController,
                            cardInfo: (item, i) => _BoxCard(item: item),
                          ),
                          rxItems: boxController.boxPaginationController.items
                              .cast<dynamic>(),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Generic Report Panel  (header → chart → list)
// ═══════════════════════════════════════════════════════════════════════════════

class _ReportPanel extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accent;
  final Widget Function(List<dynamic> items) chartBuilder;
  final Widget listSlot;
  final List<dynamic> rxItems; // reactive list reference

  const _ReportPanel({
    required this.title,
    required this.icon,
    required this.accent,
    required this.chartBuilder,
    required this.listSlot,
    required this.rxItems,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shadowColor: accent.withOpacity(0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_kRadius),
      ),
      color: AppColors.lightSurface,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          _PanelHeader(title: title, icon: icon, accent: accent),

          // ── Chart (shown only when data is available) ────────────────
          Obx(() {
            if (rxItems.isEmpty) return const SizedBox.shrink();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: chartBuilder(rxItems),
                ),
                const _Divider(),
              ],
            );
          }),

          // ── List ────────────────────────────────────────────────────────
          Expanded(child: listSlot),
        ],
      ),
    );
  }
}

// ── Panel header ──────────────────────────────────────────────────────────────

class _PanelHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accent;
  const _PanelHeader({
    required this.title,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.07),
        border: Border(
          bottom: BorderSide(color: accent.withOpacity(0.18), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: accent,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) => Container(
    height: 1,
    margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
    color: AppColors.lightOutlineVariant.withOpacity(0.5),
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Project Bar Chart
// ═══════════════════════════════════════════════════════════════════════════════

class _ProjectBarChart extends StatelessWidget {
  final List<ProjectModel> items;
  const _ProjectBarChart({required this.items});

  @override
  Widget build(BuildContext context) {
    final deposits = items.map((p) => (p.debit ?? 0).toDouble()).toList();
    final withdrawals = items.map((p) => (p.credit ?? 0).toDouble()).toList();
    final maxY = [
      ...deposits,
      ...withdrawals,
    ].fold(0.0, (m, v) => v > m ? v : m);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
      decoration: _cardDecor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              const Text(
                'الحركة المالية للمشاريع',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightOnSurface,
                ),
              ),
              const Spacer(),
              _Legend(label: 'إيداع', color: _depositColor),
              const SizedBox(width: 14),
              _Legend(label: 'سحب', color: _withdrawColor),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                maxY: maxY > 0 ? maxY * 1.28 : 100,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => const Color(0xFF1A2332),
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    getTooltipItem: (group, gIdx, rod, rIdx) {
                      final label = rIdx == 0 ? 'إيداع' : 'سحب';
                      return BarTooltipItem(
                        '$label\n',
                        const TextStyle(color: Colors.white70, fontSize: 10),
                        children: [
                          TextSpan(
                            text: _fmt(rod.toY),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= items.length) {
                          return const SizedBox.shrink();
                        }
                        final name = items[idx].name ?? '';
                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            name.length > 7 ? '${name.substring(0, 6)}…' : name,
                            style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.lightOutline,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) {
                        if (value == 0 || value == maxY * 1.28) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          _compact(value),
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.lightOutline,
                          ),
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
                  horizontalInterval: maxY > 0 ? maxY / 4 : 25,
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: AppColors.lightOutlineVariant.withOpacity(0.45),
                    strokeWidth: 0.7,
                    dashArray: [4, 4],
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(items.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    groupVertically: false,
                    barRods: [
                      BarChartRodData(
                        toY: deposits[i],
                        color: _depositColor.withOpacity(0.85),
                        width: 9,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(5),
                        ),
                      ),
                      BarChartRodData(
                        toY: withdrawals[i],
                        color: _withdrawColor.withOpacity(0.85),
                        width: 9,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(5),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Box Pie Chart
// ═══════════════════════════════════════════════════════════════════════════════

class _BoxPieChart extends StatelessWidget {
  final List<BoxModel> items;
  const _BoxPieChart({required this.items});

  @override
  Widget build(BuildContext context) {
    final totalDeposit = items.fold<double>(
      0,
      (s, b) => s + (b.debit ?? 0).toDouble(),
    );
    final totalWithdraw = items.fold<double>(
      0,
      (s, b) => s + (b.credit ?? 0).toDouble(),
    );
    final total = totalDeposit + totalWithdraw;
    final net = totalDeposit - totalWithdraw;
    final depositPct = total > 0
        ? (totalDeposit / total * 100).toStringAsFixed(0)
        : '0';
    final withdrawPct = total > 0
        ? (totalWithdraw / total * 100).toStringAsFixed(0)
        : '0';
    final isPositive = net >= 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: _cardDecor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Pie chart ──────────────────────────────────────────────────
          SizedBox(
            width: 120,
            height: 120,
            child: total > 0
                ? PieChart(
                    PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 32,
                      startDegreeOffset: -90,
                      sections: [
                        PieChartSectionData(
                          value: totalDeposit,
                          title: '$depositPct%',
                          color: _depositColor,
                          radius: 40,
                          titleStyle: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: totalWithdraw,
                          title: '$withdrawPct%',
                          color: _withdrawColor,
                          radius: 40,
                          titleStyle: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: Text(
                      'لا بيانات',
                      style: TextStyle(
                        color: AppColors.lightOutline,
                        fontSize: 11,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 18),

          // ── Legend + totals ────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // title
                const Text(
                  'إجمالي الصناديق',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightOnSurface,
                  ),
                ),
                const SizedBox(height: 12),
                _PieStat(
                  label: 'إيداع',
                  value: _fmt(totalDeposit),
                  color: _depositColor,
                  bgColor: _depositBg,
                  icon: Icons.trending_up,
                ),
                const SizedBox(height: 8),
                _PieStat(
                  label: 'سحب',
                  value: _fmt(totalWithdraw),
                  color: _withdrawColor,
                  bgColor: _withdrawBg,
                  icon: Icons.trending_down,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isPositive ? _depositBg : _withdrawBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'الصافي',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isPositive ? _depositColor : _withdrawColor,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _fmt(net),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isPositive ? _depositColor : _withdrawColor,
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
    );
  }
}

class _PieStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const _PieStat({
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 13),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          value,
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

// ═══════════════════════════════════════════════════════════════════════════════
//  Project Card
// ═══════════════════════════════════════════════════════════════════════════════

class _ProjectCard extends StatelessWidget {
  final ProjectModel item;
  const _ProjectCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final balance = item.balance ?? 0;
    final positive = balance >= 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 6, 10, 0),
      decoration: _itemDecor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1 – name + balance
            Row(
              children: [
                _IconBubble(
                  icon: Icons.work_rounded,
                  color: AppColors.lightTertiary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.name ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: AppColors.lightOnSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                // s
              ],
            ),
            const SizedBox(height: 10),
            // Row 2 – deposit / withdraw
            Row(
              children: [
                Expanded(
                  child: _NumTile(
                    label: 'إيداع',
                    value: _fmt(item.debit),
                    color: _depositColor,
                    bgColor: _depositBg,
                    icon: Icons.south_west,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _NumTile(
                    label: 'سحب',
                    value: _fmt(item.credit),
                    color: _withdrawColor,
                    bgColor: _withdrawBg,
                    icon: Icons.north_east,
                  ),
                ),
              ],
            ),
            if (item.projectStatus?.name != null) ...[
              const SizedBox(height: 8),
              _Tag(
                label: item.projectStatus!.name!,
                color: AppColors.lightPrimary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Box Card
// ═══════════════════════════════════════════════════════════════════════════════

class _BoxCard extends StatelessWidget {
  final BoxModel item;
  const _BoxCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final net = (item.debit ?? 0) - (item.credit ?? 0);
    final positive = net >= 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 6, 10, 0),
      decoration: _itemDecor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _IconBubble(
                  icon: Icons.inventory_2_rounded,
                  color: AppColors.lightPrimary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.name ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: AppColors.lightOnSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _BalanceTag(value: net, positive: positive),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _NumTile(
                    label: 'إيداع',
                    value: _fmt(item.debit),
                    color: _depositColor,
                    bgColor: _depositBg,
                    icon: Icons.south_west,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _NumTile(
                    label: 'سحب',
                    value: _fmt(item.credit),
                    color: _withdrawColor,
                    bgColor: _withdrawBg,
                    icon: Icons.north_east,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Shared atoms
// ═══════════════════════════════════════════════════════════════════════════════

/// Deposit / Withdraw number tile
class _NumTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const _NumTile({
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2), width: 0.8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceTag extends StatelessWidget {
  final num value;
  final bool positive;
  const _BalanceTag({required this.value, required this.positive});

  @override
  Widget build(BuildContext context) {
    final color = positive ? _depositColor : _withdrawColor;
    final bg = positive ? _depositBg : _withdrawBg;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            positive ? Icons.arrow_upward : Icons.arrow_downward,
            color: color,
            size: 10,
          ),
          const SizedBox(width: 3),
          Text(
            _fmt(value),
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _IconBubble({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 15),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.22), width: 0.75),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.label_outline, color: color, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final String label;
  final Color color;
  const _Legend({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.lightOutline),
        ),
      ],
    );
  }
}

// ── shared decoration helpers ─────────────────────────────────────────────────

BoxDecoration get _cardDecor => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(_kCardRadius),
  border: Border.all(color: AppColors.lightOutlineVariant, width: 0.75),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ],
);

BoxDecoration get _itemDecor => BoxDecoration(
  color: AppColors.lightSurfaceBright,
  borderRadius: BorderRadius.circular(_kCardRadius),
  border: Border.all(color: AppColors.lightOutlineVariant, width: 0.7),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ],
);
