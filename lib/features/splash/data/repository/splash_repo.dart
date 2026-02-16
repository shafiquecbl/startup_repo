import 'package:startup_repo/core/api/api_result.dart';
import 'package:http/http.dart';

abstract class SplashRepo {
  Future<ApiResult<Response>> getConfig();
  Future<bool> saveFirstTime();
  bool getFirstTime();
}
