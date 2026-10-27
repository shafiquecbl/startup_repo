import 'package:startup_repo/imports.dart';

import 'splash_repo.dart';

class SplashRepoImpl implements SplashRepo {
  final ApiClient apiClient;
  final SharedPreferences prefs;
  SplashRepoImpl({required this.prefs, required this.apiClient});

  @override
  Future<ApiResult<Object?>> getConfig() =>
      apiClient.execute(const ApiRequest(method: ApiMethod.get, path: Endpoints.config));

  @override
  Future<bool> saveFirstTime() async => await prefs.setBool(SharedKeys.onBoardingSkip, false);

  @override
  bool getFirstTime() => prefs.getBool(SharedKeys.onBoardingSkip) ?? true;
}
