import 'package:contracting_management_dashbord/constant/enum/transaction_type_enum.dart';
import 'package:contracting_management_dashbord/controller/bond_controller/bond_controller.dart';
import 'package:contracting_management_dashbord/controller/box_controller/box_controller.dart';
import 'package:contracting_management_dashbord/model/bond/bond_key.dart';
import 'package:contracting_management_dashbord/model/bond/bond_model.dart';
import 'package:contracting_management_dashbord/model/bond/filter_bond.dart';

import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/widget/app_date_field.dart';
import 'package:contracting_management_dashbord/widget/future_pagination_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:contracting_management_dashbord/controller/percentage_controller/percentage_controller.dart';
import 'package:contracting_management_dashbord/widget/select_drop_don.dart';
import 'package:intl/intl.dart';

class PayIdReportTodayScreen extends GetView<BondController> {
  PayIdReportTodayScreen({super.key});
  final BoxController boxController = Get.find<BoxController>();
  final PercentageController percentageController =
      Get.find<PercentageController>();
  final GlobalKey<FormBuilderState> _filterFormKey =
      GlobalKey<FormBuilderState>();
  final ValueNotifier<int> _paymentTypeNotifier = ValueNotifier<int>(1);

  // Store current filter values to persist between bottom sheet opens
  final Map<String, dynamic> _currentFilters = {
    BondFilterKey.bondTypeId: TransactionTypeEnum.credit.id,
    BondFilterKey.isComplete: null,
    BondFilterKey.installmentDateFrom: DateTime.now(),
    BondFilterKey.installmentDateTo: DateTime.now(),
    BondFilterKey.isScheduledInstallment: 1,
  };

  // Responsive breakpoints
  static const double mobileBreakpoint = 600;
  static const double desktopBreakpoint = 1200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < mobileBreakpoint;
        final bool isDesktop = constraints.maxWidth >= desktopBreakpoint;

