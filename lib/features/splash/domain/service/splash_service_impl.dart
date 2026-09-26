import 'package:startup_repo/core/api/model/api_result.dart';
import 'package:startup_repo/core/helper/json_map_reader.dart';

import '../../data/model/config_model.dart';
import '../../data/repository/splash_repo.dart';
import 'splash_service.dart';

class SplashServiceImpl implements SplashService {
  final SplashRepo splashRepo;
  SplashServiceImpl({required this.splashRepo});

  @override
  Future<ConfigModel?> getConfig() async {
    final ApiResult<Object?> result = await splashRepo.getConfig();
    if (result case Success<Object?>(data: final Object? data)) {
      return ConfigModel.fromJson(readJsonMap(data));
    }
    return null;
  }

  @override
  Future<bool> saveFirstTime() => splashRepo.saveFirstTime();

  @override
  bool getFirstTime() => splashRepo.getFirstTime();
}
