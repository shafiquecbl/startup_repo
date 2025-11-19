import 'package:startup_repo/features/language/data/repository/localization_repo_interface.dart';
import 'package:startup_repo/imports.dart';
import '../../data/repository/localization_repo.dart';
import '../service/localization_service_impl.dart';
import '../service/localization_service.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    LocalizationRepo localizationRepoInterface = LocalizationRepoImpl(prefs: Get.find());
    Get.lazyPut(() => localizationRepoInterface);

    // service
    LocalizationService localizationServiceInterface = LocalizationServiceImpl(localizationRepo: Get.find());
    Get.lazyPut(() => localizationServiceInterface);

    // controller
    Get.lazyPut(() => LocalizationController(localizationService: Get.find()));
  }
}
