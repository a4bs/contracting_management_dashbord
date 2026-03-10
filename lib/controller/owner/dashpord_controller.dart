import 'package:contracting_management_dashbord/model/ownerModels/owner_dashpord.dart';
import 'package:contracting_management_dashbord/repo/owner_repo.dart';
import 'package:get/get.dart';

class OwnerDashpordController extends GetxController {
  Rx<OwnerDashboardModel> ownerDashboardModel = OwnerDashboardModel().obs;
  OwnerRepo ownerRepo = OwnerRepo();
  getFullReport() async {
    final response = await ownerRepo.getFullReport();
    if (response.status == true) {
      ownerDashboardModel.value = OwnerDashboardModel.fromJson(response.data);
    } else {
      return OwnerDashboardModel();
    }
  }
}
