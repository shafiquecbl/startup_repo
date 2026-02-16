import 'package:startup_repo/imports.dart';

BottomSheetThemeData bottomSheetTheme(AppColors colors) => BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.top(16)),
      backgroundColor: colors.background,
      modalBackgroundColor: colors.background,
      elevation: 0,
    );
