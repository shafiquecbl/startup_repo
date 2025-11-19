import 'package:get/get.dart';
import '../../data/model/config_model.dart';
import '../../domain/service/splash_service.dart';

class SplashController extends GetxController implements GetxService {
  final SplashService settingsService;
  SplashController({required this.settingsService});

  static SplashController get find => Get.find<SplashController>();

  late ConfigModel _settingModel;
  ConfigModel get settingModel => _settingModel;

  set settingModel(ConfigModel settingModel) {
    _settingModel = settingModel;
    update();
  }

  Future<void> getConfig() async {
    _settingModel = await settingsService.getConfig();
    update();
  }

  Future<void> saveFirstTime() async => await settingsService.saveFirstTime();
  bool get isFirstTime => settingsService.getFirstTime();
}
