import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';

class CustomerRepo {
  Future<ResponseModel> getAllCustomers() async {
    final response = await DioNetwork.get(path: AppApi.customer.customers);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getCustomerByFilter(dynamic filter) async {
    final response = await DioNetwork.get(
      path: AppApi.customer.customers,
      queryParameters: Map<String, dynamic>.from(filter.toJson()),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getCustomerById(id) async {
    final response = await DioNetwork.get(path: AppApi.customer.one(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addCustomer(data) async {
    final response = await DioNetwork.post(
      path: AppApi.customer.customers,
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> updateCustomer(id, data) async {
    final response = await DioNetwork.put(
      path: AppApi.customer.update(id),
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> uploadCustomerFile(data) async {
    final response = await DioNetwork.post(
      path: AppApi.customer.uploadFile,
      data: data, // Typically FormData
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> deleteCustomer(id) async {
    final response = await DioNetwork.delete(path: AppApi.customer.one(id));
    return ResponseModel.fromJson(response.data);
  }
}
