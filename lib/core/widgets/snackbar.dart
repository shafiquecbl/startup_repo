import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class AppDialog {
  AppDialog._();

  static Future<T?> showLoading<T>() => SmartDialog.showLoading<T>();

  static Future<void> hideLoading<T>() => SmartDialog.dismiss<T>();

  static void showToast(String text) {
    SmartDialog.showToast(text, displayTime: const Duration(seconds: 3));
  }
}
