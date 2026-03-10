import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';

class ProjectStatusRepo {
  Future<ResponseModel> getAllProjectStatus() async {
    final response = await DioNetwork.get(path: AppApi.projectStatus.all);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getProjectStatusById(int id) async {
    final response = await DioNetwork.get(path: AppApi.projectStatus.one(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addProjectStatus({
    required String name,
    required int isEnable,
  }) async {
    final response = await DioNetwork.post(
      path: AppApi.projectStatus.add(name: name, isEnable: isEnable),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> updateProjectStatus({
    required int id,
    required String name,
    required int isEnable,
  }) async {
    final response = await DioNetwork.put(
      path: AppApi.projectStatus.update(id, name: name, isEnable: isEnable),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> deleteProjectStatus(int id) async {
    final response = await DioNetwork.delete(
      path: AppApi.projectStatus.delete(id),
    );
    return ResponseModel.fromJson(response.data);
  }
}
