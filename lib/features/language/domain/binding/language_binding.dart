import 'package:startup_repo/features/language/data/repository/localization_repo_interface.dart';
import 'package:startup_repo/imports.dart';
import 'package:startup_repo/features/language/presentation/controller/localization_controller.dart';

import '../../data/repository/localization_repo.dart';
import '../service/localization_service.dart';
import '../service/localization_service_impl.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    Get.lazyPut<LocalizationRepo>(() => LocalizationRepoImpl(prefs: Get.find()));

    // service
    Get.lazyPut<LocalizationService>(() => LocalizationServiceImpl(localizationRepo: Get.find()));

    // controller
    Get.lazyPut(() => LocalizationController(localizationService: Get.find()));
  }
}
