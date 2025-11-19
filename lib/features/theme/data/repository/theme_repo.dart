abstract class ThemeRepo {
  String loadCurrentTheme();
  Future<bool> saveThemeMode(String themeMode);
}
