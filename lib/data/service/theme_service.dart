import 'package:flutter/material.dart';
import 'package:startup_repo/data/repository/theme_repo_interface.dart';
import 'theme_service_interface.dart';

class ThemeService implements ThemeServiceInterface {
  final ThemeRepoInterface themeRepo;
  ThemeService({required this.themeRepo});

  @override
  Future<ThemeMode> loadCurrentTheme() async {
    return themeRepo.loadCurrentTheme();
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    await themeRepo.saveThemeMode(themeMode);
  }
}
