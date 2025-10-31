import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A utility class to standardize border radius throughout the app
class AppRadius {
  // Circular border radius values
  static double get radius4 => 4.r;
  static double get radius8 => 8.r;
  static double get radius12 => 12.r;
  static double get radius16 => 16.r;
  static double get radius24 => 24.r;
  static double get radius100 => 100.r;

  // BorderRadius objects (all corners equal)
  static BorderRadius get circular4 => BorderRadius.circular(radius4);
  static BorderRadius get circular8 => BorderRadius.circular(radius8);
  static BorderRadius get circular12 => BorderRadius.circular(radius12);
  static BorderRadius get circular16 => BorderRadius.circular(radius16);
  static BorderRadius get circular24 => BorderRadius.circular(radius24);
  static BorderRadius get circular100 => BorderRadius.circular(radius100);

  // shape
  static get circular4Shape => RoundedRectangleBorder(borderRadius: circular4);
  static get circular8Shape => RoundedRectangleBorder(borderRadius: circular8);
  static get circular12Shape => RoundedRectangleBorder(borderRadius: circular12);
  static get circular16Shape => RoundedRectangleBorder(borderRadius: circular16);
  static get circular24Shape => RoundedRectangleBorder(borderRadius: circular24);
  static get circular100Shape => RoundedRectangleBorder(borderRadius: circular100);

  // Specific corners
  static BorderRadius topLeft(double radius) => BorderRadius.only(topLeft: Radius.circular(radius.r));
  static BorderRadius topRight(double radius) => BorderRadius.only(topRight: Radius.circular(radius.r));
  static BorderRadius bottomLeft(double radius) => BorderRadius.only(bottomLeft: Radius.circular(radius.r));
  static BorderRadius bottomRight(double radius) => BorderRadius.only(bottomRight: Radius.circular(radius.r));

  // Common combinations
  static BorderRadius top(double radius) =>
      BorderRadius.only(topLeft: Radius.circular(radius), topRight: Radius.circular(radius));

  static BorderRadius bottom(double radius) =>
      BorderRadius.only(bottomLeft: Radius.circular(radius), bottomRight: Radius.circular(radius));
}
