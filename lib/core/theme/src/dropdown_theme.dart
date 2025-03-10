import 'package:startup_repo/imports.dart';
import 'package:startup_repo/core/theme/src/input_decoration_theme.dart';

DropdownMenuThemeData dropdownMenuThemeLight(BuildContext context) => DropdownMenuThemeData(
      inputDecorationTheme: inputDecorationThemeLight(context),
      textStyle: bodyMedium(context),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(cardColorLight),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: borderRadiusDefault)),
        surfaceTintColor: WidgetStateProperty.all(dividerColorLight),
      ),
    );

DropdownMenuThemeData dropdownMenuThemeDark(BuildContext context) => dropdownMenuThemeLight(context).copyWith(
      inputDecorationTheme: inputDecorationThemeDark(context),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(cardColorDark),
        surfaceTintColor: WidgetStateProperty.all(dividerColorDark),
      ),
    );
