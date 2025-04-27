import 'package:startup_repo/imports.dart';

TextButtonThemeData get textButtonTheme => TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        textStyle: TextStyle(fontSize: 14.sp),
        padding: EdgeInsets.zero,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      ),
    );
