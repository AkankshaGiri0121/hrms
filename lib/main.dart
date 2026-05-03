import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/utils/responsive.dart';
import 'features/splash/view/splash_screen.dart';

/**
 Yash This side.
 Commiting 1st -> 
 on - main
 done - 03 May 2026
 */
void main() {
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeCtrl = Get.find();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeCtrl.currentThemeMode,
        builder: (context, child) {
          Responsive.init(context);
          return child!;
        },
        home: const SplashScreen(),
      ),
    );
  }
}
