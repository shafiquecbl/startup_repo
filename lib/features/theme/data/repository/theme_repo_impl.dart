import 'package:startup_repo/imports.dart';
import 'theme_repo.dart';

class ThemeRepoImpl implements ThemeRepo {
  final SharedPreferences prefs;
  ThemeRepoImpl({required this.prefs});

  @override
  String loadCurrentTheme() {
    return prefs.getString(SharedKeys.theme) ?? 'system';
  }

  @override
  Future<bool> saveThemeMode(String themeMode) async {
    return await prefs.setString(SharedKeys.theme, themeMode);
  }
}
