import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';

ThemeData get lightTheme => ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      primaryColor: primaryColor,
      disabledColor: disabledColorLight,
      scaffoldBackgroundColor: backgroundColorLight,
      brightness: null,
      hintColor: hintColorLight,
      cardColor: cardColorLight,
      dividerColor: dividerColorLight,
      shadowColor: shadowColorLight,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, secondary: primaryColor).copyWith(
        outline: dividerColorLight,
      ),
      iconTheme: IconThemeData(color: iconColorLight, size: 24.sp),
      textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          displayLarge: TextStyle(fontSize: 34.0.sp, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 32.0.sp, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontSize: 30.0.sp, fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(fontSize: 28.0.sp, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 26.0.sp, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontSize: 24.0.sp, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 22.0.sp, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(fontSize: 18.0.sp, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.normal),
          bodyMedium: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.normal),
          bodySmall: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.normal),
          labelLarge: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.normal),
          labelMedium: TextStyle(fontSize: 8.0.sp, fontWeight: FontWeight.normal),
          labelSmall: TextStyle(fontSize: 6.0.sp, fontWeight: FontWeight.normal),
        ),
      ).apply(
        displayColor: textColorLight,
        bodyColor: textColorLight,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16.sp,
        color: backgroundColorLight,
        surfaceTintColor: backgroundColorLight,
        shadowColor: backgroundColorLight,
        iconTheme: IconThemeData(color: iconColorLight, size: 24.sp),
        titleTextStyle: GoogleFonts.poppins(fontSize: 22.sp, color: textColorLight),
        centerTitle: false,
      ),
    );
