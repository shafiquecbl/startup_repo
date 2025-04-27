import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/service/theme_service_interface.dart';

class ThemeController extends GetxController implements GetxService {
  final ThemeServiceInterface themeService;

  ThemeController({required this.themeService}) {
    _loadCurrentTheme();
  }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void _loadCurrentTheme() async {
    _themeMode = themeService.loadCurrentTheme();
    Get.changeThemeMode(_themeMode);
    update();
  }

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    themeService.saveThemeMode(themeMode);
    Get.changeThemeMode(_themeMode);
    update();
  }

  static ThemeController get find => Get.find<ThemeController>();
}
