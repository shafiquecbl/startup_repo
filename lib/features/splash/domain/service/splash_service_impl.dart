import 'dart:convert';
import 'package:http/http.dart';
import '../../data/model/config_model.dart';
import '../../data/repository/splash_repo.dart';
import 'splash_service.dart';

class SplashServiceImpl implements SplashService {
  final SplashRepo splashRepo;
  SplashServiceImpl({required this.splashRepo});

  @override
  Future<ConfigModel> getConfig() async {
    Response? response = await splashRepo.getConfig();
    if (response != null) {
      return ConfigModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load settings");
    }
  }

  @override
  Future<bool> saveFirstTime() {
    return splashRepo.saveFirstTime();
  }

  @override
  bool getFirstTime() {
    return splashRepo.getFirstTime();
  }
}
