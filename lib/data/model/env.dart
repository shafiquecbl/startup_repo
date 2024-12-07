import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvModel {
  static String appName = dotenv.env['APP_NAME'] ?? '';
  static String baseUrl = dotenv.env['BASE_URL'] ?? '';
  static Color primaryColor = _getColor('PRIMARY_COLOR');
  static Color secondaryColor = _getColor('SECONDARY_COLOR');

  static Color _getColor(String key) {
    return Color(int.parse(dotenv.env[key].toString()));
  }
}
