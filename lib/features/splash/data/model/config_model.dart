class ConfigModel {
  final String termsAndConditions;
  final String privacyPolicy;
  final String userAgreement;
  final String cancelAnytime;

  const ConfigModel({
    required this.termsAndConditions,
    required this.privacyPolicy,
    required this.userAgreement,
    required this.cancelAnytime,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
        termsAndConditions: _extractValue(json, 'terms_condition'),
        privacyPolicy: _extractValue(json, 'privacy_policy'),
        userAgreement: _extractValue(json, 'user_agreement'),
        cancelAnytime: _extractValue(json, 'cancel_anytime'),
      );

  /// Safely extract nested `{ "key": { "value": "..." } }` pattern
  static String _extractValue(Map<String, dynamic> json, String key) {
    final dynamic entry = json[key];
    if (entry is Map<String, dynamic>) return entry['value']?.toString() ?? '';
    if (entry is String) return entry;
    return '';
  }

  Map<String, dynamic> toJson() => {
        'terms_condition': {'value': termsAndConditions},
        'privacy_policy': {'value': privacyPolicy},
        'user_agreement': {'value': userAgreement},
        'cancel_anytime': {'value': cancelAnytime},
      };
}
