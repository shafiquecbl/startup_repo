import 'package:flutter/material.dart';

abstract class ThemeServiceInterface {
  Future<ThemeMode> loadCurrentTheme();
  Future<void> saveThemeMode(ThemeMode themeMode);
}
