import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/design/colors.dart';

IconThemeData get iconThemeLight => IconThemeData(color: iconColorLight, size: 22.sp);

IconThemeData get iconThemeDark => iconThemeLight.copyWith(color: iconColorDark);
