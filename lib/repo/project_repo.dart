import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/model/project/project_model_filter.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';

class ProjectRepo {
  // Projects
  Future<ResponseModel> getAllProjects() async {
    final response = await DioNetwork.get(path: AppApi.project.projects);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getProjectById(String id) async {
    final response = await DioNetwork.get(path: AppApi.project.project(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addProject(data) async {
    final response = await DioNetwork.post(
      path: AppApi.project.projects,
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> updateProject(String id, data) async {
    final response = await DioNetwork.put(
      path: AppApi.project.updateProject(id),
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> deleteProject(String id) async {
    final response = await DioNetwork.delete(
      path: AppApi.project.deleteProject(id),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getProjectByFilter(ProjectModelFilter filter) async {
    final response = await DioNetwork.get(
      path: AppApi.project.getProjectByFilter(),
      queryParameters: Map<String, dynamic>.from(filter.toJson()),
    );
    return ResponseModel.fromJson(response.data);
  }

  // Project Types
  Future<ResponseModel> getAllProjectTypes() async {
    final response = await DioNetwork.get(path: AppApi.project.projectTypes);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addProjectType(data) async {
    final response = await DioNetwork.post(
      path: AppApi.project.projectTypes,
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> updateProjectType(String id, data) async {
    final response = await DioNetwork.put(
      path: AppApi.project.updateProjectType(id),
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> deleteProjectType(String id) async {
    final response = await DioNetwork.delete(
      path: AppApi.project.deleteProjectType(id),
    );
    return ResponseModel.fromJson(response.data);
  }
}
