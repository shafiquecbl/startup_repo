import '../model/response/config_model.dart';

abstract class SplashServiceInterface {
  void initSharedData();
  Future<ConfigModel> getConfig();
  Future<bool> saveFirstTime();
  bool getFirstTime();
}
