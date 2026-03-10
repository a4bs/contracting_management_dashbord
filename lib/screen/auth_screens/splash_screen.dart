import 'dart:ui';
import 'package:contracting_management_dashbord/constant/app_route.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/theme/app_image.dart';
import 'package:contracting_management_dashbord/tool/user_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      await UserTool.getUser().token == null
          ? Get.offAndToNamed(AppRoute.login)
          : Get.offAndToNamed(AppRoute.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.darkBackground,
                  Color(0xFF1A1F25), // Slightly darker shade for depth
                ],
              ),
            ),
          ),

          // 2. Ambient Glows (Top Left)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.lightPrimary.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 3. Ambient Glows (Bottom Right)
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.lightPrimary.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 4. Blur Effect for smoothness
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.transparent),
          ),

          // 5. Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppImage.logoImage, width: 250, height: 250)
                    .animate()
                    .fade(duration: 800.ms)
                    .scale(
                      delay: 300.ms,
                      duration: 600.ms,
                      curve: Curves.easeOutBack,
                    ),

                const SizedBox(height: 20),

                const Text(
                      "بورسيبا للادارة الماليه",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightPrimary, // Gold color
                        fontFamily: 'Cairo', // Ensuring Cairo font is used
                      ),
                    )
                    .animate()
                    .fade(delay: 500.ms, duration: 800.ms)
                    .moveY(
                      begin: 20,
                      end: 0,
                      delay: 500.ms,
                      duration: 800.ms,
                      curve: Curves.easeOut,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
