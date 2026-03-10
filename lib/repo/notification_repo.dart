import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';

class NotificationRepo {
  Future<ResponseModel> getAllNotifications() async {
    final response = await DioNetwork.get(path: AppApi.notification.all);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getUserNotifications({int? perPage}) async {
    final response = await DioNetwork.get(
      path: AppApi.notification.userNotifications,
      queryParameters: perPage != null ? {'per_page': perPage} : null,
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getUnreadCount() async {
    final response = await DioNetwork.get(
      path: AppApi.notification.unreadCount,
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> makeAsRead(dynamic notificationId) async {
    final response = await DioNetwork.put(
      path: AppApi.notification.makeAsRead,
      data: {'notification_id': notificationId.toString()},
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> makeAsReadAllBonds() async {
    final response = await DioNetwork.put(
      path: AppApi.notification.makeAsReadAllBonds,
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> deleteNotification(dynamic id) async {
    final response = await DioNetwork.delete(
      path: AppApi.notification.delete(id.toString()),
    );
    return ResponseModel.fromJson(response.data);
  }
}
