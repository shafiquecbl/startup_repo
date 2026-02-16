class LanguageModel {
  final String languageName;
  final String languageCode;
  final String countryCode;

  const LanguageModel({required this.languageName, required this.countryCode, required this.languageCode});
}

// Language
const List<LanguageModel> appLanguages = [
  LanguageModel(languageName: 'English', countryCode: 'US', languageCode: 'en'),
  LanguageModel(languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
];
