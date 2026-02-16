import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/design/app_padding.dart';
import 'package:startup_repo/core/design/app_radius.dart';
import 'package:startup_repo/core/design/colors.dart';

InputDecorationTheme inputDecorationTheme(AppColors colors) => InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: colors.card,
      contentPadding: AppPadding.p16,
      // borders
      enabledBorder: _border(color: colors.divider),
      disabledBorder: _border(),
      focusedBorder: _border(),
      errorBorder: _border(color: Colors.red),
      focusedErrorBorder: _border(color: Colors.red),
      // styles
      errorStyle: TextStyle(fontSize: 12.sp, color: Colors.red),
      hintStyle: TextStyle(fontSize: 14.sp, color: colors.hint),
      labelStyle: TextStyle(fontSize: 14.sp, color: colors.hint),
    );

InputBorder _border({Color? color}) => OutlineInputBorder(
      borderSide: BorderSide(color: color ?? AppColors.primary, width: 1.sp),
      borderRadius: AppRadius.r16,
    );
