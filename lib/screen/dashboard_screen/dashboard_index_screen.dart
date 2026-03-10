import 'package:contracting_management_dashbord/screen/dashboard_screen/all_report_screen.dart';
import 'package:contracting_management_dashbord/screen/dashboard_screen/debit_report_screen.dart';
import 'package:contracting_management_dashbord/screen/dashboard_screen/payid_report_today.dart';
import 'package:contracting_management_dashbord/screen/dashboard_screen/report_by_project.dart';
import 'package:contracting_management_dashbord/screen/dashboard_screen/report_number.dart';
import 'package:contracting_management_dashbord/widget/app_bar_widget.dart';
import 'package:contracting_management_dashbord/widget/tab_bar_widght.dart';
import 'package:flutter/material.dart';

class DashboardIndexScreen extends StatelessWidget {
  const DashboardIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'التقارير'),
      body: SafeArea(
        child: TabBarWidget(
          length: 5,
          tabs: const [
            'تقرير الاجمالي ',
            '   تقرير بالارقام  ',
            'تقرير المشروع',
            'تقرير السحوبات والموافقه',
            'تقرير التسدبد اليوم  ',
          ],
          children: [
            AllReportScreen(),
            ReportNumberScreen(),
            ProjectReportView(),
            DebitReportScreen(),
            PayIdReportTodayScreen(),
          ],
        ),
      ),
    );
  }
}
