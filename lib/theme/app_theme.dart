import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Cairo',
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightOnPrimary,
        secondary: AppColors.lightSecondary,
        onSecondary: AppColors.lightOnSecondary,
        tertiary: AppColors.lightTertiary,
        onTertiary: AppColors.lightOnTertiary,
        error: AppColors.lightError,
        onError: AppColors.lightOnError,
        background: AppColors.lightBackground,
        onBackground: AppColors.lightOnSurface,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
        outline: AppColors.lightOutline,
        outlineVariant: AppColors.lightOutlineVariant,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnSurface,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnSurface,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnSurface,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnSurface,
        ),
        displayLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnSurface,
        ),
        displayMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnSurface,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnSurface,
        ),
        headlineLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnSurface,
        ),
        headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnSurface,
        ),
        headlineSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnSurface,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'Cairo',
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkOnPrimary,
        secondary: AppColors.darkSecondary,
        onSecondary: AppColors.darkOnSecondary,
        tertiary: AppColors.darkTertiary,
        onTertiary: AppColors.darkOnTertiary,
        error: AppColors.darkError,
        onError: AppColors.darkOnError,
        background: AppColors.darkBackground,
        onBackground: AppColors.darkOnSurface,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        outline: AppColors.darkOutline,
        outlineVariant: AppColors.darkOutlineVariant,
      ),
    );
  }
}
