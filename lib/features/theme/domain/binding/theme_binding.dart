import 'package:startup_repo/features/theme/data/repository/theme_repo.dart';
import 'package:startup_repo/imports.dart';
import '../../data/repository/theme_repo_impl.dart';
import '../../presentation/controller/theme_controller.dart';
import '../service/theme_service_impl.dart';
import '../service/theme_service.dart';

class ThemeBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    ThemeRepo themeRepoInterface = ThemeRepoImpl(prefs: Get.find());
    Get.lazyPut(() => themeRepoInterface);

    // service
    ThemeService themeServiceInterface = ThemeServiceImpl(themeRepo: Get.find());
    Get.lazyPut(() => themeServiceInterface);

    // controller
    Get.lazyPut(() => ThemeController(themeService: Get.find()));
  }
}
