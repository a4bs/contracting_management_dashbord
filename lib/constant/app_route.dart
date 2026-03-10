import 'package:contracting_management_dashbord/screen/archive_screens/archive_index_screen.dart';
import 'package:contracting_management_dashbord/screen/auth_screens/login_screen.dart';
import 'package:contracting_management_dashbord/screen/auth_screens/splash_screen.dart';
import 'package:contracting_management_dashbord/screen/bill_screens/bill_add_screen.dart';
import 'package:contracting_management_dashbord/screen/home_screens/index_screen.dart';
import 'package:contracting_management_dashbord/screen/notification_screens/notification_screen.dart';
import 'package:contracting_management_dashbord/screen/unit_screens/unit_index_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:contracting_management_dashbord/screen/bill_screens/bill_index_screen.dart';
import 'package:contracting_management_dashbord/screen/bound_screens/bound_index_screen.dart';
import 'package:contracting_management_dashbord/screen/box_screens/box_index_screen.dart';
import 'package:contracting_management_dashbord/screen/customer_screens/customer_index_screen.dart';
import 'package:contracting_management_dashbord/screen/dashboard_screen/dashboard_index_screen.dart';
import 'package:contracting_management_dashbord/screen/project_screens/project_index_screen.dart';
import 'package:contracting_management_dashbord/screen/setting_screens/setting_index_screen.dart';
import 'package:contracting_management_dashbord/screen/user_screens.dart/user_index_screen.dart';

class AppRoute {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String billAdd = '/billAdd';
  static const String notification = '/notification';
  static const String user = '/user';
  static const String project = '/project';
  static const String customer = '/customer';
  static const String box = '/box';
  static const String bill = '/bill';
  static const String bound = '/bound';
  static const String setting = '/setting';
  static const String unit = '/unit';
  static const String archive = '/archive';
  static const String dashboard = '/dashboard';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),

    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: home, page: () => IndexScreen()),
    GetPage(name: billAdd, page: () => BillAddScreen()),
    GetPage(name: notification, page: () => const NotificationScreen()),
    // ---------------------------------------------------------------
    GetPage(name: dashboard, page: () => DashboardIndexScreen()),
    GetPage(name: unit, page: () => UnitIndexScreen()),
    GetPage(name: user, page: () => UserIndexScreen()),
    GetPage(name: project, page: () => ProjectIndexScreen()),
    GetPage(name: customer, page: () => CustomerIndexScreen()),
    GetPage(name: box, page: () => BoxIndexScreen()),
    GetPage(name: bill, page: () => BillIndexScreen()),
    GetPage(name: bound, page: () => BoundIndexScreen()),
    GetPage(name: setting, page: () => SettingIndexScreen()),
    GetPage(name: archive, page: () => ArchiveIndexScreen()),
  ];
}
