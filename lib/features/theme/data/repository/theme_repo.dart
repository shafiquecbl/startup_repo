import 'package:flutter/material.dart';

abstract class ThemeRepo {
  ThemeMode loadCurrentTheme();
  Future<bool> saveThemeMode(ThemeMode themeMode);
}
