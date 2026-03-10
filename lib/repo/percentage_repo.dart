import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';

class PercentageRepo {
  Future<ResponseModel> getAllPercentages() async {
    final response = await DioNetwork.get(path: AppApi.percentage.percentages);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getPercentageById(int id) async {
    final response = await DioNetwork.get(path: AppApi.percentage.one(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addPercentage(data) async {
    final response = await DioNetwork.post(
      path: AppApi.percentage.percentages,
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> updatePercentage(int id, data) async {
    final response = await DioNetwork.put(
      path: AppApi.percentage.update(id),
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> deletePercentage(int id) async {
    final response = await DioNetwork.delete(
      path: AppApi.percentage.delete(id),
    );
    return ResponseModel.fromJson(response.data);
  }
}
