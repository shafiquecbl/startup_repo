import 'package:get/get.dart';

import '../model/api_failure.dart';

class ApiErrorLocalizer {
  ApiErrorLocalizer._();

  static String message(ApiFailure failure) {
    final String? serverMessage = failure.serverMessage?.trim();
    if (serverMessage != null && serverMessage.isNotEmpty) {
      return serverMessage;
    }
    return failure.kind.translationKey.tr;
  }
}
