import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

showLoading() => SmartDialog.showLoading();

hideLoading() => SmartDialog.dismiss();

showToast(String text) {
  SmartDialog.showToast(text, displayTime: const Duration(seconds: 3));
}

