import 'package:flutter/material.dart';

abstract class LocalizationRepo {
  Locale loadCurrentLanguage();
  Future<void> saveLanguage(Locale locale);
  List<Locale> get availableLanguages;
}
