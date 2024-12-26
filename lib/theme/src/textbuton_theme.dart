import 'package:flutter/material.dart';
import 'package:startup_repo/utils/style.dart';

TextButtonThemeData textButtonTheme(BuildContext context) => TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        textStyle: bodyMedium(context),
        padding: EdgeInsets.zero,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      ),
    );
