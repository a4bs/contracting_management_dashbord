import 'package:contracting_management_dashbord/constant/app_pages.dart';
import 'package:contracting_management_dashbord/constant/enum/screen_size_enum.dart';
import 'package:contracting_management_dashbord/controller/home_controller/home_controller.dart';
import 'package:contracting_management_dashbord/controller/notification_controller/notification_controller.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/widget/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IndexScreen extends StatelessWidget {
  IndexScreen({super.key});
  final controller = Get.find<HomeController>();
  final notificationController = Get.find<NotificationController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(controller, context),
      backgroundColor: AppColors.lightBackground,
      appBar: CustomAppBar(title: 'الرئيسية'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Get screen size using the enum
          final screenSize = ScreenSize.fromWidth(constraints.maxWidth);

          // Define responsive grid parameters based on screen size
          int crossAxisCount;
          double childAspectRatio;

          if (screenSize.isMobile) {
            // Mobile: 2 columns
            crossAxisCount = 2;
            childAspectRatio = 1.5;
          } else if (screenSize == ScreenSize.tablet) {
            // Tablet portrait: 2 columns
            crossAxisCount = 2;
            childAspectRatio = 1.5;
          } else if (screenSize == ScreenSize.tabletLarge) {
            // Tablet landscape: 3 columns
            crossAxisCount = 3;
            childAspectRatio = 1.5;
          } else {
            // Desktop: 4 columns
            crossAxisCount = 4;
            childAspectRatio = 1.5;
          }

          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: AppPages.pages.length,
            itemBuilder: (context, index) {
              return _build_card_home(AppPages.pages[index], context, index);
            },
          );
        },
      ),
    );
  }

  Widget _buildDrawer(HomeController controller, BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.lightSurface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.lightPrimary),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.lightPrimary,
                      size: 32,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "المستخدم الحالي",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: AppPages.pages.map((data) {
                return Obx(
                  () => ListTile(
                    leading: Icon(
                      data['icon'],
                      color: controller.selectedIndex.value == data['index']
                          ? AppColors.lightPrimary
                          : AppColors.lightOutline,
                    ),
                    title: Text(
                      data['title'],
                      style: TextStyle(
                        color: controller.selectedIndex.value == data['index']
                            ? AppColors.lightPrimary
                            : AppColors.lightOnSurface,
                        fontWeight:
                            controller.selectedIndex.value == data['index']
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: controller.selectedIndex.value == data['index'],
                    selectedTileColor: AppColors.lightPrimary.withOpacity(0.1),
                    onTap: () {
                      controller.changePage(data['index']);
                      Navigator.pop(context); // Close drawer
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(
              "تسجيل الخروج",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Get.dialog(
                AlertDialog(
                  title: Text("تأكيد", style: TextStyle()),
                  content: Text(
                    "هل أنت متأكد من تسجيل الخروج؟",
                    style: TextStyle(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text("إلغاء", style: TextStyle()),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        Navigator.pop(context); // Close drawer
                        controller.logout();
                      },
                      child: Text(
                        "تسجيل الخروج",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _build_card_home(
    Map<String, dynamic> data,
    BuildContext context,
    int index,
  ) {
    // Get screen size using the enum
    final screenWidth = MediaQuery.of(context).size.width;
    final screenSize = ScreenSize.fromWidth(screenWidth);

    // Define simple, subtle gradient colors based on index
    final gradients = [
      [Color(0xFF6B7280), Color(0xFF4B5563)], // Soft Gray
      [Color(0xFF60A5FA), Color(0xFF3B82F6)], // Soft Blue
      [Color(0xFF34D399), Color(0xFF10B981)], // Soft Green
      [Color(0xFFF59E0B), Color(0xFFD97706)], // Soft Amber
      [Color(0xFFEC4899), Color(0xFFDB2777)], // Soft Pink
      [Color(0xFF8B5CF6), Color(0xFF7C3AED)], // Soft Purple
      [Color(0xFF14B8A6), Color(0xFF0D9488)], // Soft Teal
      [Color(0xFFEF4444), Color(0xFFDC2626)], // Soft Red
      [Color(0xFF6366F1), Color(0xFF4F46E5)], // Soft Indigo
      [Color(0xFF06B6D4), Color(0xFF0891B2)], // Soft Cyan
    ];

    final gradient = gradients[index % gradients.length];

    // Responsive icon size based on screen size
    final iconSize = screenSize.isMobile
        ? 32.0
        : screenSize.isTablet
        ? 36.0
        : 40.0;
    final iconPadding = screenSize.isMobile ? 16.0 : 18.0;

    return data['isShow'] == false
        ? SizedBox()
        : GestureDetector(
            onTap: () {
              Get.toNamed(data['url']);
            },
            child: Container(
              constraints: BoxConstraints(minHeight: 100),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(iconPadding),
                    decoration: BoxDecoration(
                      color: gradient[0],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      data['icon'] ?? Icons.apps,
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    data['title'] ?? '',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          );
  }
}
