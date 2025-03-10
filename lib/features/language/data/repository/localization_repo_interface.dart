import 'package:flutter/material.dart';

abstract class LocalizationRepoInterface {
  Locale loadCurrentLanguage();
  Future<void> saveLanguage(Locale locale);
  List<Locale> get availableLanguages;
}
