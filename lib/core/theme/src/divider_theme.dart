import 'package:flutter/material.dart';
import 'package:startup_repo/core/utils/colors.dart';

DividerThemeData dividerThemeLight(BuildContext context) =>
    const DividerThemeData(thickness: 0.5, color: dividerColorLight, space: 0);

DividerThemeData dividerThemeDark(BuildContext context) =>
    dividerThemeLight(context).copyWith(color: dividerColorDark);
