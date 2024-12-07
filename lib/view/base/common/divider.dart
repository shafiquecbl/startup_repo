import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/theme_controller.dart';

class CustomDivider extends StatelessWidget {
  final double padding;
  final double thickness;
  const CustomDivider({this.padding = 5, this.thickness = 0.5, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: GetBuilder<ThemeController>(builder: (con) {
        return Divider(height: 0, thickness: thickness, color: Theme.of(context).dividerColor);
      }),
    );
  }
}
