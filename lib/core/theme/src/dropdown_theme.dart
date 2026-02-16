import 'package:startup_repo/imports.dart';
import 'package:startup_repo/core/theme/src/input_decoration_theme.dart';

DropdownMenuThemeData dropdownMenuTheme(AppColors colors) => DropdownMenuThemeData(
      inputDecorationTheme: inputDecorationTheme(colors),
      textStyle: TextStyle(fontSize: 14.sp, color: colors.hint),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(colors.card),
        shape: WidgetStateProperty.all(AppRadius.r16Shape),
        surfaceTintColor: WidgetStateProperty.all(colors.divider),
      ),
    );
