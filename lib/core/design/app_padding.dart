import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Standardized spacing scale for the app.
///
/// Based on a **4px base unit** with 5 steps that cover 95% of layouts:
///
/// | Token | Value | Usage                              |
/// |-------|-------|------------------------------------|
/// | `p4`  | 4     | Tight gaps, icon padding           |
/// | `p8`  | 8     | Between related items              |
/// | `p16` | 16    | Card padding, section gaps         |
/// | `p24` | 24    | Screen edges, large gaps           |
/// | `p32` | 32    | Modal padding, hero spacing        |
///
/// **Semantic aliases** (`screen`, `card`) point to scale tokens, enforcing
/// consistent usage without hardcoding numbers everywhere.
///
/// Example:
/// ```dart
/// Padding(padding: AppPadding.p16, child: ...)
/// Padding(padding: AppPadding.vertical(12), child: ...)
/// Padding(padding: AppPadding.screen, child: ...)  // same as p16
/// ```
class AppPadding {
  AppPadding._();

  // All sides
  static EdgeInsets get p4 => EdgeInsets.all(4.sp);
  static EdgeInsets get p8 => EdgeInsets.all(8.sp);
  static EdgeInsets get p16 => EdgeInsets.all(16.sp);
  static EdgeInsets get p24 => EdgeInsets.all(24.sp);
  static EdgeInsets get p32 => EdgeInsets.all(32.sp);

  // Symmetric
  static EdgeInsets vertical(double value) => EdgeInsets.symmetric(vertical: value.sp);
  static EdgeInsets horizontal(double value) => EdgeInsets.symmetric(horizontal: value.sp);

  // Semantic aliases
  static EdgeInsets get screen => p16;
  static EdgeInsets get card => EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp);
}
