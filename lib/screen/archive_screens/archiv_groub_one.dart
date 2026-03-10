import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/model/project/project_model.dart';
import 'package:contracting_management_dashbord/controller/archive_controller/archive_controller.dart';
import 'package:contracting_management_dashbord/constant/enum/screen_size_enum.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArchivGroubOne extends GetView<ArchiveController> {
  ArchivGroubOne({super.key});
  final _prohectController = Get.find<ProjectController>();
  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ArchiveController>()) {
      Get.put(ArchiveController());
    }
    return Scaffold(
      body: Obx(() {
        final dataController = _prohectController.projectDataController;

        if (dataController.items.isEmpty && !dataController.showLoader.value) {
          dataController.fetchData(() => _prohectController.getAllProjects());
        }

        if (dataController.showLoader.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.lightPrimary),
          );
        }

        if (dataController.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: AppColors.lightOutline,
                ),
                const SizedBox(height: 16),
                const Text(
                  'لا يوجد بيانات لعرضها',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightOnSurface,
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () => dataController.fetchData(
                    () => _prohectController.getAllProjects(),
                  ),
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

        return LayoutBuilder(
          builder: (context, constraints) {
            // Get screen size using the enum
            final screenSize = ScreenSize.fromWidth(constraints.maxWidth);

            // Define responsive grid parameters based on screen size
            int crossAxisCount;
            double childAspectRatio;

            if (screenSize.isMobile) {
              // Mobile: 2 columns
              crossAxisCount = 2;
              childAspectRatio = 1.0;
            } else if (screenSize == ScreenSize.tablet) {
              // Tablet portrait: 2 columns
              crossAxisCount = 2;
              childAspectRatio = 1.2;
            } else if (screenSize == ScreenSize.tabletLarge) {
              // Tablet landscape: 3 columns
              crossAxisCount = 3;
              childAspectRatio = 1.2;
            } else {
              // Desktop: 4 columns
              crossAxisCount = 4;
              childAspectRatio = 1.2;
            }

            return RefreshIndicator(
              onRefresh: () async => await dataController.fetchData(
                () => _prohectController.getAllProjects(),
              ),
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: dataController.items.length,
                itemBuilder: (context, index) {
                  return _buildProjectCard(dataController.items[index], index);
                },
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildProjectCard(ProjectModel item, int index) {
    // Define simple, subtle gradient colors based on index
    final gradients = [
      [const Color(0xFF6B7280), const Color(0xFF4B5563)], // Soft Gray
      [const Color(0xFF60A5FA), const Color(0xFF3B82F6)], // Soft Blue
      [const Color(0xFF34D399), const Color(0xFF10B981)], // Soft Green
      [const Color(0xFFF59E0B), const Color(0xFFD97706)], // Soft Amber
      [const Color(0xFFEC4899), const Color(0xFFDB2777)], // Soft Pink
      [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)], // Soft Purple
      [const Color(0xFF14B8A6), const Color(0xFF0D9488)], // Soft Teal
      [const Color(0xFFEF4444), const Color(0xFFDC2626)], // Soft Red
      [const Color(0xFF6366F1), const Color(0xFF4F46E5)], // Soft Indigo
      [const Color(0xFF06B6D4), const Color(0xFF0891B2)], // Soft Cyan
    ];

    final gradient = gradients[index % gradients.length];

    return InkWell(
      onTap: () {
        controller.selectedArchive.value.projectId = item.id;
        controller.pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
        controller.selectedArchive.refresh();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
        constraints: const BoxConstraints(minHeight: 100),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: gradient[0],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.folder, color: Colors.amber, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              item.name ?? '',
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ResponsiveMasterDetail<ArchiveModel>(
//       handelData: () => controller.getAllArchives(),
//       controller: controller.archivePaginationController,
//       header: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Row(
//           children: [
//             Expanded(
//               child: CustomButton(
//                 icon: Icons.add,
//                 onPressed: () async {
//                   Get.dialog(AddArchiveDialog());
//                 },
//                 text: "إضافة للأرشيف",
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: CustomButton(
//                 onPressed: () => Get.dialog(
//                   Dialog(
//                     child: FilterArchive(
//                       onFilterSubmit: (json) async {
//                         await controller.filterArchives(
//                           ArchiveFilterModel.fromJson(json),
//                         );
//                         Get.back();
//                       },
//                     ),
//                   ),
//                 ),
//                 text: "بحث",
//                 icon: Icons.search,
//               ),
//             ),
//           ],
//         ),
//       ),
//       onClickOnItem: (item) {
//         controller.selectedArchive.value = item;
//       },
//       cardInfo: (item, index) {
//         return CardArchive(
//           archive: item,
//           onEdit: (archive) {
//             Get.dialog(AddArchiveDialog(archive: archive));
//           },
//           onDelete: (archive) {
//             showConfirmationDialog(
//               title: "تأكيد الحذف",
//               message: "هل أنت متأكد من حذف هذا الأرشيف؟",
//               confirmText: "حذف",
//               onConfirm: () async {
//                 await controller.deleteArchive(archive.id);
//               },
//             );
//           },
//         );
//       },
//       detailBuilder: (context, item) {
//         return DisplayGroubFile(files: item.files ?? []);
//       },
//     );
