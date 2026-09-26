import 'package:startup_repo/features/theme/data/repository/theme_repo.dart';
import 'package:startup_repo/imports.dart';

import '../../data/repository/theme_repo_impl.dart';
import '../../presentation/controller/theme_controller.dart';
import '../service/theme_service.dart';
import '../service/theme_service_impl.dart';

class ThemeBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    Get.lazyPut<ThemeRepo>(() => ThemeRepoImpl(prefs: Get.find()));

    // service
    Get.lazyPut<ThemeService>(() => ThemeServiceImpl(themeRepo: Get.find()));

    // controller
    Get.lazyPut(() => ThemeController(themeService: Get.find()));
  }
}
