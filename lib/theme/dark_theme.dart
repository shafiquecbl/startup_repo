import 'package:flutter/material.dart';
import 'package:startup_repo/theme/src/dropdown_theme.dart';
import 'package:startup_repo/utils/colors.dart';
import 'src/appbar_theme.dart';
import 'src/bottom_sheet_theme.dart';
import 'src/dialog_theme.dart';
import 'src/divider_theme.dart';
import 'src/elevated_button_theme.dart';
import 'src/icon_theme.dart';
import 'src/input_decoration_theme.dart';
import 'src/outline_button_theme.dart';
import 'src/text_theme.dart';
import 'src/textbuton_theme.dart';

ThemeData dark(BuildContext context) => ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      disabledColor: disabledColorDark,
      scaffoldBackgroundColor: backgroundColorDark,
      hintColor: hintColorDark,
      cardColor: cardColorDark,
      shadowColor: shadowColorDark,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, secondary: primaryColor).copyWith(
        outline: dividerColorDark,
        surface: cardColorDark,
      ),
      textTheme: texThemeDark(context),
      iconTheme: iconThemeDark(context),
      appBarTheme: appBarThemeDark(context),
      elevatedButtonTheme: elevatedButtonThemeData(context),
      outlinedButtonTheme: outlinedButtonThemeData(context),
      textButtonTheme: textButtonTheme(context),
      inputDecorationTheme: inputDecorationThemeDark(context),
      dropdownMenuTheme: dropdownMenuThemeDark(context),
      dialogTheme: dialogThemeDark(context),
      bottomSheetTheme: bottomSheetThemeDark(context),
      dividerTheme: dividerThemeDark(context),
    );
