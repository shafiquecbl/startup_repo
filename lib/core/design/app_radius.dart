import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Standardized border radius scale for the app (iOS-style superellipse).
///
/// A tight scale with 5 steps that cover 95% of UI shapes:
///
/// | Token  | Value | Usage                              |
/// |--------|-------|-----------------------------------|
/// | `r4`   | 4     | Subtle rounding, tags              |
/// | `r8`   | 8     | Chips, small buttons               |
/// | `r16`  | 16    | Cards, inputs, buttons             |
/// | `r24`  | 24    | Bottom sheets, modals              |
/// | `r100` | 100   | Pills, circular avatars            |
///
/// **Shape variants** (`r8Shape`, `r16Shape`, `r24Shape`) return
/// `RoundedSuperellipseBorder` — iOS-style smooth corners for `ThemeData`,
/// `ButtonStyle`, `ShapeDecoration`, etc.
///
/// **Partial-corner shapes** (`topShape()`, `bottomShape()`) also use
/// `RoundedSuperellipseBorder` for smooth top/bottom-only rounding.
///
/// **Raw `BorderRadius` getters** (`r4`–`r100`, `top()`, `bottom()`) are kept
/// for APIs that only accept `BorderRadius` (e.g. `OutlineInputBorder`).
///
/// Example:
/// ```dart
/// ShapeDecoration(shape: AppRadius.r16Shape)          // preferred
/// Container(decoration: ShapeDecoration(shape: AppRadius.r16Shape))
/// ElevatedButton(style: ButtonStyle(shape: AppRadius.r16Shape))
/// BottomSheet(shape: AppRadius.topShape(16))
/// OutlineInputBorder(borderRadius: AppRadius.r16)     // fallback
/// ```
class AppRadius {
  AppRadius._();

  // BorderRadius (all corners) — raw geometry, standard corners.
  // Use shape variants below for smooth superellipse rendering.
  static BorderRadius get r4 => BorderRadius.circular(4.sp);
  static BorderRadius get r8 => BorderRadius.circular(8.sp);
  static BorderRadius get r16 => BorderRadius.circular(16.sp);
  static BorderRadius get r24 => BorderRadius.circular(24.sp);
  static BorderRadius get r100 => BorderRadius.circular(100.sp);

  // Superellipse shapes (for ThemeData, ButtonStyle, ShapeDecoration, etc.)
  static RoundedSuperellipseBorder get r8Shape => RoundedSuperellipseBorder(borderRadius: r8);
  static RoundedSuperellipseBorder get r16Shape => RoundedSuperellipseBorder(borderRadius: r16);
  static RoundedSuperellipseBorder get r24Shape => RoundedSuperellipseBorder(borderRadius: r24);

  // Partial-corner shapes (superellipse)
  static RoundedSuperellipseBorder topShape(double radius) =>
      RoundedSuperellipseBorder(borderRadius: top(radius));

  static RoundedSuperellipseBorder bottomShape(double radius) =>
      RoundedSuperellipseBorder(borderRadius: bottom(radius));

  // Partial corners (raw BorderRadius — for APIs that require it)
  static BorderRadius top(double radius) => BorderRadius.only(
        topLeft: Radius.circular(radius.sp),
        topRight: Radius.circular(radius.sp),
      );

  static BorderRadius bottom(double radius) => BorderRadius.only(
        bottomLeft: Radius.circular(radius.sp),
        bottomRight: Radius.circular(radius.sp),
      );
}
