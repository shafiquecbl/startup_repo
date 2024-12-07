import 'package:flutter/material.dart';

abstract class ThemeRepoInterface {
  Future<ThemeMode> loadCurrentTheme();
  Future<void> saveThemeMode(ThemeMode themeMode);
}
