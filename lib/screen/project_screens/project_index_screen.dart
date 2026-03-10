import 'package:contracting_management_dashbord/constant/enum/screen_size_enum.dart';
import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/model/project/project_model_filter.dart';
import 'package:contracting_management_dashbord/screen/filter_app/filter_project.dart';

import 'package:contracting_management_dashbord/screen/project_screens/add_project_dialog.dart';
import 'package:contracting_management_dashbord/screen/project_screens/project_detail_screen.dart';

import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/model/project/project_model.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/widget/app_bar_widget.dart';

import 'package:contracting_management_dashbord/widget/futuer_page_widget.dart';
import 'package:contracting_management_dashbord/widget/futuer_table_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectIndexScreen extends GetView<ProjectController> {
  const ProjectIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'المشاريع',
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Get.dialog(AddProjectDialog());
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt, color: Colors.white),
            onPressed: () {
              Get.dialog(
                Dialog(
                  child: FilterProject(
                    onFilterSubmit: (filter) {
                      controller.projectDataController.refreshItems(() async {
                        return await controller.getProjectByFilter(
                          ProjectModelFilter.fromJson(filter),
                        );
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
              controller.projectDataController.refreshItems(() async {
                return await controller.getProjectByFilter(
                  ProjectModelFilter(),
                );
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
              ? layout_phone()
              : layout_desktop();
        },
      ),
    );
  }

  build_cardInfo(ProjectModel item, int index) {
    return InkWell(
      onTap: () {
        controller.selectedProject.value = item;
        controller.selectedProject.refresh();
        Get.dialog(ProjectDetailScreen());
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Icon + Name + Status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.lightPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.business_center_outlined,
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
                        item.name ?? 'بدون اسم',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.lightOnSurface,
                        ),
                      ),
                      if (item.projectType?.name != null)
                        Text(
                          item.projectType!.name!,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: AppColors.lightOutline,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (item.isEnable == 1)
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: (item.isEnable == 1)
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    (item.isEnable == 1) ? 'نشط' : 'غير نشط',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: (item.isEnable == 1) ? Colors.green : Colors.red,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.dialog(AddProjectDialog(project: item));
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 16),

            // Stats Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  'الرصيد',
                  '${AppTool.formatMoney(item.balance.toString())}',
                  AppColors.lightPrimary,
                  isPrice: true,
                ),

                _buildStatItem(
                  'الوحدات المباعة',
                  '${item.soldUnitsCount ?? 0} / ${item.unitsCount ?? 0}',
                  AppColors.lightOutline,
                ),
              ],
            ),
            _buildStatItem(
              'السحب',
              '${AppTool.formatMoney(item.debit.toString())}',
              AppColors.lightPrimary,
              isPrice: true,
            ),

            _buildStatItem(
              'الإيداع',
              '${AppTool.formatMoney(item.credit.toString())}',
              AppColors.lightPrimary,
              isPrice: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    Color valueColor, {
    bool isPrice = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            color: AppColors.lightOutline,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  layout_phone() {
    return FutuerPageWidget(
      handelData: () async =>
          controller.getProjectByFilter(ProjectModelFilter()),
      cardInfo: (item, index) => build_cardInfo(item, index),
      controller: controller.projectDataController,
    );
  }

  layout_desktop() {
    return FutuerTableWidget(
      handelData: () async =>
          controller.getProjectByFilter(ProjectModelFilter()),
      columns: [
        DataColumn(
          label: Text(
            'اسم المشروع',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnSurface,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'نوع المشروع',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnSurface,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'رصيد قاصه  الفواتير',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnSurface,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'الوحدات المباعة',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnSurface,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'السحب',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnSurface,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'الإيداع',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnSurface,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'الحالة',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnSurface,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'التفصيل',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnSurface,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            ' تعديل',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnSurface,
            ),
          ),
        ),
      ],
      buildRow: (item, index) => DataRow(
        cells: [
          DataCell(
            Text(
              item.name ?? 'بدون اسم',
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
          ),
          DataCell(
            Text(
              item.projectType?.name ?? 'بدون نوع',
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
          ),
          DataCell(
            Text(
              '${AppTool.formatMoney(item.billDebit.toString())}د.ع ',
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.lightPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataCell(
            Text(
              '${item.soldUnitsCount ?? 0} / ${item.unitsCount ?? 0}',
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
          ),
          DataCell(
            Text(
              AppTool.formatMoney(item.credit.toString()) + 'د.ع ',
              style: const TextStyle(fontFamily: 'Cairo', color: Colors.red),
            ),
          ),
          DataCell(
            Text(
              AppTool.formatMoney(item.debit.toString()) + 'د.ع ',
              style: const TextStyle(fontFamily: 'Cairo', color: Colors.green),
            ),
          ),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: (item.isEnable == 1)
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (item.isEnable == 1)
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                ),
              ),
              child: Text(
                (item.isEnable == 1) ? 'نشط' : 'غير نشط',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: (item.isEnable == 1) ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),
          DataCell(
            IconButton(
              onPressed: () {
                controller.selectedProject.value = item;
                controller.selectedProject.refresh();
                Get.dialog(ProjectDetailScreen());
              },
              icon: const Icon(
                Icons.remove_red_eye,
                color: AppColors.lightOutline,
              ),
            ),
          ),
          DataCell(
            IconButton(
              onPressed: () {
                controller.selectedProject.value = item;
                controller.selectedProject.refresh();
                Get.dialog(AddProjectDialog(project: item));
              },
              icon: const Icon(Icons.edit, color: AppColors.lightPrimary),
            ),
          ),
        ],
      ),
      controller: controller.projectDataController,
    );
  }
}
