import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Standardized border radius scale for the app.
///
/// A tight scale with 4 steps that cover 95% of UI shapes:
///
/// | Token  | Value | Usage                              |
/// |--------|-------|------------------------------------|
/// | `r4`   | 4     | Subtle rounding, tags              |
/// | `r8`   | 8     | Chips, small buttons               |
/// | `r16`  | 16    | Cards, inputs, buttons             |
/// | `r24`  | 24    | Bottom sheets, modals              |
/// | `r100` | 100   | Pills, circular avatars            |
///
/// **Shape variants** (`r8Shape`, `r16Shape`, `r24Shape`) return
/// `RoundedRectangleBorder` for use in `ThemeData`, `ButtonStyle`, etc.
///
/// **Partial corners** (`top()`, `bottom()`) apply radius to specific sides.
///
/// Example:
/// ```dart
/// Container(decoration: BoxDecoration(borderRadius: AppRadius.r16))
/// ElevatedButton(style: ButtonStyle(shape: AppRadius.r16Shape))
/// BottomSheet(shape: RoundedRectangleBorder(borderRadius: AppRadius.top(16)))
/// ```
class AppRadius {
  AppRadius._();

  // BorderRadius (all corners)
  static BorderRadius get r4 => BorderRadius.circular(4.sp);
  static BorderRadius get r8 => BorderRadius.circular(8.sp);
  static BorderRadius get r16 => BorderRadius.circular(16.sp);
  static BorderRadius get r24 => BorderRadius.circular(24.sp);
  static BorderRadius get r100 => BorderRadius.circular(100.sp);

  // RoundedRectangleBorder shapes (for ThemeData, ButtonStyle, etc.)
  static RoundedRectangleBorder get r8Shape => RoundedRectangleBorder(borderRadius: r8);
  static RoundedRectangleBorder get r16Shape => RoundedRectangleBorder(borderRadius: r16);
  static RoundedRectangleBorder get r24Shape => RoundedRectangleBorder(borderRadius: r24);

  // Partial corners
  static BorderRadius top(double radius) =>
      BorderRadius.only(topLeft: Radius.circular(radius.sp), topRight: Radius.circular(radius.sp));

  static BorderRadius bottom(double radius) =>
      BorderRadius.only(bottomLeft: Radius.circular(radius.sp), bottomRight: Radius.circular(radius.sp));
}
