import 'package:flutter/material.dart';

abstract class LocalizationServiceInterface {
  Locale loadCurrentLanguage();
  Future<void> saveLanguage(Locale locale);
  List<Locale> get availableLanguages;
}
