import 'package:contracting_management_dashbord/controller/app_controller/file_upload_controller.dart';
import 'package:contracting_management_dashbord/controller/archive_controller/archive_controller.dart';
import 'package:contracting_management_dashbord/controller/auth_controller/auth_controller.dart';
import 'package:contracting_management_dashbord/controller/bill_controller/bill_add_controlle.dart';
import 'package:contracting_management_dashbord/controller/bill_controller/bill_controller.dart';
import 'package:contracting_management_dashbord/controller/bond_controller/bond_controller.dart';
import 'package:contracting_management_dashbord/controller/box_controller/box_controller.dart';
import 'package:contracting_management_dashbord/controller/customer_controller/customer_controller.dart';
import 'package:contracting_management_dashbord/controller/dashboard_controller/dashboard_controller.dart';
import 'package:contracting_management_dashbord/controller/home_controller/home_controller.dart';
import 'package:contracting_management_dashbord/controller/notification_controller/notification_controller.dart';
import 'package:contracting_management_dashbord/controller/notification_receivers_controller/notification_receivers_controller.dart';
import 'package:contracting_management_dashbord/controller/percentage_controller/percentage_controller.dart';
import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/controller/project_status_controller/project_status_controller.dart';
import 'package:contracting_management_dashbord/controller/role_controller/role_controller.dart';
import 'package:contracting_management_dashbord/controller/staff_controller/staff_controller.dart';
import 'package:contracting_management_dashbord/controller/unit_controller/unit_controller.dart';
import 'package:contracting_management_dashbord/controller/user_controller/user_controller.dart';
import 'package:contracting_management_dashbord/screen/filter_app/filter_archive.dart';
import 'package:contracting_management_dashbord/screen/filter_app/filter_bill.dart';
import 'package:contracting_management_dashbord/screen/filter_app/filter_bound.dart';
import 'package:contracting_management_dashbord/screen/filter_app/filter_box.dart';
import 'package:contracting_management_dashbord/screen/filter_app/filter_project.dart';
import 'package:contracting_management_dashbord/screen/filter_app/filter_customer.dart';
import 'package:get/get.dart';
import 'connection_service.dart';

/// تهيئة الخدمات والتحكمات في التطبيق
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ConnectionService>(ConnectionService(), permanent: true);

    // Controllers
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<ArchiveController>(() => ArchiveController(), fenix: true);
    Get.lazyPut<BillController>(() => BillController(), fenix: true);
    Get.lazyPut<BondController>(() => BondController(), fenix: true);
    Get.lazyPut<BoxController>(() => BoxController(), fenix: true);
    Get.lazyPut<CustomerController>(() => CustomerController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<BillAddController>(() => BillAddController(), fenix: true);

    Get.lazyPut<StaffController>(() => StaffController(), fenix: true);
    Get.lazyPut<FilterBondController>(
      () => FilterBondController(),
      fenix: true,
    );
    Get.lazyPut<FilterArchiveController>(
      () => FilterArchiveController(),
      fenix: true,
    );
    Get.lazyPut<FilterBillController>(
      () => FilterBillController(),
      fenix: true,
    );
    Get.put<FilterProjectController>(
      FilterProjectController(),
      permanent: true,
    );
    Get.put<FilterCustomerController>(
      FilterCustomerController(),
      permanent: true,
    );
    Get.lazyPut<FilterBoxController>(() => FilterBoxController(), fenix: true);

    Get.lazyPut<FileUploadController>(
      () => FileUploadController(),
      fenix: true,
    );
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
      fenix: true,
    );
    Get.lazyPut<NotificationReceiversController>(
      () => NotificationReceiversController(),
      fenix: true,
    );
    Get.lazyPut<PercentageController>(
      () => PercentageController(),
      fenix: true,
    );
    Get.lazyPut<ProjectController>(() => ProjectController(), fenix: true);
    Get.lazyPut<ProjectStatusController>(
      () => ProjectStatusController(),
      fenix: true,
    );

    Get.lazyPut<RoleController>(() => RoleController(), fenix: true);
    Get.lazyPut<UnitController>(() => UnitController(), fenix: true);
    Get.lazyPut<UserController>(() => UserController(), fenix: true);
  }
}
