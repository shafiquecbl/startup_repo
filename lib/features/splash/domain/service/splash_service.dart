import 'package:startup_repo/core/api/api_result.dart';
import '../../data/model/config_model.dart';

abstract class SplashService {
  Future<ApiResult<ConfigModel>> getConfig();
  Future<bool> saveFirstTime();
  bool getFirstTime();
}
