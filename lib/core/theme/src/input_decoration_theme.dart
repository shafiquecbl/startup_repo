import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/design/app_padding.dart';
import 'package:startup_repo/core/design/app_radius.dart';
import 'package:startup_repo/core/design/colors.dart';

InputDecorationTheme get inputDecorationThemeLight => InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: cardColorLight,
      contentPadding: AppPadding.padding16,
      // borders
      enabledBorder: border(color: dividerColorLight),
      disabledBorder: border(),
      focusedBorder: border(),
      errorBorder: border(color: Colors.red),
      focusedErrorBorder: border(color: Colors.red),
      // styles
      errorStyle: TextStyle(fontSize: 12.sp, color: Colors.red),
      hintStyle: TextStyle(fontSize: 14.sp, color: hintColorLight),
      labelStyle: TextStyle(fontSize: 14.sp, color: hintColorLight),
    );

InputDecorationTheme get inputDecorationThemeDark => inputDecorationThemeLight.copyWith(
      fillColor: cardColorDark,
      hintStyle: TextStyle(fontSize: 14.sp, color: hintColorDark),
      labelStyle: TextStyle(fontSize: 14.sp, color: hintColorDark),
      enabledBorder: border(color: dividerColorDark),
    );

InputBorder border({Color? color}) => OutlineInputBorder(
      borderSide: BorderSide(color: color ?? primaryColor, width: 1.sp),
      borderRadius: AppRadius.circular16,
    );
