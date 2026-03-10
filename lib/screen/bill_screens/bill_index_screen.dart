import 'package:contracting_management_dashbord/constant/app_route.dart';
import 'package:contracting_management_dashbord/constant/enum/rol_enum.dart';
import 'package:contracting_management_dashbord/constant/enum/screen_size_enum.dart';
import 'package:contracting_management_dashbord/controller/bill_controller/bill_add_controlle.dart';
import 'package:contracting_management_dashbord/controller/bill_controller/bill_controller.dart';
import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/model/bill/bill_filter.dart';
import 'package:contracting_management_dashbord/model/bill/bill_key.dart';
import 'package:contracting_management_dashbord/model/bill/bill_model.dart';
import 'package:contracting_management_dashbord/screen/bill_screens/bill_detail_screen.dart';
import 'package:contracting_management_dashbord/screen/filter_app/filter_bill.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/tool/user_tool.dart';
import 'package:contracting_management_dashbord/widget/app_bar_widget.dart';
import 'package:contracting_management_dashbord/widget/futuer_page_widget.dart';
import 'package:contracting_management_dashbord/widget/futuer_pagnation_page_widget.dart';
import 'package:contracting_management_dashbord/widget/futuer_table_widget.dart';
import 'package:contracting_management_dashbord/widget/future_pagination_table_widget.dart';
import 'package:contracting_management_dashbord/widget/select_drop_don.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillIndexScreen extends GetView<BillController> {
  BillIndexScreen({super.key});
  final BillAddController billAddController = Get.find();
  final ProjectController projectController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<BillController>()) {
      Get.put(BillController());
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'فواتير',
        actions: [
          if (UserTool.checkPer(PermeationEnum.addBill))
            IconButton(
              onPressed: () {
                billAddController.clearAll();
                Get.toNamed(AppRoute.billAdd);
              },
              icon: const Icon(Icons.add, color: Colors.white),
              tooltip: 'إضافة فاتورة',
            ),
          IconButton(
            onPressed: () {
              Get.dialog(
                Dialog(
                  child: FilterBill(
                    onFilterSubmit: (json) {
                      controller.billDataController.refreshItems(
                        (page, limit) =>
                            controller.filterBills(controller.billFilter.value),
                      );
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.search, color: Colors.white),
            tooltip: 'بحث',
          ),
          IconButton(
            onPressed: () {
              controller.billFilter.value = BillFilter();
              controller.billDataController.refreshItems(
                (page, limit) => controller.filterBills(BillFilter()),
              );
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
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
            child: SelectDropDon(
              name: BillFilterKey.projectId,
              label: 'اختر المشروع',
              onClear: () {
                controller.billFilter.value = BillFilter();
                controller.billDataController.refreshItems(
                  (page, limit) => controller.filterBills(BillFilter()),
                );
              },
              onTap: () => projectController.getAllProjects(),
              onSelected: (value) {
                controller.billFilter.value = controller.billFilter.value
                    .copyWith(projectId: value, page: 1, limit: 10);
                controller.billDataController.refreshItems(
                  (page, limit) =>
                      controller.filterBills(controller.billFilter.value),
                );
              },
              cardInfo: (item) =>
                  DropdownMenuEntry(value: item.id, label: item.name ?? ''),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenSize = ScreenSize.fromWidth(constraints.maxWidth);
                return screenSize == ScreenSize.mobile ||
                        screenSize == ScreenSize.tablet
                    ? _layout_phone()
                    : _layout_descktop();
              },
            ),
          ),
        ],
      ),
    );
  }

  build_card_info(BillModel item) {
    return InkWell(
      onTap: () {
        Get.to(() => BillDetailScreen(itemBill: item));
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
                      Icons.description_outlined,
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
                          item.customer?.name ?? "عميل غير معروف",
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (item.createdAt != null)
                          Text(
                            item.createdAt!.split('T').first,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (item.unit != null)
                    _buildInfoRow(
                      Icons.home_work_outlined,
                      "الوحدة",
                      item.unit!.name ?? "",
                    ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1),
            ),
            if (item.plot != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildInfoRow(
                  Icons.home_work_outlined,
                  "الخارطه",
                  item.plot!.toString(),
                ),
              ),
            if (item.downPayment != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildInfoRow(
                  Icons.home_work_outlined,
                  "الدفعه الاولى",
                  item.downPayment!.toString(),
                ),
              ),
            // Footer (Total)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "الإجمالي",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppTool.formatMoney(item.salePrice.toString()),
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF43A047), // Green
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          "$label:",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  _layout_phone() {
    return FutuerPagnationPageWidget<BillModel>(
      handelData: (page, limit) => controller.filterBills(
        controller.billFilter.value.copyWith(page: page, limit: limit),
      ),
      controller: controller.billDataController,

      cardInfo: (item, index) {
        return build_card_info(item);
      },
    );
  }

  _layout_descktop() {
    return FuturePaginationTableWidget<BillModel>(
      handelData: (page, limit) => controller.filterBills(
        controller.billFilter.value.copyWith(page: page, limit: limit),
      ),
      controller: controller.billDataController,
      columns: [
        DataColumn(label: Text(' # ', style: _headerStyle())),
        DataColumn(label: Text('اسم العميل', style: _headerStyle())),
        DataColumn(label: Text('اسم الوحدة', style: _headerStyle())),
        DataColumn(label: Text('تاريخ الفاتورة', style: _headerStyle())),
        DataColumn(label: Text('الإجمالي', style: _headerStyle())),
        DataColumn(label: Text('الخارطه', style: _headerStyle())),
        DataColumn(label: Text('الدفعه الاولى', style: _headerStyle())),
        DataColumn(label: Text('التفاصيل', style: _headerStyle())),
      ],
      buildRow: (item, index) => DataRow(
        cells: [
          DataCell(Text((index + 1).toString(), style: _cellStyle())),
          DataCell(Text(item.customer?.name ?? "", style: _cellStyle())),
          DataCell(Text(item.unit?.name ?? "-", style: _cellStyle())),
          DataCell(
            Text(item.createdAt?.split('T').first ?? "-", style: _cellStyle()),
          ),
          DataCell(
            Text(
              AppTool.formatMoney(item.salePrice.toString()),
              style: _cellStyle().copyWith(
                color: const Color(0xFF43A047),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataCell(
            Text(
              item.plot.toString(),
              style: _cellStyle().copyWith(
                color: const Color(0xFF43A047),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataCell(
            Text(
              AppTool.formatMoney(item.downPayment.toString()),
              style: _cellStyle().copyWith(
                color: const Color(0xFF43A047),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataCell(
            IconButton(
              icon: const Icon(
                Icons.description_outlined,
                color: AppColors.lightPrimary,
              ),
              onPressed: () {
                Get.to(() => BillDetailScreen(itemBill: item));
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
