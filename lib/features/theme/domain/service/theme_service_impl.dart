import 'package:flutter/material.dart';

import '../../data/repository/theme_repo.dart';
import 'theme_service.dart';

class ThemeServiceImpl implements ThemeService {
  ThemeServiceImpl({required this.themeRepo});

  final ThemeRepo themeRepo;

  @override
  ThemeMode loadCurrentTheme() {
    final String? savedTheme = themeRepo.loadThemeMode();
    return ThemeMode.values.firstWhere(
      (ThemeMode themeMode) => themeMode.name == savedTheme,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Future<bool> saveThemeMode(ThemeMode themeMode) => themeRepo.saveThemeMode(themeMode.name);
}
