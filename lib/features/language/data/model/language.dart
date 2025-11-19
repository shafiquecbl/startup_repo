class LanguageModel {
  String languageName;
  String languageCode;
  String countryCode;

  LanguageModel({required this.languageName, required this.countryCode, required this.languageCode});
}

// Language
List<LanguageModel> appLanguages = [
  LanguageModel(languageName: 'English', countryCode: 'US', languageCode: 'en'),
  LanguageModel(languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
];
