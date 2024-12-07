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
      prefs.getString(AppConstants.languageCode) ?? AppConstants.languages.first.languageCode,
      prefs.getString(AppConstants.countryCode) ?? AppConstants.languages.first.countryCode,
    );
  }

  @override
  Future<void> saveLanguage(Locale locale) async {
    Get.updateLocale(locale);
    await prefs.setString(AppConstants.languageCode, locale.languageCode);
    await prefs.setString(AppConstants.countryCode, locale.countryCode!);
  }

  @override
  List<Locale> get availableLanguages {
    return AppConstants.languages.map((lang) => Locale(lang.languageCode, lang.countryCode)).toList();
  }
}
