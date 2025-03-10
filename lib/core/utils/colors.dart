import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF6949FF);
const Color secondaryColor = Color(0xFFD27579);

// background colors
const Color backgroundColorLight = Color(0xFFFFFFFF);
const Color backgroundColorDark = Color(0xFF1E1E1E);

// card colors
const Color cardColorLight = Color(0xFFF5F5F5);
const Color cardColorDark = Color(0xFF2A2A2A);

const Color transparent = Colors.transparent;

// shadow colors
const Color shadowColorLight = Color(0xFFE8E8E8);
const Color shadowColorDark = Color(0xFF3A3A3A);

// divider colors
const Color dividerColorLight = Color(0xFFD0D5DD);
const Color dividerColorDark = Color(0xFF3F3F3F);

// disabled colors
const Color disabledColorLight = Color(0xffA0A0A0);
Color disabledColorDark = const Color(0xFFB0B0B0);

// hint colors
const Color hintColorLight = Color(0xff606060);
const Color hintColorDark = Color(0xFF909090);

// text colors
const Color textColorLight = Colors.black;
const Color textColorDark = Colors.white;

// icon colors
const Color iconColorLight = Color(0xff606060);
const Color iconColorDark = Color(0xFF909090);

// gradient
LinearGradient get primaryGradient => const LinearGradient(
      colors: [secondaryColor, primaryColor],
      stops: [0.2, 1.0],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );
