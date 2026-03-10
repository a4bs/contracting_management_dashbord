import 'package:contracting_management_dashbord/constant/app_route.dart';
import 'package:contracting_management_dashbord/services/local_storge.dart';

import 'package:contracting_management_dashbord/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:toastification/toastification.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:contracting_management_dashbord/services/initial_binding.dart';
import 'dart:io' show Platform;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('نظام بورسيبا');
    setWindowMinSize(const Size(800, 800));
  }

  await LocalStorageService.init();
  InitialBinding().dependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        debugShowCheckedModeBanner: false,
        title: 'بورسيبا',
        locale: const Locale('ar', 'IQ'),
        theme: AppTheme.lightTheme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        getPages: AppRoute.routes,
        initialRoute: AppRoute.splash,
      ),
    );
  }
}
