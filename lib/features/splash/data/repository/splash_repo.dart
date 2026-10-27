import 'package:startup_repo/imports.dart';

abstract class SplashRepo {
  Future<ApiResult<Object?>> getConfig();
  Future<bool> saveFirstTime();
  bool getFirstTime();
}
