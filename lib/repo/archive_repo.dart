import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/model/archive/archiv_filter_model.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';

class ArchiveRepo {
  Future<ResponseModel> getAllArchives() async {
    final response = await DioNetwork.get(path: AppApi.archive.archives);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getArchiveById(id) async {
    final response = await DioNetwork.get(path: AppApi.archive.one(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addArchive(data) async {
    final response = await DioNetwork.post(
      path: AppApi.archive.archives,
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> updateArchive(id, data) async {
    final response = await DioNetwork.put(
      path: AppApi.archive.update(id),
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> deleteArchive(id) async {
    final response = await DioNetwork.delete(path: AppApi.archive.delete(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> filterArchives(ArchiveFilterModel filterData) async {
    final response = await DioNetwork.get(
      path: AppApi.archive.filter,
      queryParameters: Map<String, dynamic>.from(filterData.toJson()),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> uploadArchiveFile(data) async {
    final response = await DioNetwork.post(
      path: AppApi.archive.uploadFile,
      data: data, // Typically FormData
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getArchiveTypes() async {
    final response = await DioNetwork.get(path: AppApi.archive.getArchiveTypes);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addArchiveType(data) async {
    final response = await DioNetwork.post(
      path: AppApi.archive.getArchiveTypes,
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> updateArchiveType(id, data) async {
    final response = await DioNetwork.put(
      path: AppApi.archive.updateArchiveType(id),
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }
}
