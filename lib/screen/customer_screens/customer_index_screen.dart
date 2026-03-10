import 'package:contracting_management_dashbord/constant/enum/screen_size_enum.dart';
import 'package:contracting_management_dashbord/controller/customer_controller/customer_controller.dart';
import 'package:contracting_management_dashbord/model/customer/customer_filter_model.dart';
import 'package:contracting_management_dashbord/model/customer/customer_model.dart';
import 'package:contracting_management_dashbord/screen/customer_screens/add_customer_dialog.dart';
import 'package:contracting_management_dashbord/screen/customer_screens/customer_detal.dart';
import 'package:contracting_management_dashbord/screen/filter_app/filter_customer.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/widget/app_bar_widget.dart';
import 'package:contracting_management_dashbord/widget/futuer_page_widget.dart';
import 'package:contracting_management_dashbord/widget/futuer_pagnation_page_widget.dart';
import 'package:contracting_management_dashbord/widget/futuer_table_widget.dart';
import 'package:contracting_management_dashbord/widget/future_pagination_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerIndexScreen extends GetView<CustomerController> {
  const CustomerIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CustomerController>()) {
      Get.put(CustomerController());
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "العملاء",
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Get.dialog(const AddCustomerDialog());
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt, color: Colors.white),
            onPressed: () {
              Get.dialog(
                Dialog(
                  child: FilterCustomer(
                    onFilterSubmit: (filter) {
                      controller.filterModel.value =
                          CustomerFilterModel.fromJson(filter);
                      controller.customerPaginationController.refreshItems((
                        page,
                        limit,
                      ) async {
                        var f = controller.filterModel.value;
                        f.page = page;
                        f.limit = limit;
                        return await controller.getCustomerByFilter(f);
                      });
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              controller.filterModel.value = CustomerFilterModel();
              controller.customerPaginationController.refreshItems((
                page,
                limit,
              ) async {
                var f = controller.filterModel.value;
                f.page = page;
                f.limit = limit;
                return await controller.getCustomerByFilter(f);
              });
            },
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

  _buildCard(CustomerModel item) {
    return InkWell(
      onTap: () {
        Get.dialog(CustomerDetal(customer: item));
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
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Get.dialog(AddCustomerDialog(customer: item));
              },
            ),
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
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.lightPrimary.withOpacity(0.2),
                    child: Text(
                      item.name?.substring(0, 1).toUpperCase() ?? "C",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.lightPrimary,
                      ),
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

            // Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow(
                    Icons.phone_outlined,
                    "الهاتف",
                    item.phone1 ?? "غير متوفر",
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    "العنوان",
                    item.address ?? "غير متوفر",
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.badge_outlined,
                    "رقم الهوية",
                    item.idCard ?? "غير متوفر",
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
                      "المبلغ الغير واصل    ",
                      item.credit ?? 0,
                      const Color(0xFFE53935),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  Expanded(
                    child: _buildFinancialInfo(
                      "المبلغ الواصل  ",
                      item.debit ?? 0,
                      const Color(0xFF43A047),
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
        const SizedBox(height: 4),
        Text(
          '${AppTool.formatMoney(amount.toString())} د.ع',
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
    return FutuerPagnationPageWidget<CustomerModel>(
      handelData: (page, limit) {
        var f = controller.filterModel.value;
        f.page = page;
        f.limit = limit;
        return controller.getCustomerByFilter(f);
      },
      controller: controller.customerPaginationController,

      cardInfo: (item, index) {
        return _buildCard(item);
      },
    );
  }

  _layout_descktop() {
    return FuturePaginationTableWidget<CustomerModel>(
      handelData: (page, limit) {
        var f = controller.filterModel.value;
        f.page = page;
        f.limit = limit;
        return controller.getCustomerByFilter(f);
      },
      controller: controller.customerPaginationController,

      columns: [
        DataColumn(label: Text('الاسم', style: _headerStyle())),
        DataColumn(label: Text('العنوان', style: _headerStyle())),
        DataColumn(label: Text('رقم الهوية', style: _headerStyle())),
        DataColumn(label: Text('رقم الهاتف', style: _headerStyle())),
        DataColumn(label: Text('المبلغ الواصل (مدين)', style: _headerStyle())),
        DataColumn(
          label: Text('المبلغ الغير واصل (دائن)', style: _headerStyle()),
        ),
        DataColumn(label: Text('التفاصيل', style: _headerStyle())),
        DataColumn(label: Text('تعديل', style: _headerStyle())),
      ],
      buildRow: (item, index) {
        return DataRow(
          cells: [
            DataCell(Text(item.name ?? "", style: _cellStyle())),
            DataCell(Text(item.address ?? "", style: _cellStyle())),
            DataCell(Text(item.idCard ?? "", style: _cellStyle())),
            DataCell(Text(item.phone1 ?? "", style: _cellStyle())),
            DataCell(
              Text(
                '${AppTool.formatMoney(item.debit.toString())} د.ع',
                style: _cellStyle().copyWith(
                  color: const Color(0xFF43A047),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataCell(
              Text(
                '${AppTool.formatMoney(item.credit.toString())} د.ع',
                style: _cellStyle().copyWith(
                  color: const Color(0xFFE53935),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataCell(
              IconButton(
                icon: const Icon(Icons.remove_red_eye),
                onPressed: () {
                  Get.dialog(CustomerDetal(customer: item));
                },
              ),
            ),
            DataCell(
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Get.dialog(AddCustomerDialog(customer: item));
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
