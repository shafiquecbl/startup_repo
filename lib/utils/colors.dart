import 'package:flutter/material.dart';
import '../data/model/env.dart';

Color primaryColor = EnvModel.primaryColor;
Color secondaryColor = EnvModel.secondaryColor;

// background color
const Color backgroundColorDark = Colors.black;
const Color backgroundColorLight = Color(0xFFFFFFFF);

// card color
const Color cardColorDark = Color(0xFF222222);
const Color cardColorLight = Color(0xFFF7F8FA);

// text color
const Color textColordark = Color(0XFFDADADA);
const Color textColorLight = Colors.black;

// shadow color
const Color shadowColorDark = Color(0xFF0A1220);
const Color shadowColorLight = Color(0xFFE8E8E8);

// hint color
const Color hintColorDark = Color(0xFFA4A6A4);
const Color hintColorLight = Color(0xFF9F9F9F);

// disabled color
const Color disabledColorDark = Color(0xffa2a7ad);
const Color disabledColorLight = Color(0xffa2a7ad);

// divider Color
Color dividerColorDark = Colors.grey[800]!;
Color dividerColorLight = Colors.grey[300]!;

// icon color
const Color iconColorDark = Colors.white;
const Color iconColorLight = Colors.black;

// gradient
LinearGradient get primaryGradient => LinearGradient(
      colors: [secondaryColor, primaryColor],
      stops: const [0.2, 1.0],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );
