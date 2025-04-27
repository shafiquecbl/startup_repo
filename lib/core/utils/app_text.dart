import 'package:flutter/material.dart';

extension AppText on BuildContext {
  TextStyle get font34 => Theme.of(this).textTheme.displayLarge!;

  TextStyle get font32 => Theme.of(this).textTheme.displayMedium!;

  TextStyle get font30 => Theme.of(this).textTheme.displaySmall!;

  TextStyle get font28 => Theme.of(this).textTheme.headlineLarge!;

  TextStyle get font26 => Theme.of(this).textTheme.headlineMedium!;

  TextStyle get font24 => Theme.of(this).textTheme.headlineSmall!;

  TextStyle get font22 => Theme.of(this).textTheme.titleLarge!;

  TextStyle get font20 => Theme.of(this).textTheme.titleMedium!;

  TextStyle get font18 => Theme.of(this).textTheme.titleSmall!;

  TextStyle get font16 => Theme.of(this).textTheme.bodyLarge!;

  TextStyle get font14 => Theme.of(this).textTheme.bodyMedium!;

  TextStyle get font12 => Theme.of(this).textTheme.bodySmall!;

  TextStyle get font10 => Theme.of(this).textTheme.labelLarge!;

  TextStyle get font8 => Theme.of(this).textTheme.labelMedium!;

  TextStyle get font6 => Theme.of(this).textTheme.labelSmall!;
}
