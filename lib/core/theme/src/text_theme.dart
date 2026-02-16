import 'package:startup_repo/imports.dart';

TextTheme textTheme(AppColors colors) {
  final TextTheme base =
      colors.text == Colors.white ? ThemeData.dark().textTheme : ThemeData.light().textTheme;

  return base.apply(displayColor: colors.text, bodyColor: colors.text).copyWith(
        displayLarge: base.displayLarge?.copyWith(fontSize: 34.sp, fontWeight: FontWeight.w700),
        displayMedium: base.displayMedium?.copyWith(fontSize: 32.sp, fontWeight: FontWeight.w600),
        displaySmall: base.displaySmall?.copyWith(fontSize: 30.sp, fontWeight: FontWeight.w600),
        headlineLarge: base.headlineLarge?.copyWith(fontSize: 28.sp, fontWeight: FontWeight.w600),
        headlineMedium: base.headlineMedium?.copyWith(fontSize: 26.sp, fontWeight: FontWeight.w600),
        headlineSmall: base.headlineSmall?.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w500),
        titleLarge: base.titleLarge?.copyWith(fontSize: 22.sp, fontWeight: FontWeight.w500),
        titleMedium: base.titleMedium?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w500),
        titleSmall: base.titleSmall?.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500),
        bodyLarge: base.bodyLarge?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400),
        bodyMedium: base.bodyMedium?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400),
        bodySmall: base.bodySmall?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400),
        labelLarge: base.labelLarge?.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w500),
        labelMedium: base.labelMedium?.copyWith(fontSize: 8.sp, fontWeight: FontWeight.w500),
        labelSmall: base.labelSmall?.copyWith(fontSize: 6.sp, fontWeight: FontWeight.w500),
      );
}
