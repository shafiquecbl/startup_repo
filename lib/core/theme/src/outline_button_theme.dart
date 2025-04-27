import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/utils/app_radius.dart';
import 'package:startup_repo/core/utils/colors.dart';

OutlinedButtonThemeData get outlinedButtonThemeData => OutlinedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0), // No shadow
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 50.sp)), // Full width
        shape: WidgetStateProperty.all(AppRadius.circular16Shape),
        textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 14.sp, color: primaryColor)),
      ),
    );
