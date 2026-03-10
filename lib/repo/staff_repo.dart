import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';

class StaffRepo {
  Future<ResponseModel> getAllStaff() async {
    final response = await DioNetwork.get(path: AppApi.staff.all);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getStaffById(String id) async {
    final response = await DioNetwork.get(path: AppApi.staff.one(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addStaff(data) async {
    final response = await DioNetwork.post(
      path: AppApi.staff.all,
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> updateStaff(String id, data) async {
    final response = await DioNetwork.put(
      path: AppApi.staff.update(id),
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> deleteStaff(String id) async {
    final response = await DioNetwork.delete(path: AppApi.staff.delete(id));
    return ResponseModel.fromJson(response.data);
  }
}
