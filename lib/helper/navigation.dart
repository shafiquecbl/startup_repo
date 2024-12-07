import 'package:flutter/material.dart';
import 'package:get/get.dart';

pop() => Navigator.pop(Get.context!);

/// Launch a new screen
Future<dynamic> launchScreen(Widget child, {bool pushAndRemove = false, bool replace = false}) async {
  const Duration duration = Duration(seconds: 1);
  if (pushAndRemove) {
    return Get.offAll(() => child, duration: duration, routeName: routeName(child));
  } else if (replace) {
    return Get.off(() => child, duration: duration, routeName: routeName(child));
  } else {
    return Get.to(() => child, duration: duration, routeName: routeName(child));
  }
}

// Convert widget to route name
String routeName(Widget widget) {
  // Get the class name of the widget as a string
  String className = widget.runtimeType.toString();

  // Remove "Screen" or other suffixes if needed
  if (className.endsWith('Screen')) {
    className = className.replaceAll('Screen', '');
  }

  // Convert to lowercase for route name
  String route = className.toLowerCase();

  return route;
}
