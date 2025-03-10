import 'package:flutter/material.dart';

abstract class ThemeServiceInterface {
  ThemeMode loadCurrentTheme();
  Future<bool> saveThemeMode(ThemeMode themeMode);
}
