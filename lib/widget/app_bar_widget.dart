import 'package:contracting_management_dashbord/controller/auth_controller/auth_controller.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/widget/dilog_check_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A fully styled custom app bar widget with multiple variants
/// Supports gradient backgrounds, custom actions, and responsive design
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final bool useGradient;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final bool showShadow;

  CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.bottom,
    this.elevation = 0,
    this.useGradient = true,
    this.backgroundColor,
    this.titleColor,
    this.titleFontSize,
    this.titleFontWeight,
    this.showShadow = true,
  });
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: useGradient
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [AppColors.darkSurface, AppColors.darkSurfaceBright]
                    : [
                        AppColors.lightPrimary,
                        AppColors.lightPrimary.withOpacity(0.85),
                      ],
              )
            : null,
        color: useGradient
            ? null
            : (backgroundColor ?? theme.colorScheme.primary),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color:
                      (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                          .withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: titleFontSize ?? 20,
            fontWeight: titleFontWeight ?? FontWeight.bold,
            color: titleColor ?? AppColors.lightOnPrimary,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: centerTitle,
        backgroundColor: Colors.transparent,
        elevation: elevation,
        leading:
            leading ??
            (showBackButton && Navigator.of(context).canPop()
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: titleColor ?? AppColors.lightOnPrimary,
                    ),
                    onPressed:
                        onBackPressed ?? () => Navigator.of(context).pop(),
                    tooltip: 'رجوع',
                  )
                : null),
        actions: [
          ...actions ?? [],

          IconButton(
            onPressed: () {
              showConfirmationDialog(
                title: "تسجيل الخروج",
                message: "هل انت متاكد من تسجيل الخروج",
                onConfirm: () async {
                  authController.logout();
                },
              );
            },
            icon: const Icon(
              Icons.door_sliding_sharp,
              color: Colors.deepOrangeAccent,
            ),
          ),
        ],
        bottom: bottom,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}

/// A modern app bar with search functionality
class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String searchHint;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchTap;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const SearchAppBar({
    super.key,
    required this.title,
    this.searchHint = 'بحث...',
    this.onSearchChanged,
    this.onSearchTap,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.darkSurface, AppColors.darkSurfaceBright]
              : [
                  AppColors.lightPrimary,
                  AppColors.lightPrimary.withOpacity(0.85),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                .withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.lightOnPrimary,
          ),
        ),
        centerTitle: true,
        leading: showBackButton && Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.lightOnPrimary,
                ),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              )
            : null,
        actions: actions,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: onSearchChanged,
                onTap: onSearchTap,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: AppColors.lightOnSurface,
                ),
                decoration: InputDecoration(
                  hintText: searchHint,
                  hintStyle: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    color: AppColors.lightOutline,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.lightPrimary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 60);
}

/// A minimal flat app bar without gradient
class FlatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;

  const FlatAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      elevation: 0,
      leading:
          leading ??
          (showBackButton && Navigator.of(context).canPop()
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// A compact app bar with icon and title
class CompactAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? icon;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? iconColor;

  const CompactAppBar({
    super.key,
    required this.title,
    this.icon,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.darkSurface, AppColors.darkSurfaceBright]
              : [
                  AppColors.lightPrimary,
                  AppColors.lightPrimary.withOpacity(0.85),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                .withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: iconColor ?? AppColors.lightOnPrimary,
                size: 24,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.lightOnPrimary,
              ),
            ),
          ],
        ),
        leading: showBackButton && Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.lightOnPrimary,
                ),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              )
            : null,
        actions: [
          ...actions ?? [],
          Obx(
            () => AppBarActions.notification(onPressed: () {}, badgeCount: 3),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Common action buttons for app bars
class AppBarActions {
  /// Notification icon button
  static Widget notification({
    required VoidCallback onPressed,
    int? badgeCount,
    Color? iconColor,
  }) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: iconColor ?? AppColors.lightOnPrimary,
          ),
          onPressed: onPressed,
          tooltip: 'الإشعارات',
        ),
        if (badgeCount != null && badgeCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.lightError,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Center(
                child: Text(
                  badgeCount > 99 ? '99+' : badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Settings icon button
  static Widget settings({required VoidCallback onPressed, Color? iconColor}) {
    return IconButton(
      icon: Icon(
        Icons.settings_outlined,
        color: iconColor ?? AppColors.lightOnPrimary,
      ),
      onPressed: onPressed,
      tooltip: 'الإعدادات',
    );
  }

  /// Filter icon button
  static Widget filter({
    required VoidCallback onPressed,
    bool isActive = false,
    Color? iconColor,
  }) {
    return IconButton(
      icon: Icon(
        isActive ? Icons.filter_alt : Icons.filter_alt_outlined,
        color: iconColor ?? AppColors.lightOnPrimary,
      ),
      onPressed: onPressed,
      tooltip: 'تصفية',
    );
  }

  /// More options menu button
  static Widget moreOptions({
    required BuildContext context,
    required List<PopupMenuEntry> menuItems,
    Color? iconColor,
  }) {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert_rounded,
        color: iconColor ?? AppColors.lightOnPrimary,
      ),
      tooltip: 'المزيد',
      itemBuilder: (context) => menuItems,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  /// Add/Create icon button
  static Widget add({required VoidCallback onPressed, Color? iconColor}) {
    return IconButton(
      icon: Icon(
        Icons.add_circle_outline_rounded,
        color: iconColor ?? AppColors.lightOnPrimary,
      ),
      onPressed: onPressed,
      tooltip: 'إضافة',
    );
  }

  /// Search icon button
  static Widget search({required VoidCallback onPressed, Color? iconColor}) {
    return IconButton(
      icon: Icon(
        Icons.search_rounded,
        color: iconColor ?? AppColors.lightOnPrimary,
      ),
      onPressed: onPressed,
      tooltip: 'بحث',
    );
  }

  /// Refresh icon button
  static Widget refresh({required VoidCallback onPressed, Color? iconColor}) {
    return IconButton(
      icon: Icon(
        Icons.refresh_rounded,
        color: iconColor ?? AppColors.lightOnPrimary,
      ),
      onPressed: onPressed,
      tooltip: 'تحديث',
    );
  }
}
