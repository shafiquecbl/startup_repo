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
    Get.lazyPut<SplashRepo>(() => SplashRepoImpl(prefs: Get.find(), apiClient: Get.find()));

    // service
    Get.lazyPut<SplashService>(() => SplashServiceImpl(splashRepo: Get.find()));

    // controller
    Get.lazyPut(() => SplashController(splashService: Get.find()));
  }
}
