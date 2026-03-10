import 'package:contracting_management_dashbord/screen/admin/admin_screen.dart';
import 'package:contracting_management_dashbord/screen/admin/dashboard_screen.dart';
import 'package:contracting_management_dashbord/screen/auth_screens/login_screen.dart';
import 'package:contracting_management_dashbord/screen/auth_screens/splash_screen.dart';

import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoute {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String admin = '/Admin';
  static const String dashboard = '/dashboard';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),

    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: admin, page: () => const AdminScreen()),
    GetPage(name: dashboard, page: () => const DashboardScreen()),
  ];
}
