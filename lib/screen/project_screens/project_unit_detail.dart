import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/screen/unit_screens/unit_detail_screen.dart';
import 'package:contracting_management_dashbord/widget/select_drop_don.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectUnitDetail extends GetView<ProjectController> {
  const ProjectUnitDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white),
          ),
          child: SelectDropDon(
            name: 'unit',
            color: Colors.white,
            isFill: true,
            label: 'اختر الوحدة',
            onTap: () => controller.getAllUnits(
              controller.selectedProject.value.id.toString(),
            ),
            onSelected: (value) => controller.selectedUnit.value = value,
            cardInfo: (item) =>
                DropdownMenuEntry(value: item, label: item.name.toString()),
          ),
        ),
        Expanded(
          child: Obx(
            () => controller.selectedUnit.value.id == null
                ? Center(child: Text('اختر ال وحدة'))
                : UnitDetailScreen(item: controller.selectedUnit.value),
          ),
        ),
      ],
    );
  }
}
