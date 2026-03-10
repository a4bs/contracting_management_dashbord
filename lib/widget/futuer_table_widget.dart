import 'package:contracting_management_dashbord/controller/app_controller/page_controller.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FutuerTableWidget<T> extends StatelessWidget {
  final Future<List<T>?> Function() handelData;
  final List<DataColumn> columns;
  final DataRow Function(T item, int index) buildRow;
  final PaginationController<T> controller;

  const FutuerTableWidget({
    super.key,
    required this.handelData,
    required this.columns,
    required this.buildRow,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.items.isEmpty && !controller.showLoader.value) {
      controller.fetchData(handelData);
    }

    return Obx(() {
      if (controller.showLoader.value) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.lightPrimary),
        );
      }

      if (controller.items.isEmpty) {
        return _buildEmptyState();
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: RefreshIndicator(
              onRefresh: () async => await controller.fetchData(handelData),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        AppColors.lightPrimary.withOpacity(0.1),
                      ),
                      dataRowColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(WidgetState.hovered)) {
                          return AppColors.lightPrimary.withOpacity(0.05);
                        }
                        return Colors.transparent;
                      }),
                      border: TableBorder(
                        horizontalInside: BorderSide(
                          color: AppColors.lightOutline.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      columns: columns,
                      rows: List<DataRow>.generate(
                        controller.items.length,
                        (index) => buildRow(controller.items[index], index),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.table_chart_outlined,
            size: 64,
            color: AppColors.lightOutline,
          ),
          const SizedBox(height: 16),
          Text(
            'لا يوجد بيانات لعرضها',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnSurface,
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => controller.fetchData(handelData),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text("تحديث"),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.lightPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
