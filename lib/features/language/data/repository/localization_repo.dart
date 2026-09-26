import '../../../../imports.dart';
import 'localization_repo_interface.dart';

class LocalizationRepoImpl implements LocalizationRepo {
  final SharedPreferences prefs;
  LocalizationRepoImpl({required this.prefs});

  @override
  String? loadLanguageCode() => prefs.getString(SharedKeys.languageCode);

  @override
  String? loadCountryCode() => prefs.getString(SharedKeys.countryCode);

  @override
  Future<void> saveLanguage({required String languageCode, required String countryCode}) async {
    await prefs.setString(SharedKeys.languageCode, languageCode);
    await prefs.setString(SharedKeys.countryCode, countryCode);
  }
}
