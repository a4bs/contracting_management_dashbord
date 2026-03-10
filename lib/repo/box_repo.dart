import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';

class BoxRepo {
  Future<ResponseModel> getAllBoxes() async {
    final response = await DioNetwork.get(path: AppApi.box.boxes);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getBoxById(id) async {
    final response = await DioNetwork.get(path: AppApi.box.one(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addBox(data) async {
    final response = await DioNetwork.post(
      path: AppApi.box.boxes,
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> updateBox(id, data) async {
    final response = await DioNetwork.put(
      path: AppApi.box.update(id),
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> filterBoxesByProject(id) async {
    final response = await DioNetwork.get(path: AppApi.box.filter(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> filterBox(filter) async {
    final response = await DioNetwork.get(
      path: AppApi.box.filterAll,
      queryParameters: Map<String, dynamic>.from(filter.toJson()),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> deleteBox(id) async {
    final response = await DioNetwork.delete(path: AppApi.box.one(id));
    return ResponseModel.fromJson(response.data);
  }
}
