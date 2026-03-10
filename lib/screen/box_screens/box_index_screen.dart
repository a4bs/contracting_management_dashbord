import 'package:contracting_management_dashbord/constant/enum/screen_size_enum.dart';
import 'package:contracting_management_dashbord/controller/box_controller/box_controller.dart';
import 'package:contracting_management_dashbord/model/box/box_model.dart';
import 'package:contracting_management_dashbord/screen/box_screens/add_box_dialog.dart';
import 'package:contracting_management_dashbord/screen/box_screens/box_detail_screen.dart';
import 'package:contracting_management_dashbord/screen/filter_app/filter_box.dart';
import 'package:contracting_management_dashbord/model/box/filter_box_model.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/widget/app_bar_widget.dart';
import 'package:contracting_management_dashbord/widget/futuer_page_widget.dart';
import 'package:contracting_management_dashbord/widget/futuer_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoxIndexScreen extends GetView<BoxController> {
  const BoxIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<BoxController>()) {
      Get.put(BoxController());
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'القاصات',
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(const AddBoxDialog());
            },
            icon: Icon(Icons.add, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Get.dialog(
                Dialog(
                  child: FilterBox(
                    onFilterSubmit: (filter) {
                      controller.filterBox(FilterBoxModel.fromJson(filter));
                    },
                  ),
                ),
              );
            },
            icon: Icon(Icons.search, color: Colors.white),
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

  build_card_phon(BoxModel item) {
    return InkWell(
      onTap: () {
        controller.selectedBox.value = item;
        Get.dialog(BoxDetailScreen(box: item));
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
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
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
                        if (item.project != null)
                          Text(
                            item.project!.name ?? "",
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
                    icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
                    onPressed: () {
                      Get.dialog(AddBoxDialog(box: item));
                    },
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1),
            ),

            // Footer (Financials)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildFinancialInfo(
                      "سحوبات (Debit)",
                      item.debit ?? 0,
                      const Color(0xFFE53935), // Red
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  Expanded(
                    child: _buildFinancialInfo(
                      "ايداعات (Credit)",
                      item.credit ?? 0,
                      const Color(0xFF43A047), // Green
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

  Widget _buildFinancialInfo(String label, num amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${AppTool.formatMoney(amount.toString())}',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  _layout_phone() {
    return FutuerPageWidget<BoxModel>(
      handelData: () => controller.filterBox(FilterBoxModel()),
      controller: controller.boxPaginationController,

      cardInfo: (item, index) {
        return build_card_phon(item);
      },
    );
  }

  _layout_descktop() {
    return FutuerTableWidget<BoxModel>(
      handelData: () => controller.filterBox(FilterBoxModel()),
      controller: controller.boxPaginationController,
      columns: [
        DataColumn(label: Text('اسم القاصة', style: _headerStyle())),
        DataColumn(label: Text('اسم المشروع', style: _headerStyle())),
        DataColumn(label: Text('سحوبات القاصة', style: _headerStyle())),
        DataColumn(label: Text('ايداعات القاصة', style: _headerStyle())),
        DataColumn(label: Text('التفاصيل', style: _headerStyle())),
        DataColumn(label: Text('تعديل', style: _headerStyle())),
      ],
      buildRow: (item, index) => DataRow(
        cells: [
          DataCell(Text('${item.name}', style: _cellStyle())),
          DataCell(
            Text(
              '${item.project != null ? item.project!.name : 'لا ينتمي الى مشروع'}',
              style: _cellStyle(),
            ),
          ),
          DataCell(
            Text(
              '${AppTool.formatMoney(item.debit.toString())}',
              style: _cellStyle().copyWith(
                color: const Color(0xFFE53935),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataCell(
            Text(
              '${AppTool.formatMoney(item.credit.toString())}',
              style: _cellStyle().copyWith(
                color: const Color(0xFF43A047),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataCell(
            IconButton(
              icon: const Icon(
                Icons.remove_red_eye,
                color: AppColors.lightPrimary,
              ),
              onPressed: () {
                controller.selectedBox.value = item;
                Get.dialog(BoxDetailScreen(box: item));
              },
            ),
          ),
          DataCell(
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.lightPrimary),
              onPressed: () {
                Get.dialog(AddBoxDialog(box: item));
              },
            ),
          ),
        ],
      ),
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
