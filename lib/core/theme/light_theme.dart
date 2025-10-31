import 'package:flutter/material.dart';
import 'package:startup_repo/core/theme/src/text_theme.dart';
import 'package:startup_repo/core/design/colors.dart';
import 'src/dropdown_theme.dart';
import 'src/elevated_button_theme.dart';
import 'src/appbar_theme.dart';
import 'src/icon_theme.dart';
import 'src/input_decoration_theme.dart';
import 'src/outline_button_theme.dart';
import 'src/textbuton_theme.dart';
import 'src/dialog_theme.dart';
import 'src/bottom_sheet_theme.dart';
import 'src/divider_theme.dart';

ThemeData get light => ThemeData(
      fontFamily: 'Poppins',
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      disabledColor: disabledColorLight,
      scaffoldBackgroundColor: backgroundColorLight,
      hintColor: hintColorLight,
      cardColor: cardColorLight,
      shadowColor: shadowColorLight,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, secondary: primaryColor).copyWith(
        outline: dividerColorLight,
        surface: cardColorDark,
        brightness: Brightness.light,
      ),
      textTheme: lightTextTheme,
      iconTheme: iconThemeLight,
      appBarTheme: appBarThemeLight,
      elevatedButtonTheme: elevatedButtonThemeData,
      outlinedButtonTheme: outlinedButtonThemeData,
      textButtonTheme: textButtonTheme,
      inputDecorationTheme: inputDecorationThemeLight,
      dropdownMenuTheme: dropdownMenuThemeLight,
      dialogTheme: dialogThemeLight,
      bottomSheetTheme: bottomSheetThemeLight,
      dividerTheme: dividerThemeLight,
    );
