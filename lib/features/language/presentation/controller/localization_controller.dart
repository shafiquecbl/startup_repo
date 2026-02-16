import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/model/language.dart';
import '../../data/repository/localization_repo_interface.dart';

class LocalizationController extends GetxController implements GetxService {
  final LocalizationRepo localizationRepo;
  LocalizationController({required this.localizationRepo}) {
    loadCurrentLanguage();
  }

  static LocalizationController get find => Get.find<LocalizationController>();

  Locale _locale = Locale(
    appLanguages[0].languageCode,
    appLanguages[0].countryCode,
  );
  bool _isLtr = true;
  List<LanguageModel> _languages = [];
  int _selectedIndex = 0;

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  List<LanguageModel> get languages => _languages;
  int get selectedIndex => _selectedIndex;

  void loadCurrentLanguage() {
    final Locale locale = localizationRepo.loadCurrentLanguage();
    setLanguage(locale);
    _languages = List.from(appLanguages);
    update();
  }

  void setLanguage(Locale locale) {
    _locale = locale;
    _isLtr = _locale.languageCode != 'ar' && _locale.languageCode != 'fa';
    saveLanguage(_locale);
    update();
  }

  Future<void> saveLanguage(Locale locale) async {
    await localizationRepo.saveLanguage(locale);
  }

  void setSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void searchLanguage(String query) {
    if (query.isEmpty) {
      _languages = List.from(appLanguages);
    } else {
      _selectedIndex = -1;
      _languages = appLanguages
          .where((language) => language.languageName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update();
  }
}
