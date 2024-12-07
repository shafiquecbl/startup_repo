import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvModel {
  static String appName = dotenv.env['APP_NAME'] ?? '';
  static Color primaryColor = _loadColorFromEnv('PRIMARY_COLOR');
  static Color secondaryColor = _loadColorFromEnv('SECONDARY_COLOR');

  static Color _loadColorFromEnv(String key) {
    final colorString = dotenv.env[key] ?? '#000000';
    return _hexToColor(colorString);
  }

  static Color _hexToColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
