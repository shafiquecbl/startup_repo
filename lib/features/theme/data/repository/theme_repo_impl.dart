import 'package:startup_repo/imports.dart';
import 'theme_repo.dart';

class ThemeRepoImpl implements ThemeRepo {
  final SharedPreferences prefs;
  ThemeRepoImpl({required this.prefs});

  @override
  ThemeMode loadCurrentTheme() {
    final value = prefs.getString(SharedKeys.theme) ?? 'system';
    return ThemeMode.values.byName(value);
  }

  @override
  Future<bool> saveThemeMode(ThemeMode themeMode) async {
    return await prefs.setString(SharedKeys.theme, themeMode.name);
  }
}
