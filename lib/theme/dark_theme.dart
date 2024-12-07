import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';

ThemeData get darkTheme => ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      primaryColor: primaryColor,
      disabledColor: disabledColorDark,
      scaffoldBackgroundColor: backgroundColorDark,
      brightness: null,
      hintColor: hintColorDark,
      cardColor: cardColorDark,
      dividerColor: dividerColorDark,
      shadowColor: shadowColorDark,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryColor),
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, secondary: primaryColor).copyWith(
        outline: dividerColorDark,
      ),
      iconTheme: IconThemeData(color: iconColorDark, size: 24.sp),
      textTheme: GoogleFonts.poppinsTextTheme(TextTheme(
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
      ).apply(
        displayColor: textColordark,
        bodyColor: textColordark,
      )),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16.sp,
        color: backgroundColorDark,
        surfaceTintColor: backgroundColorDark,
        shadowColor: backgroundColorDark,
        iconTheme: IconThemeData(color: iconColorDark, size: 24.sp),
        titleTextStyle: GoogleFonts.poppins(fontSize: 22.sp, color: textColordark),
        centerTitle: false,
      ),
    );
