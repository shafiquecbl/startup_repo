import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:startup_repo/utils/style.dart';

ElevatedButtonThemeData elevatedButtonThemeData(BuildContext context) => ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0), // No shadow
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 50.sp)), // Full width
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: borderRadiusDefault),
        ), // Rounded corners
        backgroundColor: WidgetStatePropertyAll(context.theme.primaryColor),
        textStyle: WidgetStatePropertyAll(bodyMedium(context).copyWith(color: Colors.white)),
      ),
    );
