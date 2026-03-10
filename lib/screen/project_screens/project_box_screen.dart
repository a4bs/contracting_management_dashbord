import 'package:contracting_management_dashbord/model/box/box_model.dart';
import 'package:contracting_management_dashbord/model/box/filter_box_model.dart';
import 'package:contracting_management_dashbord/screen/box_screens/box_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';

class ProjectBoxScreen extends GetView<ProjectController> {
  const ProjectBoxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BoxModel?>(
      future: controller.getAllBoxes(
        FilterBoxModel(
          projectId: controller.selectedProject.value.id,
          id: controller.selectedProject.value.id,
        ),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('لا توجد بيانات للصندوق'));
        }

        final box = snapshot.data!;

        return BoxDetailScreen(box: box, withAppBar: false);
      },
    );
  }
}
