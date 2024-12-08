import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/service/theme_service_interface.dart';

class ThemeController extends GetxController implements GetxService {
  final ThemeServiceInterface themeService;

  ThemeController({required this.themeService}) {
    _loadCurrentTheme();
  }

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  void _loadCurrentTheme() async {
    _themeMode = themeService.loadCurrentTheme();
    update();
  }

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    themeService.saveThemeMode(themeMode);
    update();
  }

  static ThemeController get find => Get.find();
}
