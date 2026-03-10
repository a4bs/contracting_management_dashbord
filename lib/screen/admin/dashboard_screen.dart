import 'package:contracting_management_dashbord/controller/owner/dashpord_controller.dart';
import 'package:contracting_management_dashbord/model/ownerModels/owner_dashpord.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─── Responsive helper ───────────────────────────
bool _isMobile(BuildContext ctx) => MediaQuery.of(ctx).size.width < 600;

// ─────────────────────────────────────────────────
class DashboardScreen extends GetView<OwnerDashpordController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.ownerDashboardModel.value.generatedAt == null) {
        controller.getFullReport();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFEAEFF3),
      body: Obx(() {
        final data = controller.ownerDashboardModel.value;
        final mobile = _isMobile(context);
        final p = mobile ? 12.0 : 16.0;

        return RefreshIndicator(
          color: const Color(0xFF0C79A4),
          onRefresh: () async => controller.getFullReport(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(p),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DashboardHeader(generatedAt: data.generatedAt),
                SizedBox(height: mobile ? 14 : 18),

                // 1. Platform Overview
                _SectionTitle(
                  icon: Icons.dashboard_rounded,
                  title: 'نظرة عامة على المنصة',
                  color: const Color(0xFF0C79A4),
                ),
                SizedBox(height: mobile ? 8 : 10),
                _PlatformOverviewGrid(overview: data.platformOverview),
                SizedBox(height: mobile ? 16 : 20),

                // 2. Growth Metrics
                _SectionTitle(
                  icon: Icons.trending_up_rounded,
                  title: 'مقاييس النمو (آخر 30 يوم)',
                  color: const Color(0xFF2E7D32),
                ),
                SizedBox(height: mobile ? 8 : 10),
                _GrowthMetricsSection(metrics: data.growthMetrics),
                SizedBox(height: mobile ? 16 : 20),

                // 3. Financial Report
                _SectionTitle(
                  icon: Icons.account_balance_wallet_rounded,
                  title: 'التقرير المالي',
                  color: const Color(0xFFD7AD5E),
                ),
                SizedBox(height: mobile ? 8 : 10),
                _FinancialReportSection(report: data.financialReport),
                SizedBox(height: mobile ? 16 : 20),

                // 4 & 5: Resource + Operations
                mobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle(
                            icon: Icons.storage_rounded,
                            title: 'استهلاك الموارد',
                            color: const Color(0xFF6A1B9A),
                          ),
                          const SizedBox(height: 8),
                          _ResourceUsageCard(usage: data.resourceUsage),
                          const SizedBox(height: 16),
                          _SectionTitle(
                            icon: Icons.precision_manufacturing_rounded,
                            title: 'العمليات التشغيلية',
                            color: const Color(0xFFBF360C),
                          ),
                          const SizedBox(height: 8),
                          _OperationsCard(operations: data.operations),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SectionTitle(
                                  icon: Icons.storage_rounded,
                                  title: 'استهلاك الموارد',
                                  color: const Color(0xFF6A1B9A),
                                ),
                                const SizedBox(height: 10),
                                _ResourceUsageCard(usage: data.resourceUsage),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SectionTitle(
                                  icon: Icons.precision_manufacturing_rounded,
                                  title: 'العمليات التشغيلية',
                                  color: const Color(0xFFBF360C),
                                ),
                                const SizedBox(height: 10),
                                _OperationsCard(operations: data.operations),
                              ],
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: mobile ? 16 : 20),

                // 6. User Roles
                _SectionTitle(
                  icon: Icons.people_alt_rounded,
                  title: 'توزيع أدوار المستخدمين',
                  color: const Color(0xFF00695C),
                ),
                SizedBox(height: mobile ? 8 : 10),
                _UserRolesCard(userRoles: data.userRoles),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────
//  Dashboard Header
// ─────────────────────────────────────────────────
class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({this.generatedAt});
  final String? generatedAt;

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 14 : 18,
        vertical: mobile ? 12 : 14,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A3D5C), Color(0xFF0C79A4)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0C79A4).withOpacity(0.28),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(mobile ? 8 : 10),
            decoration: BoxDecoration(
              color: const Color(0xFFD7AD5E).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFD7AD5E).withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.bar_chart_rounded,
              color: const Color(0xFFD7AD5E),
              size: mobile ? 20 : 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'لوحة التحكم الرئيسية',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: mobile ? 14 : 16,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  generatedAt != null
                      ? 'آخر تحديث: $generatedAt'
                      : 'جارٍ تحميل البيانات...',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 10,
                    fontFamily: 'Cairo',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (!mobile)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh_rounded, color: Colors.white70, size: 12),
                  SizedBox(width: 4),
                  Text(
                    'اسحب للتحديث',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontFamily: 'Cairo',
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

// ─────────────────────────────────────────────────
//  Section Title
// ─────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.color,
  });
  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 7),
        Icon(icon, color: color, size: 15),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF171C20),
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────
//  Compact Stat Card
// ─────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });
  final String title;
  final dynamic value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 8 : 10,
        vertical: mobile ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: mobile ? 28 : 32,
            height: mobile ? 28 : 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: mobile ? 14 : 16),
          ),
          SizedBox(width: mobile ? 6 : 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF6E7980),
                    fontSize: mobile ? 8.5 : 9.5,
                    fontFamily: 'Cairo',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  '${value ?? 0}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: mobile ? 15 : 17,
                    fontFamily: 'Cairo',
                    height: 1.1,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: Color(0xFF9EABB3),
                      fontSize: 8,
                      fontFamily: 'Cairo',
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

