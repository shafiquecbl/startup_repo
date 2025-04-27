import 'package:startup_repo/imports.dart';
import '../../utils/app_radius.dart';

BottomSheetThemeData get bottomSheetThemeLight => BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.top(AppRadius.radius16)),
      backgroundColor: backgroundColorLight,
      modalBackgroundColor: backgroundColorLight,
      elevation: 0,
    );

BottomSheetThemeData get bottomSheetThemeDark => bottomSheetThemeLight.copyWith(
      backgroundColor: backgroundColorDark,
      modalBackgroundColor: backgroundColorDark,
    );
