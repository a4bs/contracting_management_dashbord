import 'package:contracting_management_dashbord/model/project_status/project_status_model.dart';
import 'package:contracting_management_dashbord/repo/project_status_repo.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:get/get.dart';

class ProjectStatusController extends GetxController {
  final ProjectStatusRepo _repo = ProjectStatusRepo();

  var projectStatusList = <ProjectStatusModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    getAllProjectStatus();
    super.onInit();
  }

  Future<void> getAllProjectStatus() async {
    try {
      isLoading.value = true;
      final response = await _repo.getAllProjectStatus();
      if (response.status == true) {
        if (response.data != null) {
          projectStatusList.value = (response.data as List)
              .map((e) => ProjectStatusModel.fromJson(e))
              .toList();
        }
      } else {
        CustomToast.showInfo(title: "خطأ", description: response.message);
      }
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProjectStatus({
    required String name,
    required int isEnable,
  }) async {
    try {
      final response = await _repo.addProjectStatus(
        name: name,
        isEnable: isEnable,
      );
      if (response.status == true) {
        CustomToast.showInfo(title: "تم", description: response.message);
        getAllProjectStatus();
      } else {
        CustomToast.showInfo(title: "خطأ", description: response.message);
      }
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  Future<void> updateProjectStatus({
    required int id,
    required String name,
    required int isEnable,
  }) async {
    try {
      final response = await _repo.updateProjectStatus(
        id: id,
        name: name,
        isEnable: isEnable,
      );
      if (response.status == true) {
        CustomToast.showInfo(title: "تم", description: response.message);
        getAllProjectStatus();
      } else {
        CustomToast.showInfo(title: "خطأ", description: response.message);
      }
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  Future<void> deleteProjectStatus(int id) async {
    try {
      final response = await _repo.deleteProjectStatus(id);
      if (response.status == true) {
        CustomToast.showInfo(title: "تم", description: response.message);
        getAllProjectStatus();
      } else {
        CustomToast.showInfo(title: "خطأ", description: response.message);
      }
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }
}
