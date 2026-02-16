import 'package:flutter/material.dart';

const AppColors lightColors = AppColors(
  background: Color(0xFFFFFFFF),
  card: Color(0xFFF5F5F5),
  shadow: Color(0xFFE8E8E8),
  divider: Color(0xFFD0D5DD),
  disabled: Color(0xFFA0A0A0),
  hint: Color(0xFF606060),
  text: Colors.black,
  icon: Color(0xFF606060),
);

const AppColors darkColors = AppColors(
  background: Color(0xFF1E1E1E),
  card: Color(0xFF2A2A2A),
  shadow: Color(0xFF3A3A3A),
  divider: Color(0xFF3F3F3F),
  disabled: Color(0xFFB0B0B0),
  hint: Color(0xFF909090),
  text: Colors.white,
  icon: Color(0xFF909090),
);

/// Model-based color palette for the app.
///
/// Usage:
///   - Brand colors (shared): `AppColors.primary`, `AppColors.secondary` (const-safe)
///   - Theme colors: `lightColors.background`, `darkColors.card`, etc.
class AppColors {
  final Color background;
  final Color card;
  final Color shadow;
  final Color divider;
  final Color disabled;
  final Color hint;
  final Color text;
  final Color icon;

  const AppColors({
    required this.background,
    required this.card,
    required this.shadow,
    required this.divider,
    required this.disabled,
    required this.hint,
    required this.text,
    required this.icon,
  });

  // ─── Brand colors (shared across themes, const-safe) ───────
  static const Color primary = Color(0xFF6949FF);
  static const Color secondary = Color(0xFFD27579);
  static const Color transparent = Colors.transparent;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [secondary, primary],
    stops: [0.2, 1.0],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );
}