// ─────────────────────────────────────────────────
//  1. Platform Overview Grid
// ─────────────────────────────────────────────────
class _PlatformOverviewGrid extends StatelessWidget {
  const _PlatformOverviewGrid({this.overview});
  final PlatformOverview? overview;

  @override
  Widget build(BuildContext context) {
    final items = [
      _CardItem(
        'إجمالي الشركات',
        overview?.totalCompanies,
        Icons.business_rounded,
        const Color(0xFF0C79A4),
      ),
      _CardItem(
        'الشركات النشطة',
        overview?.activeCompanies,
        Icons.check_circle_rounded,
        const Color(0xFF2E7D32),
        subtitle: 'ساري',
      ),
      _CardItem(
        'الشركات المنتهية',
        overview?.expiredCompanies,
        Icons.cancel_rounded,
        const Color(0xFFC62828),
        subtitle: 'تحتاج تجديد',
      ),
      _CardItem(
        'إجمالي المستخدمين',
        overview?.totalUsers,
        Icons.people_rounded,
        const Color(0xFF6A1B9A),
      ),
      _CardItem(
        'إجمالي المشاريع',
        overview?.totalProjects,
        Icons.folder_special_rounded,
        const Color(0xFFD7AD5E),
      ),
      _CardItem(
        'إجمالي المعدات',
        overview?.totalMachineries,
        Icons.construction_rounded,
        const Color(0xFF00695C),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final crossCount = w > 700 ? 3 : 2;
        final ratio = w > 700 ? 4.0 : (w < 380 ? 3.0 : 3.4);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: ratio,
          ),
          itemCount: items.length,
          itemBuilder: (context, i) => _StatCard(
            title: items[i].title,
            value: items[i].value,
            icon: items[i].icon,
            color: items[i].color,
            subtitle: items[i].subtitle,
          ),
        );
      },
    );
  }
}

class _CardItem {
  final String title;
  final dynamic value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  _CardItem(this.title, this.value, this.icon, this.color, {this.subtitle});
}

// ─────────────────────────────────────────────────
//  2. Growth Metrics — responsive
// ─────────────────────────────────────────────────
class _GrowthMetricsSection extends StatelessWidget {
  const _GrowthMetricsSection({this.metrics});
  final GrowthMetrics? metrics;

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);
    final items = [
      _CardItem(
        'شركات جديدة',
        metrics?.newCompanies30Days,
        Icons.store_rounded,
        const Color(0xFF2E7D32),
        subtitle: 'آخر 30 يوم',
      ),
      _CardItem(
        'مستخدمون جدد',
        metrics?.newUsers30Days,
        Icons.person_add_rounded,
        const Color(0xFF0C79A4),
        subtitle: 'آخر 30 يوم',
      ),
      _CardItem(
        'مشاريع جديدة',
        metrics?.newProjects30Days,
        Icons.add_business_rounded,
        const Color(0xFFD7AD5E),
        subtitle: 'آخر 30 يوم',
      ),
    ];

    if (mobile) {
      // stacked 1-column on very small, 2-col grid on normal mobile
      return LayoutBuilder(
        builder: (context, c) {
          final ratio = c.maxWidth < 360 ? 2.0 : 2.3;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: ratio,
            ),
            itemCount: items.length,
            itemBuilder: (ctx, i) => _StatCard(
              title: items[i].title,
              value: items[i].value,
              icon: items[i].icon,
              color: items[i].color,
              subtitle: items[i].subtitle,
            ),
          );
        },
      );
    }

    return Row(
      children: items.map((item) {
        final isLast = items.last == item;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 10),
            child: _StatCard(
              title: item.title,
              value: item.value,
              icon: item.icon,
              color: item.color,
              subtitle: item.subtitle,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────
//  3. Financial Report — responsive
// ─────────────────────────────────────────────────
class _FinancialReportSection extends StatelessWidget {
  const _FinancialReportSection({this.report});
  final FinancialReport? report;

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);
    return Column(
      children: [
        // Big revenue card (full width)
        _RevenueCard(value: report?.totalRevenue),
        const SizedBox(height: 10),
        // Monthly + Expiring
        mobile
            ? Column(
                children: [
                  _StatCard(
                    title: 'إيرادات الشهر',
                    value: report?.monthlyRevenue,
                    icon: Icons.calendar_month_rounded,
                    color: const Color(0xFF0C79A4),
                    subtitle: 'الشهر الحالي',
                  ),
                  const SizedBox(height: 10),
                  _StatCard(
                    title: 'تنتهي قريباً',
                    value: report?.expiringSoon,
                    icon: Icons.warning_amber_rounded,
                    color: const Color(0xFFC62828),
                    subtitle: 'خلال 15 يوم',
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'إيرادات الشهر',
                      value: report?.monthlyRevenue,
                      icon: Icons.calendar_month_rounded,
                      color: const Color(0xFF0C79A4),
                      subtitle: 'الشهر الحالي',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      title: 'تنتهي قريباً',
                      value: report?.expiringSoon,
                      icon: Icons.warning_amber_rounded,
                      color: const Color(0xFFC62828),
                      subtitle: 'خلال 15 يوم',
                    ),
                  ),
                ],
              ),
        const SizedBox(height: 10),
        // Subscription types
        (report?.subscriptionTypes?.isNotEmpty ?? false)
            ? _SubscriptionTypesCard(types: report!.subscriptionTypes!)
            : _EmptySubscriptionCard(),
      ],
    );
  }
}

