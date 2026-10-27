import 'package:flutter/foundation.dart';
import 'package:startup_repo/imports.dart';

TextTheme textTheme(AppColors colors) {
  final Typography typography = Typography.material2021(platform: defaultTargetPlatform);
  TextTheme base = colors.text == Colors.white ? typography.white : typography.black;

  base = base.apply(displayColor: colors.text, bodyColor: colors.text, fontFamily: 'Poppins');
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(fontSize: 57.sp),
    displayMedium: base.displayMedium?.copyWith(fontSize: 45.sp),
    displaySmall: base.displaySmall?.copyWith(fontSize: 36.sp),
    headlineLarge: base.headlineLarge?.copyWith(fontSize: 32.sp),
    headlineMedium: base.headlineMedium?.copyWith(fontSize: 28.sp),
    headlineSmall: base.headlineSmall?.copyWith(fontSize: 24.sp),
    titleLarge: base.titleLarge?.copyWith(fontSize: 22.sp),
    titleMedium: base.titleMedium?.copyWith(fontSize: 16.sp),
    titleSmall: base.titleSmall?.copyWith(fontSize: 14.sp),
    bodyLarge: base.bodyLarge?.copyWith(fontSize: 16.sp),
    bodyMedium: base.bodyMedium?.copyWith(fontSize: 14.sp),
    bodySmall: base.bodySmall?.copyWith(fontSize: 12.sp),
    labelLarge: base.labelLarge?.copyWith(fontSize: 14.sp),
    labelMedium: base.labelMedium?.copyWith(fontSize: 12.sp),
    labelSmall: base.labelSmall?.copyWith(fontSize: 11.sp),
  );
}
