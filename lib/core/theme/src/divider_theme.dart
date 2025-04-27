import 'package:flutter/material.dart';
import 'package:startup_repo/core/utils/colors.dart';

DividerThemeData get dividerThemeLight =>
    const DividerThemeData(thickness: 0.5, color: dividerColorLight, space: 0);

DividerThemeData get dividerThemeDark => dividerThemeLight.copyWith(color: dividerColorDark);
