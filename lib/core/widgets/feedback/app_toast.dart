import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  AppToast._();

  static const Duration _deduplicationWindow = Duration(seconds: 2);
  static final Map<String, DateTime> _shownMessages = <String, DateTime>{};

  static void success(String message) => _show(message, ToastificationType.success);

  static void error(String message) => _show(message, ToastificationType.error);

  static void info(String message) => _show(message, ToastificationType.info);

  static void warning(String message) => _show(message, ToastificationType.warning);

  static void dismissAll() => toastification.dismissAll();

  static void _show(String message, ToastificationType type) {
    final String normalizedMessage = message.trim();
    final String messageKey = '${type.name}:$normalizedMessage';
    if (normalizedMessage.isEmpty || _isDuplicate(messageKey)) {
      return;
    }

    toastification.show(
      type: type,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.topCenter,
      title: Text(normalizedMessage, maxLines: 3, overflow: TextOverflow.ellipsis),
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      closeOnClick: true,
      dragToClose: true,
    );
  }

  static bool _isDuplicate(String key) {
    final DateTime now = DateTime.now();
    _shownMessages.removeWhere((String _, DateTime shownAt) {
      return now.difference(shownAt) >= _deduplicationWindow;
    });
    if (_shownMessages.containsKey(key)) {
      return true;
    }
    _shownMessages[key] = now;
    return false;
  }
}
