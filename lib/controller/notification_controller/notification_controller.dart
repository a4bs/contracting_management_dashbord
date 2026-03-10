import 'package:contracting_management_dashbord/model/notification/notification_model.dart';
import 'package:contracting_management_dashbord/model/pagnation_model.dart';
import 'package:contracting_management_dashbord/repo/notification_repo.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final NotificationRepo _repo = NotificationRepo();

  var notifications = <NotificationModel>[].obs;
  var unreadCount = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUserNotifications();
    getUnreadCount();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getAllNotifications() async {
    isLoading.value = true;
    final response = await _repo.getAllNotifications();
    if (response.status == true) {
      // Handle both paginated and non-paginated responses
      if (response.data is Map<String, dynamic> &&
          (response.data as Map<String, dynamic>).containsKey('data')) {
        // Paginated response
        PaginationModel paginationModel = PaginationModel.fromJson(
          response.data,
        );
        notifications.value = (paginationModel.data)
            .map((e) => NotificationModel.fromJson(e))
            .toList();
      } else if (response.data is List) {
        // Direct list response
        notifications.value = (response.data as List)
            .map((e) => NotificationModel.fromJson(e))
            .toList();
      } else {
        notifications.value = [];
      }
    } else {
      CustomToast.showInfo(
        title: "تنبيه",
        description: response.message ?? "حدث خطأ ما",
      );
    }

    isLoading.value = false;
  }

  Future<void> getUserNotifications({int? perPage}) async {
    try {
      isLoading.value = true;
      final response = await _repo.getUserNotifications(perPage: perPage);
      if (response.status == true) {
        // Handle both paginated and non-paginated responses
        if (response.data is Map<String, dynamic> &&
            (response.data as Map<String, dynamic>).containsKey('data')) {
          // Paginated response
          PaginationModel paginationModel = PaginationModel.fromJson(
            response.data,
          );
          notifications.value = (paginationModel.data)
              .map((e) => NotificationModel.fromJson(e))
              .toList();
        } else if (response.data is List) {
          // Direct list response
          notifications.value = (response.data as List)
              .map((e) => NotificationModel.fromJson(e))
              .toList();
        } else {
          notifications.value = [];
        }
      } else {
        CustomToast.showError(
          title: "تنبيه",
          description: response.message ?? "حدث خطأ ما",
        );
      }
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUnreadCount() async {
    try {
      final response = await _repo.getUnreadCount();
      if (response.status == true) {
        unreadCount.value = response.data['bond'] ?? 0;
      }
    } catch (e) {}
  }

  Future<void> makeAsRead(dynamic notificationId) async {
    try {
      final response = await _repo.makeAsRead(notificationId);
      if (response.status == true) {
        int index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          notifications[index].readAt = DateTime.now().toString();
          notifications.refresh();
          getUnreadCount();
        }
      } else {
        CustomToast.showInfo(
          title: "تنبيه",
          description: response.message ?? "حدث خطأ ما",
        );
      }
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  Future<void> makeAsReadAllBonds() async {
    try {
      final response = await _repo.makeAsReadAllBonds();
      if (response.status == true) {
        for (var n in notifications) {
          n.readAt = DateTime.now().toString();
        }
        notifications.refresh();
        unreadCount.value = 0;
        CustomToast.showSuccess(
          title: "تم",
          description: response.message ?? "تم تحديد كل الإشعارات كمقروءة",
        );
      } else {
        CustomToast.showInfo(
          title: "تنبيه",
          description: response.message ?? "حدث خطأ ما",
        );
      }
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  Future<void> deleteNotification(dynamic id) async {
    try {
      final response = await _repo.deleteNotification(id);
      if (response.status == true) {
        notifications.removeWhere((n) => n.id == id);
        getUnreadCount();
        CustomToast.showSuccess(
          title: "تم",
          description: response.message ?? "تم حذف الإشعار",
        );
      } else {
        CustomToast.showInfo(
          title: "تنبيه",
          description: response.message ?? "حدث خطأ ما",
        );
      }
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }
}
