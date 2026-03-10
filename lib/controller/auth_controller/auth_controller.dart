import 'package:contracting_management_dashbord/constant/app_route.dart';
import 'package:contracting_management_dashbord/model/user/user_model.dart';
import 'package:contracting_management_dashbord/repo/auth_repo.dart';
import 'package:contracting_management_dashbord/services/local_storge.dart';
import 'package:contracting_management_dashbord/tool/user_tool.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthRepo _authRepo = AuthRepo();

  login(Map<String, dynamic> data) async {
    try {
      final response = await _authRepo.login(data);

      if (response.status == true) {
        UserTool.saveUser(UserModel.fromJson(response.data));
        CustomToast.showInfo(title: "تم", description: response.message);

        // Start platform-specific notification service after login
        final userId = UserTool.getUser().id;

        Get.offAllNamed(AppRoute.home);
      } else {
        CustomToast.showInfo(title: "خطأ", description: response.message);
      }
    } catch (e) {}
  }

  void logout() async {
    // Clear user data
    await LocalStorageService.clearAll();

    // Navigate to login screen
    Get.offAllNamed(AppRoute.login);
  }
}
