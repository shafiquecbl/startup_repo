import '../../features/language/data/model/language.dart';

class AppConstants {
  // app name and package name
  static String appName = 'Startup Repo';

  // Base URL
  static String baseUrl = 'https://api.example.com/';

  // API Endpoints
  static const String configUrl = 'config';

  // Shared Key
  static const String theme = 'theme';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String onBoardingSkip = 'on_boarding_skip';
  static const String token = 'token';
  static const String localizationKey = 'localization';

  // Language
  static List<LanguageModel> languages = [
    LanguageModel(languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
  ];
}
