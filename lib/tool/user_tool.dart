import 'package:contracting_management_dashbord/constant/enum/rol_enum.dart';
import 'package:contracting_management_dashbord/model/user/user_model.dart';
import 'package:contracting_management_dashbord/services/local_storge.dart';
import 'package:contracting_management_dashbord/constant/app_key.dart';

class UserTool {
  static UserModel getUser() {
    final user = LocalStorageService.getData(AppKeys.userInfo);
    UserModel? userModel = UserModel.fromJson(user ?? {});
    return userModel;
  }

  static void saveUser(UserModel user) {
    LocalStorageService.saveData(AppKeys.userInfo, user.toJson());
  }

  static void removeUser() {
    LocalStorageService.removeData(AppKeys.userInfo);
  }

  static bool isLoggedIn() {
    final user = getUser();
    return user.token != null;
  }

  static void clear() {
    LocalStorageService.clearAll();
  }

  static bool checkPer(PermeationEnum per) {
    if (getUser().permissions != null) {
      return getUser().permissions!.where((e) => e.name == per.name).isNotEmpty;
    } else {
      return true;
    }
  }
}
