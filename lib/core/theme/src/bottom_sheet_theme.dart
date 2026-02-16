import 'package:startup_repo/imports.dart';

BottomSheetThemeData bottomSheetTheme(AppColors colors) => BottomSheetThemeData(
      shape: AppRadius.topShape(16),
      backgroundColor: colors.background,
      modalBackgroundColor: colors.background,
      elevation: 0,
    );
