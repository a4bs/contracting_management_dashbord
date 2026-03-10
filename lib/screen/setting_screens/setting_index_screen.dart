import 'package:contracting_management_dashbord/screen/setting_screens/notifiction_users_setting_screen.dart';
import 'package:contracting_management_dashbord/screen/setting_screens/presentig_unit_screen.dart';
import 'package:contracting_management_dashbord/screen/setting_screens/staff_screen.dart';
import 'package:contracting_management_dashbord/screen/setting_screens/type_archive_screen.dart';
import 'package:contracting_management_dashbord/screen/setting_screens/type_project_srceen.dart';
import 'package:contracting_management_dashbord/widget/app_bar_widget.dart';
import 'package:contracting_management_dashbord/widget/tab_bar_widght.dart';

import 'package:flutter/material.dart';

class SettingIndexScreen extends StatelessWidget {
  const SettingIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: CustomAppBar(title: 'الإعدادات'),
        backgroundColor: const Color(0xFFF5F7FA),
        body: SafeArea(
          child: TabBarWidget(
            tabs: ['المشاريع', 'الارشيف', 'النسب', 'التنبيهات', 'الموظفين'],
            children: [
              TypeProjectSrceen(),
              TypeArchiveScreen(),
              PresentigUnitScreen(),
              NotifictionUsersSettingScreen(),
              StaffScreen(),
            ],
            length: 5,
          ),
        ),
      ),
    );
  }
}
