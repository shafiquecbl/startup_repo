import 'package:startup_repo/imports.dart';

DialogTheme dialogThemeLight(BuildContext context) => DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: borderRadiusDefault),
      backgroundColor: backgroundColorLight,
      insetPadding: EdgeInsets.all(30.sp),
    );

DialogTheme dialogThemeDark(BuildContext context) =>
    dialogThemeLight(context).copyWith(backgroundColor: backgroundColorDark);
