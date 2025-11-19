import '../../../../core/api/api_client.dart';
import '../../../../imports.dart';
import 'splash_repo.dart';

class SplashRepoImpl implements SplashRepo {
  final ApiClient apiClient;
  final SharedPreferences prefs;
  SplashRepoImpl({required this.prefs, required this.apiClient});

  @override
  Future<Response?> getConfig() async => await apiClient.get(AppConstants.configUrl);

  @override
  Future<bool> saveFirstTime() async => await prefs.setBool(SharedKeys.onBoardingSkip, false);

  @override
  bool getFirstTime() => prefs.getBool(SharedKeys.onBoardingSkip) ?? true;
}
