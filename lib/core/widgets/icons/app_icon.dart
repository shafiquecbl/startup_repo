import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';

typedef AppIconData = List<List<dynamic>>;

class AppIcon extends StatelessWidget {
  const AppIcon({required this.icon, this.size = 24, this.color, this.semanticLabel, super.key});

  final AppIconData icon;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget = HugeIcon(
      icon: icon,
      size: size,
      color: color ?? IconTheme.of(context).color,
      strokeWidth: 1.8,
    );
    if (semanticLabel == null) {
      return iconWidget;
    }
    return Semantics(
      label: semanticLabel,
      image: true,
      child: ExcludeSemantics(child: iconWidget),
    );
  }
}
