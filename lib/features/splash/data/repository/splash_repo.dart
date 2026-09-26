import 'package:startup_repo/core/api/model/api_result.dart';

abstract class SplashRepo {
  Future<ApiResult<Object?>> getConfig();
  Future<bool> saveFirstTime();
  bool getFirstTime();
}
