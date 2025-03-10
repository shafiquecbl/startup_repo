import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/api/api_client_interface.dart';
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
    if (!prefs.containsKey(AppConstants.theme)) {
      prefs.setString(AppConstants.theme, 'system');
    }

    // check if the theme, language and country code are set
    if (!prefs.containsKey(AppConstants.countryCode)) {
      prefs.setString(AppConstants.countryCode, AppConstants.languages[0].countryCode);
    }

    // check if the theme, language and country code are set
    if (!prefs.containsKey(AppConstants.languageCode)) {
      prefs.setString(AppConstants.languageCode, AppConstants.languages[0].languageCode);
    }
  }

  @override
  Future<Response?> getConfig() async => await apiClient.get(AppConstants.configUrl);

  @override
  Future<bool> saveFirstTime() async => await prefs.setBool(AppConstants.onBoardingSkip, false);

  @override
  bool getFirstTime() => prefs.getBool(AppConstants.onBoardingSkip) ?? true;
}
