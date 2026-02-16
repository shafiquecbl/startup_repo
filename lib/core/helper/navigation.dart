import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppNav {
  AppNav._();

  static const Duration _duration = Duration(seconds: 1);

  static Future<T?> push<T>(Widget child) async {
    return await Get.to(() => child, duration: _duration, routeName: _routeName(child));
  }

  static Future<T?> pushReplacement<T>(Widget child) async {
    return await Get.off(() => child, duration: _duration, routeName: _routeName(child));
  }

  static Future<T?> pushAndRemoveUntil<T>(Widget child) async {
    return await Get.offAll(() => child, duration: _duration, routeName: _routeName(child));
  }

  /// Convert widget to route name
  static String _routeName(Widget widget) {
    String className = widget.runtimeType.toString();
    if (className.endsWith('Screen')) {
      className = className.replaceAll('Screen', '');
    }
    return className.toLowerCase();
  }
}
