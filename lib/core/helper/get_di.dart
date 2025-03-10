import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:startup_repo/features/theme/domain/binding/theme_binding.dart';
import 'package:startup_repo/core/utils/app_constants.dart';
import '../../features/language/domain/binding/language_binding.dart';
import '../../features/splash/domain/binding/splash_binding.dart';
import '../api/api_client.dart';
import '../api/api_client_interface.dart';
import '../../features/language/data/model/language.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  ApiClientInterface apiClient = ApiClient(prefs: Get.find(), baseUrl: AppConstants.baseUrl);
  Get.lazyPut(() => apiClient);

  List<Bindings> bindings = [ThemeBinding(), LanguageBinding(), SplashBinding()];

  for (Bindings binding in bindings) {
    binding.dependencies();
  }

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
