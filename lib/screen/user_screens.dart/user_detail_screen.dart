import 'package:contracting_management_dashbord/controller/user_controller/user_controller.dart';
import 'package:contracting_management_dashbord/model/user/user_model.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/widget/app_bar_widget.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';

import 'package:flutter/material.dart';
import 'package:contracting_management_dashbord/constant/enum/rol_enum.dart';
import 'package:get/get.dart';

class UserDetailScreen extends StatefulWidget {
  final UserModel user;
  const UserDetailScreen({super.key, required this.user});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final UserController controller = Get.find<UserController>();
  final RxString searchAvailable = ''.obs;
  final RxString searchAssigned = ''.obs;

  @override
  void initState() {
    super.initState();
    // Fetch permissions for this user specifically when screen opens
    if (widget.user.id != null) {
      controller.getUserPermissions(widget.user.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _buildMobileLayout(context);
        }
        return _buildDesktopLayout(context);
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "تفاصيل المستخدم"),
      body: _buildUnifiedPermissionList(
        searchController: searchAvailable,
        allPermissions: controller.permissionsList,
        userPermissions: controller.userPermissionsList,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: CustomButton(
            text: "حفظ التغييرات",
            backgroundColor: AppColors.lightPrimary,
            onPressed: () async {
              if (widget.user.id != null) {
                await controller.saveUserPermissions(widget.user.id!);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUnifiedPermissionList({
    required RxString searchController,
    required RxList<PermissionModel> allPermissions,
    required RxList<PermissionModel> userPermissions,
  }) {
    return Container(
      color: const Color(0xFFF1F5F9),
      child: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "بحث في الصلاحيات...",
                hintStyle: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 22,
                  color: AppColors.lightPrimary,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.lightPrimary,
                    width: 1.5,
                  ),
                ),
                isDense: true,
              ),
              onChanged: (val) => searchController.value = val,
            ),
          ),

          // Permissions List
          Expanded(
            child: Obx(() {
              // Filter
              var filtered = allPermissions.toList();
              if (searchController.value.isNotEmpty) {
                filtered = filtered
                    .where(
                      (p) => (p.displayName ?? p.name ?? '')
                          .toLowerCase()
                          .contains(searchController.value.toLowerCase()),
                    )
                    .toList();
              }

              // Group
              final Map<PermissionCategoryEnum?, List<PermissionModel>>
              grouped = {};
              for (var item in filtered) {
                final permEnum = PermeationEnum.fromModel(item);
                final category = permEnum?.category;
                grouped.putIfAbsent(category, () => []).add(item);
              }

              if (filtered.isEmpty) {
                return Center(
                  child: Text(
                    "لا توجد نتائج",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontFamily: 'Cairo',
                    ),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  ...[...PermissionCategoryEnum.values, null].map((category) {
                    final categoryItems = grouped[category];
                    if (categoryItems == null || categoryItems.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: AppColors.lightPrimary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                category?.displayName ?? 'غير مصنف',
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: categoryItems.map((item) {
                              final isChecked = userPermissions.any(
                                (p) =>
                                    p.id == item.id ||
                                    (p.id == null && p.name == item.name),
                              );

                              return Column(
                                children: [
                                  CheckboxListTile(
                                    value: isChecked,
                                    activeColor: AppColors.lightPrimary,
                                    title: Text(
                                      item.displayName ?? item.name ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    onChanged: (bool? value) {
                                      if (value == true) {
                                        if (!isChecked) {
                                          userPermissions.add(item);
                                        }
                                      } else {
                                        userPermissions.removeWhere(
                                          (p) =>
                                              p.id == item.id ||
                                              (p.id == null &&
                                                  p.name == item.name),
                                        );
                                      }
                                    },
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  if (item != categoryItems.last)
                                    Divider(
                                      height: 1,
                                      indent: 16,
                                      endIndent: 16,
                                      color: Colors.grey[100],
                                    ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),
                  const SizedBox(height: 60),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "تفاصيل المستخدم"),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "إدارة الصلاحيات",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: AppColors.lightOnSurface,
                  ),
                ),
                CustomButton(
                  text: "حفظ التغييرات",
                  backgroundColor: AppColors.lightPrimary,
                  onPressed: () async {
                    if (widget.user.id != null) {
                      await controller.saveUserPermissions(widget.user.id!);
                    }
                  },
                ),
              ],
            ),
            const Divider(height: 32),

            // Unified List
            Expanded(
              child: _buildUnifiedPermissionList(
                searchController: searchAvailable,
                allPermissions: controller.permissionsList,
                userPermissions: controller.userPermissionsList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
