import 'package:contracting_management_dashbord/constant/app_route.dart';
import 'package:contracting_management_dashbord/services/local_storge.dart';
import 'package:contracting_management_dashbord/tool/user_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final sideMenuController = SideMenuController();
  final pageController = PageController();
  final scrollController = ScrollController();

  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with first page
    connect_socket();
  }

  connect_socket() async {
    
  }

  void changePage(int index) {
    selectedIndex.value = index;
    pageController.jumpToPage(index);
  }

  void logout() async {
    // Clear user data
    await LocalStorageService.clearAll();

    // Navigate to login screen
    Get.offAllNamed(AppRoute.login);
  }
}
