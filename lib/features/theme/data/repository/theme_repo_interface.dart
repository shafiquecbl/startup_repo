abstract class ThemeRepoInterface {
  String loadCurrentTheme();
  Future<bool> saveThemeMode(String themeMode);
}
