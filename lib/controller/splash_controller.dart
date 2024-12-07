import 'package:get/get.dart';
import '../data/model/response/config_model.dart';
import '../data/service/splash_service_interface.dart';

class SplashController extends GetxController implements GetxService {
  final SplashServiceInterface settingsService;
  SplashController({required this.settingsService});

  static SplashController get find => Get.find<SplashController>();

  late ConfigModel _settingModel;
  ConfigModel get settingModel => _settingModel;

  set settingModel(ConfigModel settingModel) {
    _settingModel = settingModel;
    update();
  }

  void initSharedData() {
    settingsService.initSharedData();
    getConfig();
  }

  Future<void> getConfig() async {
    _settingModel = await settingsService.getConfig();
    update();
  }

  Future<void> saveFirstTime() async => await settingsService.saveFirstTime();
  bool get isFirstTime => settingsService.getFirstTime();
}
