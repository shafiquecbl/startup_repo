import 'package:startup_repo/imports.dart';

import 'theme_repo.dart';

class ThemeRepoImpl implements ThemeRepo {
  final SharedPreferences prefs;
  ThemeRepoImpl({required this.prefs});

  @override
  String? loadThemeMode() => prefs.getString(SharedKeys.theme);

  @override
  Future<bool> saveThemeMode(String themeMode) => prefs.setString(SharedKeys.theme, themeMode);
}
