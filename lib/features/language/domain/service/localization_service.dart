import 'package:flutter/material.dart';

abstract class LocalizationService {
  Locale loadCurrentLanguage();
  Future<void> saveLanguage(Locale locale);
  List<Locale> get availableLanguages;
}
