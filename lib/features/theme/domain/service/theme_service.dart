import 'package:flutter/material.dart';

abstract class ThemeService {
  ThemeMode loadCurrentTheme();
  Future<bool> saveThemeMode(ThemeMode themeMode);
}
