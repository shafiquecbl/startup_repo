import '../../data/model/config_model.dart';

abstract class SplashService {
  Future<ConfigModel> getConfig();
  Future<bool> saveFirstTime();
  bool getFirstTime();
}
