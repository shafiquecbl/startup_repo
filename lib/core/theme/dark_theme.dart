import 'package:flutter/material.dart';
import 'package:startup_repo/core/design/colors.dart';
import 'src/appbar_theme.dart';
import 'src/bottom_sheet_theme.dart';
import 'src/dialog_theme.dart';
import 'src/divider_theme.dart';
import 'src/dropdown_theme.dart';
import 'src/elevated_button_theme.dart';
import 'src/icon_theme.dart';
import 'src/input_decoration_theme.dart';
import 'src/outline_button_theme.dart';
import 'src/text_theme.dart';
import 'src/textbuton_theme.dart';
import 'src/card_theme.dart';

ThemeData get dark => ThemeData(
  fontFamily: 'Poppins',
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: AppColors.primary,
  disabledColor: darkColors.disabled,
  scaffoldBackgroundColor: darkColors.background,
  hintColor: darkColors.hint,
  cardColor: darkColors.card,
  shadowColor: darkColors.shadow,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    secondary: AppColors.primary,
  ).copyWith(outline: darkColors.divider, surface: darkColors.card, brightness: Brightness.dark),
  textTheme: textTheme(darkColors),
  iconTheme: iconTheme(darkColors),
  appBarTheme: appBarTheme(darkColors),
  elevatedButtonTheme: elevatedButtonThemeData,
  outlinedButtonTheme: outlinedButtonThemeData,
  textButtonTheme: textButtonTheme,
  inputDecorationTheme: inputDecorationTheme(darkColors),
  dropdownMenuTheme: dropdownMenuTheme(darkColors),
  dialogTheme: dialogTheme(darkColors),
  bottomSheetTheme: bottomSheetTheme(darkColors),
  dividerTheme: dividerTheme(darkColors),
  cardTheme: cardTheme(darkColors),
);
