import 'package:startup_repo/features/language/data/repository/localization_repo_interface.dart';
import 'package:startup_repo/imports.dart';
import '../../data/repository/localization_repo.dart';
import '../service/localization_service.dart';
import '../service/localization_service_interface.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    LocalizationRepoInterface localizationRepoInterface = LocalizationRepo(prefs: Get.find());
    Get.lazyPut(() => localizationRepoInterface);

    // service
    LocalizationServiceInterface localizationServiceInterface =
        LocalizationService(localizationRepo: Get.find());
    Get.lazyPut(() => localizationServiceInterface);

    // controller
    Get.lazyPut(() => LocalizationController(localizationService: Get.find()));
  }
}
