import 'package:startup_repo/imports.dart';
import '../../data/repository/splash_repo_impl.dart';
import '../../data/repository/splash_repo.dart';
import '../../presentation/controller/splash_controller.dart';
import '../service/splash_service_impl.dart';
import '../service/splash_service.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    SplashRepo splashRepoInterface = SplashRepoImpl(prefs: Get.find(), apiClient: Get.find());
    Get.lazyPut(() => splashRepoInterface);

    // service
    SplashService splashServiceInterface = SplashServiceImpl(splashRepo: Get.find());
    Get.lazyPut(() => splashServiceInterface);

    // controller
    Get.lazyPut(() => SplashController(settingsService: Get.find()));
  }
}
