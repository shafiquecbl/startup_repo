import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_constants.dart';
import 'theme_repo_interface.dart';

class ThemeRepo implements ThemeRepoInterface {
  final SharedPreferences prefs;
  ThemeRepo({required this.prefs});

  @override
  Future<ThemeMode> loadCurrentTheme() async {
    String? data;
    try {
      data = prefs.getString(AppConstants.theme);
    } catch (e) {
      data = 'system';
    }
    if (data == null || data == 'system') {
      return ThemeMode.system;
    } else if (data == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
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
    await prefs.setString(AppConstants.theme, mode);
  }
}
