import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:startup_repo/imports.dart';
import '../../../utils/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Widget? icon;
  final double? radius;
  final Color? color;
  final Color? textColor;
  const PrimaryButton(
      {required this.text, this.onPressed, this.icon, this.color, this.textColor, this.radius, super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = color ?? primaryColor;
    final Color textColor = this.textColor ?? Colors.white;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: Size(100.sp, 55.sp),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 16.sp)),
        disabledBackgroundColor: backgroundColor,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, SizedBox(width: 8.sp)],
          Text(
            text.tr,
            style: bodySmall(context).copyWith(fontWeight: FontWeight.w600, color: textColor),
          ),
        ],
      ),
    );
  }
}

// outline button
class PrimaryOutlineButton extends StatelessWidget {
  final String? text;
  final void Function()? onPressed;
  final Widget? icon;
  final double? radius;
  final Color? textColor;
  const PrimaryOutlineButton(
      {required this.onPressed, this.text, this.icon, this.radius, this.textColor, super.key});

  @override
  Widget build(BuildContext context) {
    final Color textColor = this.textColor ?? primaryColor;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(100.sp, 55.sp),
        side: BorderSide(color: Theme.of(context).dividerColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((radius ?? 16).sp)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, SizedBox(width: 8.sp)],
          if (text != null)
            Text(
              text!,
              style: bodySmall(context).copyWith(fontWeight: FontWeight.w600, color: textColor),
            ),
        ],
      ),
    );
  }
}
