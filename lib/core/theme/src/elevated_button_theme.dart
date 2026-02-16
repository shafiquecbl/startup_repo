import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/design/app_radius.dart';
import 'package:startup_repo/core/design/colors.dart';

ElevatedButtonThemeData get elevatedButtonThemeData => ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 50.sp)),
        shape: WidgetStateProperty.all(AppRadius.r16Shape),
        backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
        textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 14.sp, color: Colors.white)),
      ),
    );
