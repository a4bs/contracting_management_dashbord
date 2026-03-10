import 'package:contracting_management_dashbord/controller/app_controller/page_controller.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// The controller that manages the state

class FutuerPageWidget<T> extends StatelessWidget {
  final Future<List<T>?> Function() handelData; // Fetch data
  final Widget Function(T item, int index) cardInfo; // Display each item
  final PaginationController<T> controller;

  const FutuerPageWidget({
    super.key,
    required this.handelData,
    required this.cardInfo,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Only fetch if empty to avoid loops on rebuilds
    if (controller.items.isEmpty && !controller.showLoader.value) {
      controller.fetchData(handelData);
    }

    return Obx(
      () => controller.showLoader.value
          ? Center(
              child: CircularProgressIndicator(color: AppColors.lightPrimary),
            )
          : controller.items.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: () async => await controller.fetchData(handelData),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.items.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  T item = controller.items[index];
                  return cardInfo(item, index);
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: AppColors.lightOutline),
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