class _RevenueCard extends StatelessWidget {
  const _RevenueCard({this.value});
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(mobile ? 12 : 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD7AD5E), Color(0xFFE8C87A)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD7AD5E).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(mobile ? 8 : 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.monetization_on_rounded,
              color: Colors.white,
              size: mobile ? 22 : 26,
            ),
          ),
          SizedBox(width: mobile ? 10 : 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'إجمالي الإيرادات',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  '${value ?? 0}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: mobile ? 22 : 26,
                    fontFamily: 'Cairo',
                    height: 1.1,
                  ),
                ),
                const Text(
                  'منذ البداية',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                    fontFamily: 'Cairo',
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

class _SubscriptionTypesCard extends StatelessWidget {
  const _SubscriptionTypesCard({required this.types});
  final List<dynamic> types;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.card_membership_rounded,
                color: Color(0xFFD7AD5E),
                size: 14,
              ),
              SizedBox(width: 5),
              Text(
                'الباقات والاشتراكات',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: types.map((t) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD7AD5E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFFD7AD5E).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  '$t',
                  style: const TextStyle(fontSize: 11, fontFamily: 'Cairo'),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _EmptySubscriptionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD7AD5E).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.card_membership_rounded,
            color: const Color(0xFFD7AD5E).withOpacity(0.5),
            size: 15,
          ),
          const SizedBox(width: 8),
          const Text(
            'لا توجد باقات اشتراك مسجلة حتى الآن',
            style: TextStyle(
              color: Color(0xFF9EABB3),
              fontSize: 11,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
//  Shared Info Row
// ─────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    this.valueColor,
  });
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);
    return Row(
      children: [
        Container(
          width: mobile ? 28 : 32,
          height: mobile ? 28 : 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: mobile ? 14 : 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: const Color(0xFF6E7980),
              fontSize: mobile ? 11 : 12,
              fontFamily: 'Cairo',
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? const Color(0xFF171C20),
            fontWeight: FontWeight.bold,
            fontSize: mobile ? 12 : 13,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────
//  4. Resource Usage
// ─────────────────────────────────────────────────
class _ResourceUsageCard extends StatelessWidget {
  const _ResourceUsageCard({this.usage});
  final ResourceUsage? usage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.insert_drive_file_rounded,
            color: const Color(0xFF6A1B9A),
            label: 'إجمالي الملفات',
            value: '${usage?.totalFilesCount ?? 0} ملف',
          ),
          const Divider(height: 16, color: Color(0xFFEAEFF3)),
          _InfoRow(
            icon: Icons.cloud_rounded,
            color: const Color(0xFF0C79A4),
            label: 'المساحة المستخدمة',
            value: '${usage?.totalStorageUsedMb ?? 0} MB',
          ),
          const Divider(height: 16, color: Color(0xFFEAEFF3)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF6A1B9A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Color(0xFF6A1B9A),
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'أكثر الشركات نشاطاً',
                      style: TextStyle(
                        color: Color(0xFF6E7980),
                        fontSize: 11,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 3),
                    if (usage?.topActiveCompanies?.isNotEmpty ?? false)
                      ...?usage?.topActiveCompanies
                          ?.take(5)
                          .map(
                            (c) => Text(
                              '• $c',
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          )
                    else
                      const Text(
                        'لا توجد بيانات',
                        style: TextStyle(
                          color: Color(0xFF9EABB3),
                          fontSize: 11,
                          fontFamily: 'Cairo',
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
//  5. Operations
// ─────────────────────────────────────────────────
class _OperationsCard extends StatelessWidget {
  const _OperationsCard({this.operations});
  final Operations? operations;

  @override
  Widget build(BuildContext context) {
    final hasAlerts = (operations?.unresolvedAlertsCount ?? 0) > 0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.timer_rounded,
            color: const Color(0xFFBF360C),
            label: 'إجمالي ساعات الآليات',
            value: '${operations?.totalMachineryHours ?? 0} ساعة',
          ),
          const Divider(height: 16, color: Color(0xFFEAEFF3)),
          _InfoRow(
            icon: Icons.speed_rounded,
            color: const Color(0xFFD7AD5E),
            label: 'متوسط ساعات / عملية',
            value: '${operations?.avgHoursPerOperation ?? 0}',
          ),
          const Divider(height: 16, color: Color(0xFFEAEFF3)),
          _InfoRow(
            icon: Icons.payments_rounded,
            color: const Color(0xFF0C79A4),
            label: 'إجمالي المعاملات',
            value: '${operations?.totalTransactionsSum ?? 0}',
          ),
          const Divider(height: 16, color: Color(0xFFEAEFF3)),
          _InfoRow(
            icon: Icons.notification_important_rounded,
            color: hasAlerts
                ? const Color(0xFFC62828)
                : const Color(0xFF2E7D32),
            label: 'تنبيهات غير محلولة',
            value: '${operations?.unresolvedAlertsCount ?? 0}',
            valueColor: hasAlerts
                ? const Color(0xFFC62828)
                : const Color(0xFF2E7D32),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
//  6. User Roles
// ─────────────────────────────────────────────────
class _UserRolesCard extends StatelessWidget {
  const _UserRolesCard({this.userRoles});
  final UserRoles? userRoles;

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);
    final superA = userRoles?.superAdmins ?? 0;
    final compA = userRoles?.companyAdmins ?? 0;
    final clients = userRoles?.clients ?? 0;
    final total = superA + compA + clients;

    return Container(
      padding: EdgeInsets.all(mobile ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _RoleItem(
                  icon: Icons.admin_panel_settings_rounded,
                  label: 'مدراء النظام',
                  value: superA,
                  color: const Color(0xFF0C79A4),
                  total: total,
                ),
              ),
              SizedBox(width: mobile ? 10 : 14),
              Expanded(
                child: _RoleItem(
                  icon: Icons.manage_accounts_rounded,
                  label: 'مدراء الشركات',
                  value: compA,
                  color: const Color(0xFFD7AD5E),
                  total: total,
                ),
              ),
              SizedBox(width: mobile ? 10 : 14),
              Expanded(
                child: _RoleItem(
                  icon: Icons.person_rounded,
                  label: 'الزبائن',
                  value: clients,
                  color: const Color(0xFF00695C),
                  total: total,
                ),
              ),
            ],
          ),
          if (total > 0) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Row(
                children: [
                  if (superA > 0)
                    Flexible(
                      flex: superA,
                      child: Container(
                        height: 6,
                        color: const Color(0xFF0C79A4),
                      ),
                    ),
                  if (compA > 0)
                    Flexible(
                      flex: compA,
                      child: Container(
                        height: 6,
                        color: const Color(0xFFD7AD5E),
                      ),
                    ),
                  if (clients > 0)
                    Flexible(
                      flex: clients,
                      child: Container(
                        height: 6,
                        color: const Color(0xFF00695C),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RoleItem extends StatelessWidget {
  const _RoleItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.total,
  });
  final IconData icon;
  final String label;
  final int value;
  final Color color;
  final int total;

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);
    final pct = total > 0 ? (value / total * 100).toStringAsFixed(0) : '0';
    return Column(
      children: [
        Container(
          width: mobile ? 38 : 44,
          height: mobile ? 38 : 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: mobile ? 18 : 22),
        ),
        const SizedBox(height: 5),
        Text(
          '$value',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: mobile ? 17 : 20,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF6E7980),
            fontSize: mobile ? 9.5 : 11,
            fontFamily: 'Cairo',
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '$pct%',
          style: TextStyle(
            color: color.withOpacity(0.7),
            fontSize: 9,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}
