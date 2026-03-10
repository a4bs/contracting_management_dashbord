import 'package:contracting_management_dashbord/screen/project_screens/archiv_project_screen.dart';
import 'package:contracting_management_dashbord/screen/project_screens/project_box_screen.dart';
import 'package:contracting_management_dashbord/screen/project_screens/project_info_screen.dart';
import 'package:contracting_management_dashbord/screen/project_screens/project_unit_detail.dart';
import 'package:contracting_management_dashbord/widget/app_bar_widget.dart';
import 'package:contracting_management_dashbord/widget/tab_bar_widght.dart';
import 'package:flutter/material.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'تفاصيل المشروع'),
      body: TabBarWidget(
        length: 4,
        tabs: ['التفاصيل', 'القاصه', 'الوحدات', 'الارشيف'],
        children: [
          ProjectInfoScreen(),
          ProjectBoxScreen(),
          ProjectUnitDetail(),
          ArchivProjectScreen(),
        ],
      ),
    );
  }
}
