abstract class ThemeRepo {
  String? loadThemeMode();
  Future<bool> saveThemeMode(String themeMode);
}
