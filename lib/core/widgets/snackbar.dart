import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class AppDialog {
  AppDialog._();

  static showLoading<T>() => SmartDialog.showLoading<T>();

  static hideLoading<T>() => SmartDialog.dismiss<T>();

  static showToast(String text) {
    SmartDialog.showToast(text, displayTime: const Duration(seconds: 3));
  }
}
