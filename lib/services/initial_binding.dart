import 'package:contracting_management_dashbord/controller/auth_controller/auth_controller.dart';
import 'package:contracting_management_dashbord/controller/owner/dashpord_controller.dart';
import 'package:get/get.dart';
import 'connection_service.dart';

/// تهيئة الخدمات والتحكمات في التطبيق
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ConnectionService>(ConnectionService(), permanent: true);

    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<OwnerDashpordController>(() => OwnerDashpordController(),
        fenix: true);
  }
}

