import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_constants.dart';
import 'theme_repo_interface.dart';

class ThemeRepo implements ThemeRepoInterface {
  final SharedPreferences prefs;
  ThemeRepo({required this.prefs});

  @override
  String loadCurrentTheme() {
    return prefs.getString(AppConstants.theme) ?? 'system';
  }

  @override
  Future<bool> saveThemeMode(String themeMode) async {
    return await prefs.setString(AppConstants.theme, themeMode);
  }
}
