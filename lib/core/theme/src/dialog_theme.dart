import 'package:startup_repo/core/utils/app_padding.dart';
import 'package:startup_repo/core/utils/app_radius.dart';
import 'package:startup_repo/imports.dart';

DialogTheme get dialogThemeLight => DialogTheme(
      shape: AppRadius.circular16Shape,
      backgroundColor: backgroundColorLight,
      insetPadding: AppPadding.padding32,
    );

DialogTheme get dialogThemeDark => dialogThemeLight.copyWith(backgroundColor: backgroundColorDark);
