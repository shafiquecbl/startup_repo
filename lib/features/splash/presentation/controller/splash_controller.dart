import 'package:get/get.dart';
import 'package:startup_repo/core/api/api_result.dart';
import '../../data/model/config_model.dart';
import '../../domain/service/splash_service.dart';

class SplashController extends GetxController implements GetxService {
  final SplashService splashService;
  SplashController({required this.splashService});

  static SplashController get find => Get.find<SplashController>();

  ConfigModel? _settingModel;
  ConfigModel? get settingModel => _settingModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  Future<void> getConfig() async {
    isLoading = true;
    final result = await splashService.getConfig();
    if (result case Success(data: final config)) {
      _settingModel = config;
    }
    // Failure? Toast was already shown by API client. Nothing to do.
    isLoading = false;
  }

  Future<void> saveFirstTime() async => await splashService.saveFirstTime();
  bool get isFirstTime => splashService.getFirstTime();
}
