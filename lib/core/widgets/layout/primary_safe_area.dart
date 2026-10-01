import 'package:flutter/services.dart';

import '../../../imports.dart';

class PrimarySafeArea extends StatelessWidget {
  final Widget child;
  const PrimarySafeArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(top: false, bottom: GetPlatform.isAndroid ? true : false, child: child);
  }
}

class PrimaryAnnotatedRegion extends StatelessWidget {
  final Widget child;
  final Color? color;
  const PrimaryAnnotatedRegion({super.key, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = color ?? context.theme.scaffoldBackgroundColor;
    final Brightness iconBrightness = context.isDarkMode ? Brightness.light : Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: iconBrightness,
        systemNavigationBarContrastEnforced: false,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: iconBrightness,
        statusBarBrightness: context.isDarkMode ? Brightness.dark : Brightness.light,
      ),
      child: ColoredBox(color: backgroundColor, child: child),
    );
  }
}
