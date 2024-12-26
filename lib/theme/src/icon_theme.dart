import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/utils/colors.dart';

IconThemeData iconThemeLight(BuildContext context) => IconThemeData(color: iconColorLight, size: 22.sp);

IconThemeData iconThemeDark(BuildContext context) => iconThemeLight(context).copyWith(color: iconColorDark);
