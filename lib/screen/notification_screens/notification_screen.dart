import 'package:contracting_management_dashbord/controller/notification_controller/notification_controller.dart';
import 'package:contracting_management_dashbord/model/notification/notification_model.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الإشعارات',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => controller.makeAsReadAllBonds(),
            icon: const Icon(Icons.done_all),
            tooltip: 'تحديد الكل كمقروء',
          ),
          IconButton(
            onPressed: () => controller.getUserNotifications(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'لا توجد إشعارات حالياً',
                  style: TextStyle(fontFamily: 'Cairo', color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.getUserNotifications(),
          child: ListView.builder(
            itemCount: controller.notifications.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return _NotificationItem(notification: notification);
            },
          ),
        );
      }),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();
    final isRead = notification.readAt != null;
    final notificationData = notification.data;
    final title = notificationData?.message ?? 'إشعار جديد';
    final body = _buildNotificationBody(notificationData);
    final createdAt = notification.createdAt != null
        ? DateFormat(
            'yyyy/MM/dd HH:mm',
          ).format(DateTime.parse(notification.createdAt!))
        : '';

    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => controller.deleteNotification(notification.id),
      child: InkWell(
        onTap: () {
          if (!isRead) {
            controller.makeAsRead(notification.id);
          }
          // Optionally handle navigation based on notification type
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isRead
                ? Colors.white
                : AppColors.lightPrimary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isRead
                  ? Colors.grey[200]!
                  : AppColors.lightPrimary.withOpacity(0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isRead
                      ? Colors.grey[100]
                      : AppColors.lightPrimary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications,
                  color: isRead ? Colors.grey : AppColors.lightPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          createdAt,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: Colors.grey[800],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (!isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 8, right: 8),
                  decoration: const BoxDecoration(
                    color: AppColors.lightPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildNotificationBody(NotificationData? data) {
    if (data == null) return '';

    final buffer = StringBuffer();

    // Add bond information if available
    if (data.bond != null) {
      buffer.write('المبلغ: ${data.bond!.amount?.toString() ?? 'غير محدد'}');

      if (data.bond!.title != null) {
        buffer.write(' - ${data.bond!.title}');
      }

      if (data.bond!.bondType?.name != null) {
        buffer.write('\nنوع السند: ${data.bond!.bondType!.name}');
      }

      if (data.bond!.box?.name != null) {
        buffer.write('\nالصندوق: ${data.bond!.box!.name}');
      }
    }

    // Add sender information
    if (data.sender?.fullName != null) {
      buffer.write(
        '${buffer.isNotEmpty ? '\n' : ''}المرسل: ${data.sender!.fullName}',
      );
    }

    return buffer.toString();
  }
}
