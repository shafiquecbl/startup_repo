import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:startup_repo/features/theme/domain/binding/theme_binding.dart';

import '../../features/splash/domain/binding/splash_binding.dart';
import '../../features/language/domain/binding/language_binding.dart';
import '../api/client/api_client.dart';
import '../api/client/dio_api_client.dart';
import '../api/model/api_failure.dart';
import '../api/support/api_error_localizer.dart';
import '../services/connectivity/connectivity_service.dart';
import '../utils/shared_keys.dart';
import '../utils/app_constants.dart';
import '../widgets/feedback/app_toast.dart';
import '../../features/language/data/model/language.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  final ApiClient apiClient = DioApiClient(
    baseUrl: AppConstants.baseUrl,
    feedbackHandler: (ApiFailure failure) => AppToast.error(ApiErrorLocalizer.message(failure)),
  );
  apiClient.updateHeader(
    'Accept-Language',
    sharedPreferences.getString(SharedKeys.languageCode) ?? appLanguages.first.languageCode,
  );
  Get.lazyPut<SharedPreferences>(() => sharedPreferences);
  Get.lazyPut<ApiClient>(() => apiClient);
  Get.lazyPut<ConnectivityService>(() => ConnectivityService());

  final List<Bindings> bindings = [ThemeBinding(), LanguageBinding(), SplashBinding()];
  for (Bindings binding in bindings) {
    binding.dependencies();
  }

  // Retrieving localized data
  return await _loadLanguages();
}

Future<Map<String, Map<String, String>>> _loadLanguages() async {
  final Map<String, Map<String, String>> languages = {};

  //
  for (LanguageModel languageModel in appLanguages) {
    final String jsonStringValues = await rootBundle.loadString(
      'assets/languages/${languageModel.languageCode}.json',
    );
    final Object? decodedJson = jsonDecode(jsonStringValues);
    if (decodedJson is! Map<Object?, Object?>) {
      throw const FormatException('Language asset must contain a JSON object.');
    }
    final Map<String, Object?> mappedJson = decodedJson.map(
      (Object? key, Object? value) => MapEntry<String, Object?>(key.toString(), value),
    );
    final Map<String, String> json = {};
    mappedJson.forEach((String key, Object? value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = json;
  }
  return languages;
}
