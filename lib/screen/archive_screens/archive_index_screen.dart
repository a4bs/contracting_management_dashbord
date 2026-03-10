import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/model/archive/archiv_filter_model.dart';

import 'package:contracting_management_dashbord/model/archive/archive_type_model.dart';
import 'package:contracting_management_dashbord/model/project/project_model.dart';
import 'package:contracting_management_dashbord/screen/archive_screens/archiv_groub_data.dart';
import 'package:contracting_management_dashbord/screen/archive_screens/archiv_groub_one.dart';
import 'package:contracting_management_dashbord/screen/archive_screens/archiv_groub_tow.dart';
import 'package:contracting_management_dashbord/screen/filter_app/filter_archive.dart';
import 'package:contracting_management_dashbord/widget/app_bar_widget.dart';
import 'package:contracting_management_dashbord/controller/archive_controller/archive_controller.dart';
import 'package:contracting_management_dashbord/screen/archive_screens/add_archive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArchiveIndexScreen extends GetView<ArchiveController> {
  ArchiveIndexScreen({super.key});
  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ArchiveController>()) {
      Get.put(ArchiveController());
    }
    final _prohectController = Get.find<ProjectController>();

    return Scaffold(
      appBar: CustomAppBar(
        title: "الأرشيف",
        actions: [
          IconButton(
            onPressed: () => Get.dialog(AddArchiveDialog()),
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            tooltip: "إضافة للأرشيف",
          ),
          IconButton(
            onPressed: () => Get.dialog(
              Dialog(
                child: FilterArchive(
                  archiveFilterModel: controller.filterArchive.value,
                  onFilterSubmit: (filter) async {
                    await controller.archivePaginationController.refreshItems(
                      () async {
                        controller.filterArchive.value =
                            ArchiveFilterModel.fromJson(filter);
                        var data = await controller.filterArchives(
                          ArchiveFilterModel.fromJson(
                            controller.filterArchive.value.toJson(),
                          ),
                        );
                        return data;
                      },
                    );
                    if (controller.currentPage.value != 2) {
                      controller.pageController.jumpToPage(2);
                    }
                    Get.back();
                  },
                ),
              ),
            ),
            icon: const Icon(Icons.filter_alt, color: Colors.white),
            tooltip: "فلتر الأرشيف",
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            var projects = _prohectController.projectDataController.items.where(
              (e) => e.id == controller.selectedArchive.value.projectId,
            );
            ProjectModel? project = projects.isNotEmpty ? projects.first : null;

            var archiveTypes = controller.archiveTypePaginationController.items
                .where(
                  (e) => e.id == controller.filterArchive.value.archiveTypeId,
                );
            ArchiveTypeModel? archiveType = archiveTypes.isNotEmpty
                ? archiveTypes.first
                : null;

            String nameproject = project?.name ?? "";
            String namearchive = archiveType?.name ?? "";
            bool showHeader =
                controller.currentPage.value > 0 ||
                (nameproject.isNotEmpty || namearchive.isNotEmpty);

            if (!showHeader) return const SizedBox.shrink();

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  if (controller.currentPage.value > 0) ...[
                    IconButton(
                      onPressed: () {
                        controller.pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        // Reset selection logic based on navigation flow
                        if (controller.currentPage.value == 1) {
                          controller.selectedArchive.value.projectId = null;
                        } else if (controller.currentPage.value == 2) {
                          controller.filterArchive.value.archiveTypeId = null;
                        }
                        controller.selectedArchive.refresh();
                        controller.filterArchive.refresh();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: Colors.black87,
                      ),
                      tooltip: "رجوع",
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 24,
                      width: 1,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      "$nameproject${nameproject.isNotEmpty && namearchive.isNotEmpty ? ' / ' : ''}$namearchive",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }),
          Expanded(
            child: PageView(
              controller: controller.pageController,
              physics:
                  const NeverScrollableScrollPhysics(), // Prevent manual swiping to enforce flow
              onPageChanged: (index) {
                controller.currentPage.value = index;
              },
              children: [ArchivGroubOne(), ArchivGroubTow(), ArchivGroubData()],
            ),
          ),
        ],
      ),
    );
  }
}
