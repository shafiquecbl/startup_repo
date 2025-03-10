import 'package:startup_repo/features/theme/data/repository/theme_repo_interface.dart';
import 'package:startup_repo/imports.dart';
import '../../data/repository/theme_repo.dart';
import '../../presentation/controller/theme_controller.dart';
import '../service/theme_service.dart';
import '../service/theme_service_interface.dart';

class ThemeBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    ThemeRepoInterface themeRepoInterface = ThemeRepo(prefs: Get.find());
    Get.lazyPut(() => themeRepoInterface);

    // service
    ThemeServiceInterface themeServiceInterface = ThemeService(themeRepo: Get.find());
    Get.lazyPut(() => themeServiceInterface);

    // controller
    Get.lazyPut(() => ThemeController(themeService: Get.find()));
  }
}
