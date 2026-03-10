import 'package:contracting_management_dashbord/constant/enum/rol_enum.dart';

import 'package:contracting_management_dashbord/tool/user_tool.dart';
import 'package:flutter/material.dart';

class AppPages {
  static List<Map<String, dynamic>> get pagesList => [
    {
      'title': 'لوحة التقارير',
      'icon': Icons.dashboard_outlined,
      'url': '/dashboard',
      'isShow': UserTool.checkPer(PermeationEnum.showDashboard),
    },
    {
      'title': 'المستخدمين',
      'icon': Icons.people_outline,
      'url': '/user',
      'isShow': UserTool.checkPer(PermeationEnum.showUsers),
    },
    // {
    //   'title': 'انواع المشاريع',
    //   'icon': Icons.category_outlined,
    //   'index': 2,
    //   'builder': () => Container(child: const Text('انواع المشاريع')),
    //   'isShow': UserTool.checkPer(PermeationEnum.showProjectTypes),
    // },
    {
      'title': 'المجمعات السكنية',
      'icon': Icons.apartment_outlined,
      'url': '/project',
      'isShow': UserTool.checkPer(PermeationEnum.showProjects),
    },
    {
      'title': 'العملاء',
      'icon': Icons.groups_outlined,
      'url': '/customer',
      'isShow': UserTool.checkPer(PermeationEnum.showCustomers),
    },
    {
      'title': 'القاصات',
      'icon': Icons.monetization_on_outlined,
      'url': '/box',
      'isShow': UserTool.checkPer(PermeationEnum.showBoxes),
    },
    {
      'title': 'نظام  المبيعات',
      'icon': Icons.receipt_long_outlined,
      'url': '/bill',
      'isShow': UserTool.checkPer(PermeationEnum.showBills),
    },
    {
      'title': '  الوحدات السكنية  ',
      'icon': Icons.shopping_cart_outlined,
      'url': '/unit',
      'isShow': UserTool.checkPer(PermeationEnum.showUnits),
    },
    {
      'title': 'الارشفة',
      'icon': Icons.folder_open_outlined,
      'url': '/archive',
      'isShow': UserTool.checkPer(PermeationEnum.showArchives),
    },
    {
      'title': 'الحركة المالية',
      'icon': Icons.account_balance_wallet_outlined,
      'url': '/bound',
      'isShow': UserTool.checkPer(PermeationEnum.showBonds),
    },

    {
      'title': 'الاعدادات',
      'icon': Icons.settings_outlined,
      'url': '/setting',
      'isShow': UserTool.checkPer(PermeationEnum.showSettings),
    },
  ];

  static List<Map<String, dynamic>> get pages =>
      pagesList.where((page) => page['isShow']).toList();
}
