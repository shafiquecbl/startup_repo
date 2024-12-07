import '../data/model/language.dart';

class AppConstants {
  // app name and package name
  static const String APP_NAME = 'PixArt';
  static const String APP_PACKAGE_NAME = 'pixart.aiart.generator';

  // Base URL
  static const String BASE_URL = 'https://pixartai.dcodax.net/api/';

  // API Endpoints
  static const String CONFIG_URL = 'config';

  // Shared Key
  static const String THEME = 'theme';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String ON_BOARDING_SKIP = 'on_boarding_skip';

  // Language
  static List<LanguageModel> languages = [
    LanguageModel(
      languageName: 'English',
      countryCode: 'US',
      languageCode: 'en',
    ),
    LanguageModel(
      languageName: 'Arabic',
      countryCode: 'SA',
      languageCode: 'ar',
    ),
  ];
}
