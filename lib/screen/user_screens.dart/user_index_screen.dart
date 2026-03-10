import 'package:contracting_management_dashbord/constant/enum/screen_size_enum.dart';
import 'package:contracting_management_dashbord/controller/user_controller/user_controller.dart';
import 'package:contracting_management_dashbord/model/user/user_model.dart';
import 'package:contracting_management_dashbord/screen/user_screens.dart/add_user_dialog.dart';
import 'package:contracting_management_dashbord/screen/user_screens.dart/user_detail_screen.dart';
import 'package:contracting_management_dashbord/widget/app_bar_widget.dart';
import 'package:contracting_management_dashbord/widget/futuer_page_widget.dart';
import 'package:contracting_management_dashbord/widget/futuer_table_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserIndexScreen extends StatelessWidget {
  UserIndexScreen({super.key});
  final UserController userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'المستخدمين',
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
            onPressed: () {
              Get.dialog(AddUserDialog());
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              userController.pageDataUser.refreshItems(
                () => userController.getAllUsers(),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenSize = ScreenSize.fromWidth(constraints.maxWidth);
          return screenSize == ScreenSize.mobile ||
                  screenSize == ScreenSize.tablet
              ? mobileView()
              : desktopView();
        },
      ),
    );
  }

  Widget buildCard(UserModel item, [int index = 0]) {
    return InkWell(
      onTap: () {
        Get.dialog(UserDetailScreen(user: item));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blueAccent.withOpacity(0.1),
              child: Text(
                (item.fullName ?? item.username ?? "U")[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.fullName ?? "No Name",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.username ?? "",
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: (item.isEnable ?? false) ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mobileView() {
    return FutuerPageWidget(
      handelData: () {
        return userController.getAllUsers();
      },
      cardInfo: (item, index) => buildCard(item),
      controller: userController.pageDataUser,
    );
  }

  Widget desktopView() {
    return FutuerTableWidget<UserModel>(
      controller: userController.pageDataUser,
      handelData: () => userController.getAllUsers(),
      columns: const [
        DataColumn(label: Text('الاسم')),
        DataColumn(label: Text('اسم المستخدم')),
        DataColumn(label: Text('الحالة')),
        DataColumn(label: Text('الإجراءات')),
        DataColumn(label: Text('الصلاحيات')),
      ],
      buildRow: (item, index) {
        return DataRow(
          cells: [
            DataCell(Text(item.fullName ?? "No Name")),
            DataCell(Text(item.username ?? "")),
            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (item.isEnable ?? false)
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (item.isEnable ?? false) ? Colors.green : Colors.red,
                  ),
                ),
                child: Text(
                  (item.isEnable ?? false) ? 'نشط' : 'غير نشط',
                  style: TextStyle(
                    color: (item.isEnable ?? false) ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Get.dialog(AddUserDialog(user: item));
                    },
                  ),
                ],
              ),
            ),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.lock, color: Colors.blue),
                    onPressed: () {
                      Get.dialog(UserDetailScreen(user: item));
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
