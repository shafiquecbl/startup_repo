import 'package:flutter/material.dart';
import 'package:startup_repo/features/language/data/repository/localization_repo_interface.dart';
import 'localization_service.dart';

class LocalizationServiceImpl implements LocalizationService {
  final LocalizationRepo localizationRepo;
  LocalizationServiceImpl({required this.localizationRepo});

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
