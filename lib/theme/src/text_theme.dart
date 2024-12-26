import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:startup_repo/utils/colors.dart';

TextTheme texThemeLight(BuildContext context) => GoogleFonts.poppinsTextTheme(TextTheme(
      displayLarge: TextStyle(fontSize: 34.0.sp, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 32.0.sp, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 30.0.sp, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontSize: 28.0.sp, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(fontSize: 26.0.sp, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(fontSize: 24.0.sp, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontSize: 22.0.sp, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(fontSize: 18.0.sp, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.normal),
      bodySmall: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.normal),
      labelLarge: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.normal),
      labelMedium: TextStyle(fontSize: 8.0.sp, fontWeight: FontWeight.normal),
      labelSmall: TextStyle(fontSize: 6.0.sp, fontWeight: FontWeight.normal),
    )).apply(displayColor: textColorLight, bodyColor: textColorLight);

TextTheme texThemeDark(BuildContext context) =>
    texThemeLight(context).copyWith().apply(displayColor: textColorDark, bodyColor: textColorDark);
