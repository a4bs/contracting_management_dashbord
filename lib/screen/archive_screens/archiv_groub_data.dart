import 'package:contracting_management_dashbord/constant/enum/screen_size_enum.dart';
import 'package:contracting_management_dashbord/controller/archive_controller/archive_controller.dart';
import 'package:contracting_management_dashbord/model/archive/archive_model.dart';
import 'package:contracting_management_dashbord/screen/archive_screens/add_archive_dialog.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/widget/cards/card_archive.dart';
import 'package:contracting_management_dashbord/widget/futuer_page_widget.dart';
import 'package:contracting_management_dashbord/widget/futuer_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArchivGroubData extends GetView<ArchiveController> {
  const ArchivGroubData({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ArchiveController>()) {
      Get.put(ArchiveController());
    }
    return Scaffold(
      body: Column(
        children: [
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

  _layout_phone() {
    return FutuerPageWidget<ArchiveModel>(
      handelData: () =>
          controller.filterArchives(controller.filterArchive.value),
      controller: controller.archivePaginationController,
      cardInfo: (item, index) {
        return CardArchive(
          archive: item,
          onEdit: (archive) {
            Get.dialog(AddArchiveDialog(archive: archive));
          },
          onDelete: (archive) {},
        );
      },
    );
  }

  _layout_descktop() {
    return FutuerTableWidget<ArchiveModel>(
      handelData: () =>
          controller.filterArchives(controller.filterArchive.value),
      controller: controller.archivePaginationController,
      columns: [
        DataColumn(label: Text('العنوان', style: _headerStyle())),
        DataColumn(label: Text('رقم الوثيقة', style: _headerStyle())),
        DataColumn(label: Text('المشروع', style: _headerStyle())),
        DataColumn(label: Text('التاريخ', style: _headerStyle())),
        DataColumn(label: Text('تعديل', style: _headerStyle())),
        DataColumn(label: Text('التفاصيل', style: _headerStyle())),
      ],
      buildRow: (item, index) {
        return DataRow(
          cells: [
            DataCell(Text(item.title ?? "-", style: _cellStyle())),
            DataCell(
              Text(item.archiveNumber?.toString() ?? "-", style: _cellStyle()),
            ),
            DataCell(Text(item.project?.name ?? "-", style: _cellStyle())),
            DataCell(Text(item.date ?? "-", style: _cellStyle())),
            DataCell(
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.lightPrimary),
                onPressed: () {
                  Get.dialog(AddArchiveDialog(archive: item));
                },
              ),
            ),
            DataCell(
              IconButton(
                icon: const Icon(
                  Icons.remove_red_eye,
                  color: AppColors.lightPrimary,
                ),
                onPressed: () {
                  // Show details logic
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
