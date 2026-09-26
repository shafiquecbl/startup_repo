abstract class LocalizationRepo {
  String? loadLanguageCode();
  String? loadCountryCode();
  Future<void> saveLanguage({required String languageCode, required String countryCode});
}
