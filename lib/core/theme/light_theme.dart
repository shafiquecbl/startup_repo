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

ThemeData get light => ThemeData(
      fontFamily: 'Poppins',
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      disabledColor: lightColors.disabled,
      scaffoldBackgroundColor: lightColors.background,
      hintColor: lightColors.hint,
      cardColor: lightColors.card,
      shadowColor: lightColors.shadow,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, secondary: AppColors.primary).copyWith(
        outline: lightColors.divider,
        surface: darkColors.card,
        brightness: Brightness.light,
      ),
      textTheme: textTheme(lightColors),
      iconTheme: iconTheme(lightColors),
      appBarTheme: appBarTheme(lightColors),
      elevatedButtonTheme: elevatedButtonThemeData,
      outlinedButtonTheme: outlinedButtonThemeData,
      textButtonTheme: textButtonTheme,
      inputDecorationTheme: inputDecorationTheme(lightColors),
      dropdownMenuTheme: dropdownMenuTheme(lightColors),
      dialogTheme: dialogTheme(lightColors),
      bottomSheetTheme: bottomSheetTheme(lightColors),
      dividerTheme: dividerTheme(lightColors),
    );
