import 'package:startup_repo/imports.dart';

DialogThemeData dialogTheme(AppColors colors) => DialogThemeData(
      shape: AppRadius.r16Shape,
      backgroundColor: colors.background,
      insetPadding: AppPadding.p32,
    );
