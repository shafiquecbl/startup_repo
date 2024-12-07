import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_constants.dart';
import 'localization_repo_interface.dart';

class LocalizationRepo implements LocalizationRepoInterface {
  final SharedPreferences prefs;
  LocalizationRepo({required this.prefs});

  @override
  Locale loadCurrentLanguage() {
    return Locale(
      prefs.getString(AppConstants.LANGUAGE_CODE) ?? AppConstants.languages.first.languageCode,
      prefs.getString(AppConstants.COUNTRY_CODE) ?? AppConstants.languages.first.countryCode,
    );
  }

  @override
  Future<void> saveLanguage(Locale locale) async {
    Get.updateLocale(locale);
    await prefs.setString(AppConstants.LANGUAGE_CODE, locale.languageCode);
    await prefs.setString(AppConstants.COUNTRY_CODE, locale.countryCode!);
  }

  @override
  List<Locale> get availableLanguages {
    return AppConstants.languages.map((lang) => Locale(lang.languageCode, lang.countryCode)).toList();
  }
}
