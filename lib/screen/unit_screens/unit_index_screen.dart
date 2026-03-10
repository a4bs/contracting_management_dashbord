import 'package:contracting_management_dashbord/constant/enum/screen_size_enum.dart';
import 'package:contracting_management_dashbord/controller/unit_controller/unit_controller.dart';
import 'package:contracting_management_dashbord/model/unit/unit_model.dart';
import 'package:contracting_management_dashbord/screen/unit_screens/add_unit_dialog.dart';
import 'package:contracting_management_dashbord/screen/unit_screens/unit_detail_screen.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/widget/app_bar_widget.dart';
import 'package:contracting_management_dashbord/widget/futuer_page_widget.dart';
import 'package:contracting_management_dashbord/widget/futuer_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnitIndexScreen extends GetView<UnitController> {
  const UnitIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<UnitController>()) {
      Get.put(UnitController());
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "الوحدات السكنية",
        actions: [
          IconButton(
            onPressed: () => Get.dialog(const AddUnitDialog()),
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            tooltip: "إضافة وحدة",
          ),
          IconButton(
            onPressed: () => controller.unitPaginationController.refreshItems(
              () => controller.getAllUnits(),
            ),
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: "     ",
          ),
        ],
      ),
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

  Widget _buildCard(UnitModel item) {
    bool isSold = item.customers != null && item.customers!.isNotEmpty;
    return InkWell(
      onTap: () {
        controller.selectedUnit.value = item;
        Get.to(() => UnitDetailScreen(item: item));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
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
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightPrimary.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.lightPrimary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.home_work_outlined,
                      color: AppColors.lightPrimary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name ?? "بدون اسم",
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          item.project?.name ?? "غير محدد",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
                    onPressed: () {
                      Get.dialog(AddUnitDialog(unit: item));
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1),
            ),

            // Footer (Status & Price)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isSold ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isSold ? "مباعه" : "غير مباعه",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSold ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  if (isSold)
                    Text(
                      AppTool.formatMoney(item.totalPayments.toString()),
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _layout_phone() {
    return FutuerPageWidget<UnitModel>(
      handelData: () => controller.getAllUnits(),
      controller: controller.unitPaginationController,
      cardInfo: (item, index) {
        return _buildCard(item);
      },
    );
  }

  _layout_descktop() {
    return FutuerTableWidget<UnitModel>(
      handelData: () => controller.getAllUnits(),
      controller: controller.unitPaginationController,
      columns: [
        DataColumn(label: Text('اسم الوحدة', style: _headerStyle())),
        DataColumn(label: Text('اسم المشروع', style: _headerStyle())),
        DataColumn(label: Text('الحالة', style: _headerStyle())),
        DataColumn(label: Text('المبلغ الواصل', style: _headerStyle())),
        DataColumn(label: Text('التفاصيل', style: _headerStyle())),
        DataColumn(label: Text('تعديل', style: _headerStyle())),
      ],
      buildRow: (item, index) {
        bool isSold = item.customers != null && item.customers!.isNotEmpty;
        return DataRow(
          cells: [
            DataCell(Text(item.name ?? "", style: _cellStyle())),
            DataCell(Text(item.project?.name ?? "-", style: _cellStyle())),
            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isSold
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isSold ? "مباعه" : "غير مباعه",
                  style: _cellStyle().copyWith(
                    color: isSold ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            DataCell(
              Text(
                isSold
                    ? AppTool.formatMoney(item.totalPayments.toString())
                    : "-",
                style: _cellStyle(),
              ),
            ),
            DataCell(
              IconButton(
                icon: const Icon(
                  Icons.remove_red_eye,
                  color: AppColors.lightPrimary,
                ),
                onPressed: () {
                  controller.selectedUnit.value = item;
                  Get.to(() => UnitDetailScreen(item: item));
                },
              ),
            ),
            DataCell(
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.lightPrimary),
                onPressed: () {
                  Get.dialog(AddUnitDialog(unit: item));
                },
              ),
            ),
          ],
        );
      },
    );
  }

  TextStyle _headerStyle() {
    return const TextStyle(
      fontFamily: 'Cairo',
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.black87,
    );
  }

  TextStyle _cellStyle() {
    return const TextStyle(
      fontFamily: 'Cairo',
      fontSize: 13,
      color: Colors.black87,
    );
  }
}
