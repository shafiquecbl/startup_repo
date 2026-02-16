import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repository/theme_repo.dart';

class ThemeController extends GetxController implements GetxService {
  final ThemeRepo themeRepo;

  ThemeController({required this.themeRepo}) {
    _loadCurrentTheme();
  }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void _loadCurrentTheme() {
    _themeMode = themeRepo.loadCurrentTheme();
    Get.changeThemeMode(_themeMode);
    update();
  }

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    themeRepo.saveThemeMode(themeMode);
    Get.changeThemeMode(_themeMode);
    update();
  }

  static ThemeController get find => Get.find<ThemeController>();
}
