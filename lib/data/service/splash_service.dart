import 'dart:convert';
import 'package:http/http.dart';
import '../model/response/config_model.dart';
import '../repository/splash_repo_interface.dart';
import 'splash_service_interface.dart';

class SplashService implements SplashServiceInterface {
  final SplashRepoInterface splashRepo;
  SplashService({required this.splashRepo});

  @override
  void initSharedData() {
    return splashRepo.initSharedData();
  }

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
