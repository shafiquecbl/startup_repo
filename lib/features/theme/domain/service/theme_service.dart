import 'package:flutter/material.dart';
import 'package:startup_repo/features/theme/data/repository/theme_repo_interface.dart';
import 'theme_service_interface.dart';

class ThemeService implements ThemeServiceInterface {
  final ThemeRepoInterface themeRepo;
  ThemeService({required this.themeRepo});

  @override
  ThemeMode loadCurrentTheme() {
    String data = themeRepo.loadCurrentTheme();
    if (data == 'system') {
      return ThemeMode.system;
    } else if (data == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  @override
  Future<bool> saveThemeMode(ThemeMode themeMode) async {
    String mode = 'system';
    switch (themeMode) {
      case ThemeMode.light:
        mode = 'light';
        break;
      case ThemeMode.dark:
        mode = 'dark';
        break;
      default:
        mode = 'system';
    }
    return await themeRepo.saveThemeMode(mode);
  }
}
