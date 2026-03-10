import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';

class NotificationReceiversRepo {
  Future<ResponseModel> getAllReceivers() async {
    final response = await DioNetwork.get(
      path: AppApi.notificationReceivers.all,
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getReceiver(dynamic id) async {
    final response = await DioNetwork.get(
      path: AppApi.notificationReceivers.one(id),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addReceiver(Map<String, dynamic> data) async {
    final response = await DioNetwork.post(
      path: AppApi.notificationReceivers.all,
      queryParameters: data,
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> updateReceiver({
    required dynamic id,
    required int isEnabled,
  }) async {
    final response = await DioNetwork.put(
      path: AppApi.notificationReceivers.update(id),
      queryParameters: {'is_enabled': isEnabled},
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> deleteReceiver(dynamic id) async {
    final response = await DioNetwork.delete(
      path: AppApi.notificationReceivers.delete(id),
    );
    return ResponseModel.fromJson(response.data);
  }
}
