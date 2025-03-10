import 'package:startup_repo/imports.dart';
import '../../data/repository/splash_repo.dart';
import '../../data/repository/splash_repo_interface.dart';
import '../../presentation/controller/splash_controller.dart';
import '../service/splash_service.dart';
import '../service/splash_service_interface.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    SplashRepoInterface splashRepoInterface = SplashRepo(prefs: Get.find(), apiClient: Get.find());
    Get.lazyPut(() => splashRepoInterface);

    // service
    SplashServiceInterface splashServiceInterface = SplashService(splashRepo: Get.find());
    Get.lazyPut(() => splashServiceInterface);

    // controller
    Get.lazyPut(() => SplashController(settingsService: Get.find()));
  }
}
