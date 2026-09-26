import 'package:flutter/material.dart';

import '../../data/model/language.dart';
import '../../data/repository/localization_repo_interface.dart';
import 'localization_service.dart';

class LocalizationServiceImpl implements LocalizationService {
  LocalizationServiceImpl({required this.localizationRepo});

  final LocalizationRepo localizationRepo;

  @override
  List<LanguageModel> get availableLanguages => appLanguages;

  @override
  Locale loadCurrentLanguage() {
    final LanguageModel fallback = appLanguages.first;
    final String languageCode = localizationRepo.loadLanguageCode() ?? fallback.languageCode;
    final LanguageModel language = appLanguages.firstWhere(
      (LanguageModel item) => item.languageCode == languageCode,
      orElse: () => fallback,
    );
    return Locale(language.languageCode, localizationRepo.loadCountryCode() ?? language.countryCode);
  }

  @override
  Future<void> saveLanguage(Locale locale) {
    final LanguageModel language = appLanguages.firstWhere(
      (LanguageModel item) => item.languageCode == locale.languageCode,
      orElse: () => appLanguages.first,
    );
    return localizationRepo.saveLanguage(
      languageCode: locale.languageCode,
      countryCode: locale.countryCode ?? language.countryCode,
    );
  }
}
