import 'package:flutter/material.dart';
import 'package:startup_repo/core/theme/src/dropdown_theme.dart';
import 'package:startup_repo/core/theme/src/text_theme.dart';
import 'package:startup_repo/core/design/design_system.dart';
import 'src/appbar_theme.dart';
import 'src/bottom_sheet_theme.dart';
import 'src/dialog_theme.dart';
import 'src/divider_theme.dart';
import 'src/elevated_button_theme.dart';
import 'src/icon_theme.dart';
import 'src/input_decoration_theme.dart';
import 'src/outline_button_theme.dart';
import 'src/textbuton_theme.dart';

ThemeData get dark => ThemeData(
      fontFamily: 'Poppins',
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      disabledColor: disabledColorDark,
      scaffoldBackgroundColor: backgroundColorDark,
      hintColor: hintColorDark,
      cardColor: cardColorDark,
      shadowColor: shadowColorDark,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, secondary: primaryColor).copyWith(
        outline: dividerColorDark,
        surface: cardColorDark,
        brightness: Brightness.dark,
      ),
      textTheme: darkTextTheme,
      iconTheme: iconThemeDark,
      appBarTheme: appBarThemeDark,
      elevatedButtonTheme: elevatedButtonThemeData,
      outlinedButtonTheme: outlinedButtonThemeData,
      textButtonTheme: textButtonTheme,
      inputDecorationTheme: inputDecorationThemeDark,
      dropdownMenuTheme: dropdownMenuThemeDark,
      dialogTheme: dialogThemeDark,
      bottomSheetTheme: bottomSheetThemeDark,
      dividerTheme: dividerThemeDark,
    );
