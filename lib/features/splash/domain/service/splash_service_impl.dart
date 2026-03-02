import 'dart:convert';
import 'package:startup_repo/core/api/api_result.dart';
import '../../data/model/config_model.dart';
import '../../data/repository/splash_repo.dart';
import 'splash_service.dart';

class SplashServiceImpl implements SplashService {
  final SplashRepo splashRepo;
  SplashServiceImpl({required this.splashRepo});

  @override
  Future<ConfigModel?> getConfig() async {
    final result = await splashRepo.getConfig();
    if (result case Success(data: final response)) {
      try {
        return ConfigModel.fromJson(jsonDecode(response.body));
      } catch (_) {
        return null;
      }
    }
    return null; // Failure — API client already showed the toast
  }

  @override
  Future<bool> saveFirstTime() => splashRepo.saveFirstTime();

  @override
  bool getFirstTime() => splashRepo.getFirstTime();
}
