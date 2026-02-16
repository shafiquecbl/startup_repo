import 'dart:convert';
import 'package:startup_repo/core/api/api_result.dart';
import '../../data/model/config_model.dart';
import '../../data/repository/splash_repo.dart';
import 'splash_service.dart';

class SplashServiceImpl implements SplashService {
  final SplashRepo splashRepo;
  SplashServiceImpl({required this.splashRepo});

  @override
  Future<ApiResult<ConfigModel>> getConfig() async {
    final result = await splashRepo.getConfig();
    return switch (result) {
      Success(data: final response) => _parseConfig(response.body),
      Failure(:final message, :final statusCode) => Failure(message, statusCode: statusCode),
    };
  }

  ApiResult<ConfigModel> _parseConfig(String body) {
    try {
      return Success(ConfigModel.fromJson(jsonDecode(body)));
    } catch (_) {
      return const Failure('Failed to parse config');
    }
  }

  @override
  Future<bool> saveFirstTime() => splashRepo.saveFirstTime();

  @override
  bool getFirstTime() => splashRepo.getFirstTime();
}
