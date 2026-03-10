import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';

class BondRepo {
  Future<ResponseModel> getAllBonds() async {
    final response = await DioNetwork.get(path: AppApi.bond.bonds);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getBondById(id) async {
    final response = await DioNetwork.get(path: AppApi.bond.one(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addBond(data) async {
    final response = await DioNetwork.post(
      path: AppApi.bond.bonds,
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> updateBond(id, data) async {
    final response = await DioNetwork.put(
      path: AppApi.bond.update(id),
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> filterBonds(filterBond) async {
    final response = await DioNetwork.get(
      path: AppApi.bond.filter,
      queryParameters: Map<String, dynamic>.from(filterBond.toJson()),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> uploadBondFile(data) async {
    final response = await DioNetwork.post(
      path: AppApi.bond.uploadFile,
      data: data, // Typically FormData
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> deleteBond(id) async {
    final response = await DioNetwork.delete(path: AppApi.bond.one(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> convertBox(data) async {
    final response = await DioNetwork.post(
      path: AppApi.bond.convert,
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> proviteBound(id) async {
    final response = await DioNetwork.put(path: AppApi.bond.approve(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getApprovedUsers(id) async {
    final response = await DioNetwork.get(path: AppApi.bond.approvedUsers(id));
    return ResponseModel.fromJson(response.data);
  }
}
