import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';

class UnitRepo {
  Future<ResponseModel> getAllUnits() async {
    final response = await DioNetwork.get(path: AppApi.unit.units);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getUnitById(id) async {
    final response = await DioNetwork.get(path: AppApi.unit.one(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addUnit(data) async {
    final response = await DioNetwork.post(
      path: AppApi.unit.units,
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> updateUnit(id, data) async {
    final response = await DioNetwork.put(
      path: AppApi.unit.update(id),
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getUnitsByProject(id) async {
    final response = await DioNetwork.get(path: AppApi.unit.unitByProject(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getUnitsByCustomer(id) async {
    final response = await DioNetwork.get(path: AppApi.unit.unitByCustomer(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> deleteUnit(id) async {
    final response = await DioNetwork.delete(path: AppApi.unit.one(id));
    return ResponseModel.fromJson(response.data);
  }
}
