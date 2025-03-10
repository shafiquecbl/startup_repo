class ConfigModel {
  String termsAndConditions;
  String privacyPolicy;
  String userAgreement;
  String cancelAnytime;

  ConfigModel({
    required this.termsAndConditions,
    required this.privacyPolicy,
    required this.userAgreement,
    required this.cancelAnytime,
  });

  // from json
  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
        termsAndConditions: json["terms_condition"]["value"],
        privacyPolicy: json["privacy_policy"]["value"],
        userAgreement: json["user_agreement"]["value"],
        cancelAnytime: json["cancel_anytime"]["value"],
      );

  // to json
  Map<String, dynamic> toJson() => {
        "terms_condition": {"value": termsAndConditions},
        "privacy_policy": {"value": privacyPolicy},
        "user_agreement": {"value": userAgreement},
        "cancel_anytime": {"value": cancelAnytime},
      };
}
