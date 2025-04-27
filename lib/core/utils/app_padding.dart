import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A utility class to standardize padding throughout the app
class AppPadding {
  // All sides padding
  static EdgeInsets get padding4 => EdgeInsets.all(4.sp);
  static EdgeInsets get padding8 => EdgeInsets.all(8.sp);
  static EdgeInsets get padding12 => EdgeInsets.all(12.sp);
  static EdgeInsets get padding16 => EdgeInsets.all(16.sp);
  static EdgeInsets get padding20 => EdgeInsets.all(20.sp);
  static EdgeInsets get padding24 => EdgeInsets.all(24.sp);
  static EdgeInsets get padding32 => EdgeInsets.all(32.sp);

  // symmetric padding
  static EdgeInsets vertical(double padding) => EdgeInsets.symmetric(vertical: padding.sp);
  static EdgeInsets horizontal(double padding) => EdgeInsets.symmetric(horizontal: padding.sp);

  // Common combinations
  static EdgeInsets get paddingScreen => padding16;
  static EdgeInsets get paddingCard => EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp);
}
