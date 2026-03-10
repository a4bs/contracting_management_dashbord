import 'package:contracting_management_dashbord/controller/archive_controller/archive_controller.dart';
import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/model/archive/archiv_filter_model.dart';
import 'package:contracting_management_dashbord/model/archive/archive_model.dart';
import 'package:contracting_management_dashbord/screen/filter_app/filter_archive.dart';
import 'package:contracting_management_dashbord/screen/shar_screens/display_groub_file.dart';
import 'package:contracting_management_dashbord/widget/cards/card_archive.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:contracting_management_dashbord/widget/master_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArchivProjectScreen extends GetView<ArchiveController> {
  ArchivProjectScreen({super.key});
  final ProjectController _projectController = Get.find();
  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ArchiveController>()) {
      Get.put(ArchiveController());
    }

    return ResponsiveMasterDetail<ArchiveModel>(
      handelData: () => controller.filterArchives(
        ArchiveFilterModel(
          projectId: _projectController.selectedProject.value.id,
        ),
      ),
      controller: controller.archivePaginationController,
      header: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                onPressed: () => Get.dialog(
                  Dialog(
                    child: FilterArchive(
                      onFilterSubmit: (json) async {
                        await controller.filterArchives(
                          ArchiveFilterModel.fromJson(json),
                        );
                        Get.back();
                      },
                    ),
                  ),
                ),
                text: "بحث",
                icon: Icons.search,
              ),
            ),
          ],
        ),
      ),
      onClickOnItem: (item) {
        controller.selectedArchive.value = item;
      },
      cardInfo: (item, index) {
        return CardArchive(archive: item);
      },
      detailBuilder: (context, item) {
        return DisplayGroubFile(files: item.files ?? []);
      },
    );
  }
}
