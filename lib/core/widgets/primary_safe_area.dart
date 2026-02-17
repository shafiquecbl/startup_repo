import 'package:flutter/services.dart';
import '../../imports.dart';

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: color ?? context.theme.scaffoldBackgroundColor,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: context.isDarkMode ? Brightness.dark : Brightness.light,
      ),
      child: child,
    );
  }
}
