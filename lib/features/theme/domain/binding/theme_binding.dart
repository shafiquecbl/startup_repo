import 'package:startup_repo/features/theme/data/repository/theme_repo.dart';
import 'package:startup_repo/imports.dart';
import '../../data/repository/theme_repo_impl.dart';
import '../../presentation/controller/theme_controller.dart';

class ThemeBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    Get.lazyPut<ThemeRepo>(() => ThemeRepoImpl(prefs: Get.find()));

    // controller
    Get.lazyPut(() => ThemeController(themeRepo: Get.find()));
  }
}
