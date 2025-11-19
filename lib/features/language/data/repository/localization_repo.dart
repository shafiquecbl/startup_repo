import '../../../../imports.dart';
import 'localization_repo_interface.dart';

class LocalizationRepoImpl implements LocalizationRepo {
  final SharedPreferences prefs;
  LocalizationRepoImpl({required this.prefs});

  @override
  Locale loadCurrentLanguage() {
    return Locale(
      prefs.getString(SharedKeys.languageCode) ?? appLanguages.first.languageCode,
      prefs.getString(SharedKeys.countryCode) ?? appLanguages.first.countryCode,
    );
  }

  @override
  Future<void> saveLanguage(Locale locale) async {
    Get.updateLocale(locale);
    await prefs.setString(SharedKeys.languageCode, locale.languageCode);
    await prefs.setString(SharedKeys.countryCode, locale.countryCode!);
  }

  @override
  List<Locale> get availableLanguages {
    return appLanguages.map((lang) => Locale(lang.languageCode, lang.countryCode)).toList();
  }
}
