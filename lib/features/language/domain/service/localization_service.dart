import 'package:flutter/material.dart';
import 'package:startup_repo/features/language/data/repository/localization_repo_interface.dart';
import 'localization_service_interface.dart';

class LocalizationService implements LocalizationServiceInterface {
  final LocalizationRepoInterface localizationRepo;
  LocalizationService({required this.localizationRepo});

  @override
  Locale loadCurrentLanguage() {
    return localizationRepo.loadCurrentLanguage();
  }

  @override
  Future<void> saveLanguage(Locale locale) async {
    await localizationRepo.saveLanguage(locale);
  }

  @override
  List<Locale> get availableLanguages {
    return localizationRepo.availableLanguages;
  }
}
