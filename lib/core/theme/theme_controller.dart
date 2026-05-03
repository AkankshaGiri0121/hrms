import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Manages the app's theme mode (Light, Dark, System).
/// Uses GetX for reactive state management.
class ThemeController extends GetxController {
  /// 0 = System, 1 = Light, 2 = Dark
  var themeMode = 0.obs;

  ThemeMode get currentThemeMode {
    switch (themeMode.value) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String get themeModeLabel {
    switch (themeMode.value) {
      case 1:
        return 'Light';
      case 2:
        return 'Dark';
      default:
        return 'System';
    }
  }

  void setThemeMode(int mode) {
    themeMode.value = mode;
    Get.changeThemeMode(currentThemeMode);
  }

  /// Helper to check if the current effective theme is dark
  bool get isDark {
    if (themeMode.value == 2) return true;
    if (themeMode.value == 1) return false;
    // System mode – check platform brightness
    return Get.isPlatformDarkMode;
  }
}
