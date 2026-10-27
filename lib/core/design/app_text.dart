import 'package:flutter/material.dart';

extension AppText on BuildContext {
  TextTheme get _textTheme => Theme.of(this).textTheme;

  TextStyle get font57 => _textTheme.displayLarge!;

  TextStyle get font45 => _textTheme.displayMedium!;

  TextStyle get font36 => _textTheme.displaySmall!;

  TextStyle get font32 => _textTheme.headlineLarge!;

  TextStyle get font28 => _textTheme.headlineMedium!;

  TextStyle get font24 => _textTheme.headlineSmall!;

  TextStyle get font22 => _textTheme.titleLarge!;

  TextStyle get font16Title => _textTheme.titleMedium!;

  TextStyle get font14Title => _textTheme.titleSmall!;

  TextStyle get font16 => _textTheme.bodyLarge!;

  TextStyle get font14 => _textTheme.bodyMedium!;

  TextStyle get font12 => _textTheme.bodySmall!;

  TextStyle get font14Label => _textTheme.labelLarge!;

  TextStyle get font12Label => _textTheme.labelMedium!;

  TextStyle get font11 => _textTheme.labelSmall!;
}
