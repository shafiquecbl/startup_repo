import 'package:flutter/material.dart';

import '../../data/model/language.dart';

abstract class LocalizationService {
  Locale loadCurrentLanguage();
  Future<void> saveLanguage(Locale locale);
  List<LanguageModel> get availableLanguages;
}
