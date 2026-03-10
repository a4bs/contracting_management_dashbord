import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';

class UserRepo {
  Future<ResponseModel> getAllUsers() async {
    final response = await DioNetwork.get(path: AppApi.user.all);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getUserById(id) async {
    final response = await DioNetwork.get(path: AppApi.user.one(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addUser(data) async {
    final response = await DioNetwork.post(
      path: AppApi.user.all,
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> updateUser(id, data) async {
    final response = await DioNetwork.put(
      path: AppApi.user.update(id),
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> deleteUser(id) async {
    final response = await DioNetwork.delete(path: AppApi.user.one(id));
    return ResponseModel.fromJson(response.data);
  }
}