        return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            heroTag: 'filter_fab',
            onPressed: () =>
                _showFilterBottomSheet(context, isMobile, isDesktop),
            backgroundColor: AppColors.lightPrimary,
            elevation: 4,
            child: const Icon(Icons.filter_list_rounded, color: Colors.white),
          ),
          body: Container(
            color: const Color(0xFFF9FAFC), // Softer background color
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 24), // Increased padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Table Section
                  Expanded(child: _buildTableSection(isMobile, isDesktop)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableSection(bool isMobile, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF909090).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: FuturePaginationTableWidget(
          handelData: (page, limit) => controller.filterBonds(
            FilterBond(
              page: page,
              limit: limit,
              installmentDateFrom: DateTime(
                DateTime.now().year,
                DateTime.now().month - 1,
                1,
              ).toString(),
              installmentDateTo: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
              ).toString(),
              bondTypeId: TransactionTypeEnum.credit.id,
            ),
          ),
          columns: [
            DataColumn(
              label: Text('اسم', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text(
                'المبلغ المستحق',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'المبلغ المدفوع',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'التاريخ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'الملاحظات',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'الحالة',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          buildRow: (item, index) => DataRow(
            color: MaterialStateProperty.resolveWith<Color?>((
              Set<MaterialState> states,
            ) {
              if (index.isEven) {
                return AppColors.lightBackground.withOpacity(0.3);
              }
              return null;
            }),
            cells: [
              DataCell(
                Text(
                  item.title.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              DataCell(
                Text(
                  AppTool.formatMoney(item.downPayment.toString()),
                  style: TextStyle(
                    color: AppColors.lightPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  AppTool.formatMoney(item.amount.toString()),
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  item.installmentDateAt != null
                      ? AppTool.formatDate(
                          DateTime.parse(item.installmentDateAt.toString()),
                        )
                      : '',
                ),
              ),
              DataCell(
                Text(
                  item.note.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DataCell(_buildStatusBadge(item)),
            ],
          ),
          controller: controller.pageDataPagnationController,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BondModel item) {
    double target = double.tryParse(item.downPayment.toString()) ?? 0;
    double paid = double.tryParse(item.amount.toString()) ?? 0;
    String status = get_status(target, paid);

    Color statusColor;
    IconData statusIcon;

    if (paid == 0) {
      statusColor = Colors.red;
      statusIcon = Icons.cancel_outlined;
    } else if (target == paid) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle_outline;
    } else {
      statusColor = Colors.orange;
      statusIcon = Icons.pending_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withOpacity(0.15),
            statusColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, color: statusColor, size: 16),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  void _setLastMonth() {
    final current =
        _filterFormKey
                .currentState
                ?.fields[BondFilterKey.installmentDateFrom]
                ?.value
            as DateTime? ??
        DateTime.now();
    final start = DateTime(current.year, current.month - 1, 1);
    final end = DateTime(current.year, current.month, 0);

    _filterFormKey.currentState?.fields[BondFilterKey.installmentDateFrom]
        ?.didChange(start);
    _filterFormKey.currentState?.fields[BondFilterKey.installmentDateTo]
        ?.didChange(end);
  }

  void _setNextMonth() {
    final current =
        _filterFormKey
                .currentState
                ?.fields[BondFilterKey.installmentDateFrom]
                ?.value
            as DateTime? ??
        DateTime.now();
    final start = DateTime(current.year, current.month + 1, 1);
    final end = DateTime(current.year, current.month + 2, 0);

    _filterFormKey.currentState?.fields[BondFilterKey.installmentDateFrom]
        ?.didChange(start);
    _filterFormKey.currentState?.fields[BondFilterKey.installmentDateTo]
        ?.didChange(end);
  }

  void _resetFilters() {
    _filterFormKey.currentState?.patchValue({
      BondFilterKey.installmentDateFrom: DateTime.now(),
      BondFilterKey.installmentDateTo: DateTime.now(),
      BondFilterKey.bondTypeId: TransactionTypeEnum.credit.id,
      BondFilterKey.isComplete: null,
      BondFilterKey.isScheduledInstallment: 1,
    });
  }

  Future<void> _applyFilter() async {
    if (_filterFormKey.currentState?.saveAndValidate() ?? false) {
      final data = _filterFormKey.currentState!.value;

      // Update persistent filters
      _currentFilters.addAll(data);

      final filterData = Map<String, dynamic>.from(data);

      // Fix isScheduledInstallment value for backend
      if (filterData[BondFilterKey.isScheduledInstallment] == -1) {
        filterData[BondFilterKey.isScheduledInstallment] = 0;
      }

      // Close bottom sheet if mobile
      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }

      // Format Dates
      // Format Dates or Clear them if Percentage
      if (_paymentTypeNotifier.value == 0) {
        // Percentage selected - Remove date filters
        filterData.remove(BondFilterKey.installmentDateFrom);
        filterData.remove(BondFilterKey.installmentDateTo);
      } else {
        // Installment selected - Ensure dates are set
        if (filterData[BondFilterKey.installmentDateFrom] is DateTime) {
          filterData[BondFilterKey.installmentDateFrom] =
              "${DateFormat('yyyy-MM-dd').format(filterData[BondFilterKey.installmentDateFrom])} 00:00:00";
        }
        if (filterData[BondFilterKey.installmentDateTo] is DateTime) {
          filterData[BondFilterKey.installmentDateTo] =
              "${DateFormat('yyyy-MM-dd').format(filterData[BondFilterKey.installmentDateTo])} 23:59:59";
        }

        // Remove percentageId if it exists when logic is installment
        filterData.remove(BondFilterKey.percentageId);
      }

      filterData[BondFilterKey.bondTypeId] = TransactionTypeEnum.credit.id;

      await controller.pageDataPagnationController.refreshItems(
        (page, limit) => controller.filterBonds(
          FilterBond.fromJson(filterData)
            ..page = page
            ..limit = limit,
        ),
      );
    }
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

  // Deprecated - kept for compatibility
  get_status_widget(BondModel item) {
    return _buildStatusBadge(item);
  }

  // helper method to show bottom sheet
  void _showFilterBottomSheet(
    BuildContext context,
    bool isMobile,
    bool isDesktop,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 600 : double.infinity,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(
                    Icons.filter_list_rounded,
                    color: AppColors.lightPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "تصفية البيانات",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightOnSurface,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: PayIdFilterSection(
                    formKey: _filterFormKey,
                    initialValues: _currentFilters,
                    isMobile: isMobile,
                    isDesktop: isDesktop,
                    paymentTypeNotifier: _paymentTypeNotifier,
                    percentageController: percentageController,
                    onApply: _applyFilter,
                    onReset: _resetFilters,
                    onNextMonth: _setNextMonth,
                    onLastMonth: _setLastMonth,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PayIdFilterSection extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final Map<String, dynamic> initialValues;
  final bool isMobile;
  final bool isDesktop;
  final ValueNotifier<int> paymentTypeNotifier;
  final PercentageController percentageController;
  final VoidCallback onApply;
  final VoidCallback onReset;
  final VoidCallback onNextMonth;
  final VoidCallback onLastMonth;

  const PayIdFilterSection({
    super.key,
    required this.formKey,
    required this.initialValues,
    required this.isMobile,
    required this.isDesktop,
    required this.paymentTypeNotifier,
    required this.percentageController,
    required this.onApply,
    required this.onReset,
    required this.onNextMonth,
    required this.onLastMonth,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      initialValue: initialValues,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Payment Type Section
          _buildSectionTitle("نوع السداد", Icons.payment, isMobile),
          const SizedBox(height: 12),
          FormBuilderRadioGroup(
            name: BondFilterKey.isScheduledInstallment,
            options: const [
              FormBuilderFieldOption(
                value: 1,
                child: Text(" أقساط ( بتواريخ ) "),
              ),
              FormBuilderFieldOption(value: 0, child: Text(" نسب ( مشاريع ) ")),
            ],
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            wrapSpacing: 10,
            activeColor: AppColors.lightPrimary,
            orientation: OptionsOrientation.wrap,
            controlAffinity: ControlAffinity.leading,
            itemDecoration: BoxDecoration(
              color: AppColors.lightBackground.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            onChanged: (val) {
              if (val != null) {
                paymentTypeNotifier.value = val;
              }
            },
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade100, height: 1),
          const SizedBox(height: 16),

          // Dynamic Section (Date or Percentage)
          ValueListenableBuilder<int>(
            valueListenable: paymentTypeNotifier,
            builder: (context, type, _) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: type == 1
                    ? _buildDateFilter(context)
                    : _buildPercentageFilter(context),
              );
            },
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade100, height: 1),
          const SizedBox(height: 16),

          // Completion Status Section
          _buildSectionTitle(
            "حالة السداد",
            Icons.check_circle_outline,
            isMobile,
          ),
          const SizedBox(height: 12),
          FormBuilderRadioGroup(
            name: BondFilterKey.isComplete,
            options: const [
              FormBuilderFieldOption(value: null, child: Text("الكل")),
              FormBuilderFieldOption(value: true, child: Text("مكتمل")),
              FormBuilderFieldOption(value: false, child: Text("غير مكتمل")),
            ],
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            wrapSpacing: 10,
            activeColor: AppColors.lightPrimary,
            orientation: OptionsOrientation.wrap,
          ),

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.search_rounded, size: 22),
                    label: Text(
                      'تطبيق الفلتر',
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightPrimary,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: AppColors.lightPrimary.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: onApply,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    label: const Text('إعادة'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: onReset,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilter(BuildContext context) {
    return Column(
      key: const ValueKey('date_filter'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          "الفترة الزمنية",
          Icons.date_range_rounded,
          isMobile,
        ),
        const SizedBox(height: 12),
        if (isDesktop)
          Row(
            children: [
              Expanded(
                child: AppDateField(
                  name: BondFilterKey.installmentDateFrom,
                  labelText: 'من تاريخ',
                  icon: Icons.calendar_today_rounded,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppDateField(
                  name: BondFilterKey.installmentDateTo,
                  labelText: 'إلى تاريخ',
                  icon: Icons.event_rounded,
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              AppDateField(
                name: BondFilterKey.installmentDateFrom,
                labelText: 'من تاريخ',
                icon: Icons.calendar_today_rounded,
              ),
              const SizedBox(height: 12),
              AppDateField(
                name: BondFilterKey.installmentDateTo,
                labelText: 'إلى تاريخ',
                icon: Icons.event_rounded,
              ),
            ],
          ),
        const SizedBox(height: 16),
        // Quick Filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildQuickFilterChip(
                label: 'الشهر السابق',
                icon: Icons.arrow_back_ios_rounded,
                onPressed: onLastMonth,
              ),
              const SizedBox(width: 8),
              _buildQuickFilterChip(
                label: 'الشهر القادم',
                icon: Icons.arrow_forward_ios_rounded,
                onPressed: onNextMonth,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPercentageFilter(BuildContext context) {
    return Column(
      key: const ValueKey('percentage_filter'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("تصفية بالنسب", Icons.percent_rounded, isMobile),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: SelectDropDon(
            name: BondFilterKey.percentageId,
            label: 'اختر النسبة',
            icon: Icons.pie_chart_rounded,
            onTap: () => percentageController.getAllPercentages(),
            cardInfo: (item) =>
                DropdownMenuEntry(label: item.name.toString(), value: item.id),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isMobile) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.lightPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: isMobile ? 18 : 20,
            color: AppColors.lightPrimary,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: isMobile ? 15 : 16,
            fontWeight: FontWeight.bold,
            color: AppColors.lightOnSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickFilterChip({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isReset = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isReset ? Colors.red.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isReset ? Colors.red.shade200 : Colors.grey.shade300,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isReset ? Colors.red.shade700 : Colors.grey.shade700,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isReset ? Colors.red.shade700 : Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
