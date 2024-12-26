import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/utils/colors.dart';
import 'package:startup_repo/utils/style.dart';

AppBarTheme appBarThemeLight(BuildContext context) => AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 16.sp,
      color: backgroundColorLight,
      surfaceTintColor: backgroundColorLight,
      shadowColor: backgroundColorLight,
      titleTextStyle: titleMedium(context),
      centerTitle: false,
    );

AppBarTheme appBarThemeDark(BuildContext context) => appBarThemeLight(context).copyWith(
      color: backgroundColorDark,
      surfaceTintColor: backgroundColorDark,
      shadowColor: backgroundColorDark,
    );
