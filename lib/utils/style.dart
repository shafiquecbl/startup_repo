import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Padding and BorderRadius
EdgeInsets pagePadding = EdgeInsets.all(16.sp);
double get radius => 16.sp;
BorderRadius get borderRadius => BorderRadius.circular(16.sp);

// Text Styles (using Theme.of(context).textTheme)
TextStyle displayLarge(BuildContext context) => Theme.of(context).textTheme.displayLarge!;
TextStyle displayMedium(BuildContext context) => Theme.of(context).textTheme.displayMedium!;
TextStyle displaySmall(BuildContext context) => Theme.of(context).textTheme.displaySmall!;
TextStyle headlineLarge(BuildContext context) => Theme.of(context).textTheme.headlineLarge!;
TextStyle headlineMedium(BuildContext context) => Theme.of(context).textTheme.headlineMedium!;
TextStyle headlineSmall(BuildContext context) => Theme.of(context).textTheme.headlineSmall!;
TextStyle titleLarge(BuildContext context) => Theme.of(context).textTheme.titleLarge!;
TextStyle titleMedium(BuildContext context) => Theme.of(context).textTheme.titleMedium!;
TextStyle titleSmall(BuildContext context) => Theme.of(context).textTheme.titleSmall!;
TextStyle bodyLarge(BuildContext context) => Theme.of(context).textTheme.bodyLarge!;
TextStyle bodyMedium(BuildContext context) => Theme.of(context).textTheme.bodyMedium!;
TextStyle bodySmall(BuildContext context) => Theme.of(context).textTheme.bodySmall!;
TextStyle labelLarge(BuildContext context) => Theme.of(context).textTheme.labelLarge!;
TextStyle labelMedium(BuildContext context) => Theme.of(context).textTheme.labelMedium!;
TextStyle labelSmall(BuildContext context) => Theme.of(context).textTheme.labelSmall!;
