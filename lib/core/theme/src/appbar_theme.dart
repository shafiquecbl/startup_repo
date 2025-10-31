import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/design/colors.dart';

AppBarTheme get appBarThemeLight => AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 16.sp,
      color: backgroundColorLight,
      surfaceTintColor: backgroundColorLight,
      shadowColor: backgroundColorLight,
      titleTextStyle: TextStyle(color: textColorLight, fontSize: 18.sp, fontWeight: FontWeight.w600),
      centerTitle: false,
      iconTheme: const IconThemeData(color: textColorLight),
    );

AppBarTheme get appBarThemeDark => appBarThemeLight.copyWith(
      color: backgroundColorDark,
      surfaceTintColor: backgroundColorDark,
      shadowColor: backgroundColorDark,
      titleTextStyle: TextStyle(color: textColorDark, fontSize: 18.sp, fontWeight: FontWeight.w600),
      iconTheme: const IconThemeData(color: textColorDark),
    );
