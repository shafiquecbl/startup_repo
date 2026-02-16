import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/design/colors.dart';

AppBarTheme appBarTheme(AppColors colors) => AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 16.sp,
      backgroundColor: colors.background,
      surfaceTintColor: colors.background,
      shadowColor: colors.background,
      titleTextStyle: TextStyle(color: colors.text, fontSize: 18.sp, fontWeight: FontWeight.w600),
      centerTitle: false,
      iconTheme: IconThemeData(color: colors.text),
    );
