import 'package:flutter/material.dart';
import 'package:startup_repo/core/design/app_radius.dart';
import 'package:startup_repo/core/design/colors.dart';

CardThemeData cardTheme(AppColors colors) =>
    CardThemeData(color: colors.card, shape: AppRadius.r16Shape, elevation: 0, margin: EdgeInsets.zero);
