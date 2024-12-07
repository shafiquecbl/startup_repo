import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:startup_repo/controller/localization_controller.dart';
import 'package:startup_repo/controller/theme_controller.dart';
import 'package:startup_repo/data/repository/localization_repo_interface.dart';
import 'package:startup_repo/data/repository/splash_repo_interface.dart';
import 'package:startup_repo/data/service/localization_service_interface.dart';
import 'package:startup_repo/data/service/splash_service_interface.dart';
import 'package:startup_repo/data/service/theme_service_interface.dart';
import 'package:startup_repo/utils/app_constants.dart';
import '../data/api/api_client.dart';
import '../data/api/api_client_interface.dart';
import '../data/model/language.dart';
import '../data/repository/localization_repo.dart';
import '../data/repository/splash_repo.dart';
import '../data/repository/theme_repo.dart';
import '../data/repository/theme_repo_interface.dart';
import '../data/service/localization_service.dart';
import '../data/service/splash_service.dart';
import '../data/service/theme_service.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  ApiClientInterface apiClient = ApiClient(sharedPreferences: Get.find(), baseUrl: AppConstants.baseUrl);
  Get.lazyPut(() => apiClient);

  // Repository
  LocalizationRepoInterface localizationRepo = LocalizationRepo(prefs: Get.find());
  Get.lazyPut(() => localizationRepo);
  ThemeRepoInterface themeRepo = ThemeRepo(prefs: Get.find());
  Get.lazyPut(() => themeRepo);
  SplashRepoInterface splashRepo = SplashRepo(apiClient: Get.find(), prefs: Get.find());
  Get.lazyPut(() => splashRepo);

  // Service
  LocalizationServiceInterface localizationService = LocalizationService(localizationRepo: Get.find());
  Get.lazyPut(() => localizationService);
  ThemeServiceInterface themeService = ThemeService(themeRepo: Get.find());
  Get.lazyPut(() => themeService);
  SplashServiceInterface splashService = SplashService(splashRepo: Get.find());
  Get.lazyPut(() => splashService);

  // Controller
  Get.lazyPut(() => LocalizationController(localizationService: Get.find()));
  Get.lazyPut(() => ThemeController(themeService: Get.find()));
  Get.lazyPut(() => LocalizationController(localizationService: Get.find()));

  // Retrieving localized data
  return await _loadLanguages();
}

Future<Map<String, Map<String, String>>> _loadLanguages() async {
  Map<String, Map<String, String>> languages = {};

  //
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =
        await rootBundle.loadString('assets/languages/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = json;
  }
  return languages;
}
