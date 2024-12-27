import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/utils/colors.dart';
import '../../utils/text_theme.dart';

TextTheme textThemeLight(BuildContext context) {
  final baseTextTheme = Theme.of(context).textTheme;
  return TextTheme(
    displayLarge: customStyle(baseTextTheme.displayLarge, fontSize: 34.0.sp, fontWeight: FontWeight.bold),
    displayMedium: customStyle(baseTextTheme.displayMedium, fontSize: 32.0.sp, fontWeight: FontWeight.bold),
    displaySmall: customStyle(baseTextTheme.displaySmall, fontSize: 30.0.sp, fontWeight: FontWeight.bold),
    headlineLarge: customStyle(baseTextTheme.headlineLarge, fontSize: 28.0.sp, fontWeight: FontWeight.w600),
    headlineMedium: customStyle(baseTextTheme.headlineMedium, fontSize: 26.0.sp, fontWeight: FontWeight.w600),
    headlineSmall: customStyle(baseTextTheme.headlineSmall, fontSize: 24.0.sp, fontWeight: FontWeight.w600),
    titleLarge: customStyle(baseTextTheme.titleLarge, fontSize: 22.0.sp, fontWeight: FontWeight.w600),
    titleMedium: customStyle(baseTextTheme.titleMedium, fontSize: 20.0.sp, fontWeight: FontWeight.w600),
    titleSmall: customStyle(baseTextTheme.titleSmall, fontSize: 18.0.sp),
    bodyLarge: customStyle(baseTextTheme.bodyLarge, fontSize: 16.0.sp, fontWeight: FontWeight.normal),
    bodyMedium: customStyle(baseTextTheme.bodyMedium, fontSize: 14.0.sp, fontWeight: FontWeight.normal),
    bodySmall: customStyle(baseTextTheme.bodySmall, fontSize: 12.0.sp, fontWeight: FontWeight.normal),
    labelLarge: customStyle(baseTextTheme.labelLarge, fontSize: 10.0.sp, fontWeight: FontWeight.normal),
    labelMedium: customStyle(baseTextTheme.labelMedium, fontSize: 8.0.sp, fontWeight: FontWeight.normal),
    labelSmall: customStyle(baseTextTheme.labelSmall, fontSize: 6.0.sp, fontWeight: FontWeight.normal),
  ).apply(displayColor: textColorLight, bodyColor: textColorLight);
}

TextTheme textThemeDark(BuildContext context) =>
    textThemeLight(context).apply(displayColor: textColorDark, bodyColor: textColorDark);
