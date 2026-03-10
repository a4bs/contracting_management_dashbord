import 'package:contracting_management_dashbord/controller/notification_receivers_controller/notification_receivers_controller.dart';
import 'package:contracting_management_dashbord/controller/user_controller/user_controller.dart';
import 'package:contracting_management_dashbord/model/notification_receivers/notification_receivers_key.dart';
import 'package:contracting_management_dashbord/widget/futuer_pagnation_page_widget.dart';
import 'package:contracting_management_dashbord/widget/select_drop_don.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class NotifictionUsersSettingScreen
    extends GetView<NotificationReceiversController> {
  NotifictionUsersSettingScreen({super.key});
  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light gray background
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Container (Matching BoundIndexScreen style)
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: isMobile ? 6 : 12,
                vertical: isMobile ? 6 : 10,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(isMobile ? 10 : 14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "مستخدمي التنبيهات",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const Spacer(),
                  // Add Button in Header
                  ElevatedButton.icon(
                    onPressed: () => dialogAddReceiver(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text(
                      "إضافة",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FutuerPagnationPageWidget(
                  handelData: (page, limit) {
                    return controller.getAllReceivers();
                  },
                  cardInfo: (item, index) {
                    final String name = item.user?.fullName ?? "مستخدم";
                    final String firstChar = name.isNotEmpty
                        ? name[0].toUpperCase()
                        : "?";
                    final bool isEnabled = item.isEnabled ?? false;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.withOpacity(0.1)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Avatar
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                firstChar,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // User Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: 'Cairo',
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isEnabled
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      isEnabled ? "مفعل" : "غير مفعل",
                                      style: TextStyle(
                                        color: isEnabled
                                            ? Colors.green[700]
                                            : Colors.red[700],
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Action Switch
                            Transform.scale(
                              scale: 0.8,
                              child: Switch.adaptive(
                                value: isEnabled,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (value) {
                                  controller.updateReceiver(
                                    id: item.id!,
                                    isEnabled: value ? 1 : 0,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  controller: controller.pageDataController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  dialogAddReceiver() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: FormBuilder(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          Get.context!,
                        ).primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_add_rounded,
                        color: Theme.of(Get.context!).primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "إضافة مستخدم جديد",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        color: Theme.of(Get.context!).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SelectDropDon(
                  name: NotificationReceiversAddKey.userId,
                  label: "اختر المستخدم",
                  onTap: () async {
                    return await userController.getAllUsers();
                  },
                  cardInfo: (item) => DropdownMenuEntry(
                    enabled:
                        controller.pageDataController.items
                            .map((e) => e.userId)
                            .contains(item.id)
                        ? false
                        : true,
                    value: item.id,
                    label: item.fullName!,
                    labelWidget: Text(
                      item.fullName!,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color:
                            controller.pageDataController.items
                                .map((e) => e.userId)
                                .contains(item.id)
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: FormBuilderSwitch(
                    name: NotificationReceiversAddKey.isEnabled,
                    title: const Text(
                      'تمكين التنبيهات للمستخدم',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    activeColor: Theme.of(Get.context!).primaryColor,
                    decoration: const InputDecoration(border: InputBorder.none),
                    initialValue: true,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(Get.context!).primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (controller.formKey.currentState!.saveAndValidate()) {
                      controller.addReceiver(
                        controller.formKey.currentState!.instantValue,
                      );
                    }
                  },
                  child: const Text(
                    'تأكيد الإضافة',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
