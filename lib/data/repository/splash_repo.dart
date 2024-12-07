import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_constants.dart';
import '../api/api_client_interface.dart';
import 'splash_repo_interface.dart';

class SplashRepo implements SplashRepoInterface {
  final ApiClientInterface apiClient;
  final SharedPreferences prefs;
  SplashRepo({
    required this.prefs,
    required this.apiClient,
  });

  @override
  void initSharedData() {
    // check if the theme, language and country code are set
    if (!prefs.containsKey(AppConstants.THEME)) {
      prefs.setString(AppConstants.THEME, 'system');
    }

    // check if the theme, language and country code are set
    if (!prefs.containsKey(AppConstants.COUNTRY_CODE)) {
      prefs.setString(AppConstants.COUNTRY_CODE, AppConstants.languages[0].countryCode);
    }

    // check if the theme, language and country code are set
    if (!prefs.containsKey(AppConstants.LANGUAGE_CODE)) {
      prefs.setString(AppConstants.LANGUAGE_CODE, AppConstants.languages[0].languageCode);
    }
  }

  @override
  Future<Response?> getConfig() async => await apiClient.get(AppConstants.CONFIG_URL);

  @override
  Future<bool> saveFirstTime() async => await prefs.setBool(AppConstants.ON_BOARDING_SKIP, false);

  @override
  bool getFirstTime() => prefs.getBool(AppConstants.ON_BOARDING_SKIP) ?? true;
}
