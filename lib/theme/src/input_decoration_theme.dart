import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:startup_repo/utils/colors.dart';
import 'package:startup_repo/utils/style.dart';

InputDecorationTheme inputDecorationThemeLight(BuildContext context) => InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: cardColorLight,
      contentPadding: paddingDefault,
      // borders
      enabledBorder: border(color: dividerColorLight),
      disabledBorder: border(),
      focusedBorder: border(),
      errorBorder: border(color: context.theme.colorScheme.error),
      focusedErrorBorder: border(color: context.theme.colorScheme.error),
      // styles
      errorStyle: bodySmall(context).copyWith(color: context.theme.colorScheme.error),
      hintStyle: bodySmall(context).copyWith(color: hintColorLight),
      labelStyle: bodyMedium(context).copyWith(color: hintColorLight),
    );

InputDecorationTheme inputDecorationThemeDark(BuildContext context) =>
    inputDecorationThemeLight(context).copyWith(
      fillColor: cardColorDark,
      hintStyle: bodyMedium(context).copyWith(color: hintColorDark),
      labelStyle: bodyMedium(context).copyWith(color: hintColorDark),
      enabledBorder: border(color: dividerColorDark),
    );

InputBorder border({Color? color}) => OutlineInputBorder(
      borderSide: BorderSide(color: color ?? primaryColor, width: 1.sp),
      borderRadius: borderRadiusDefault,
    );
