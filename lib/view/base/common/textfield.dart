import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/style.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText, hintText;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final Widget? prefix;
  final bool obscureText;
  final EdgeInsetsGeometry? padding;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function()? onTap;
  final double? radius;
  final bool filled;

  const CustomTextField(
      {this.controller,
      this.hintText,
      this.labelText,
      this.suffixIcon,
      this.prefixIcon,
      this.obscureText = false,
      this.padding,
      this.validator,
      this.onChanged,
      this.onSaved,
      this.onSubmitted,
      this.keyboardType,
      this.textInputAction,
      this.onTap,
      this.prefix,
      this.radius,
      this.filled = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsetsDirectional.only(top: labelText == null ? 5 : 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // title
          if (labelText != null) ...[
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(labelText!,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 5),
          ],
          TextFormField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: controller,
            obscureText: obscureText,
            validator: validator,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            onSaved: onSaved,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onTap: onTap,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefixIcon: prefix ??
                  (prefixIcon != null
                      ? Icon(
                          prefixIcon,
                          size: 20,
                          color: Theme.of(context).hintColor,
                        )
                      : null),
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.normal,
                  ),
              errorStyle: const TextStyle(fontWeight: FontWeight.normal),
              enabledBorder: border(context, color: Theme.of(context).cardColor, circular: radius),
              disabledBorder: border(context),
              focusedBorder: border(context, color: Theme.of(context).primaryColor, circular: radius),
              errorBorder: border(context, color: Theme.of(context).colorScheme.error, circular: radius),
              focusedErrorBorder: border(context, circular: radius),
              filled: filled,
              fillColor: Theme.of(context).cardColor.withOpacity(0.4),
              contentPadding: EdgeInsets.all(18.sp),
              suffixIcon: suffixIcon,
            ),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}

InputBorder border(BuildContext context, {Color? color, double? circular}) => OutlineInputBorder(
      borderSide: BorderSide(
        color: color ?? Theme.of(context).primaryColor,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(circular ?? radius),
    );

class CustomDropDown extends StatelessWidget {
  final List<DropdownMenuItem> items;
  final Function(dynamic) onChanged;
  final String? labelText, hintText;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? padding;
  const CustomDropDown(
      {required this.items,
      required this.onChanged,
      this.hintText,
      this.labelText,
      this.suffixIcon,
      this.padding,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // title
          if (labelText != null) ...[
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                labelText!,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).hintColor),
              ),
            ),
            const SizedBox(height: 5),
          ],
          DropdownButtonFormField(
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: hintText,
              labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal),
              enabledBorder: border(context),
              focusedBorder: border(context, color: Theme.of(context).primaryColor),
              errorBorder: border(context, color: Theme.of(context).colorScheme.error),
              focusedErrorBorder: border(context),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              contentPadding: const EdgeInsets.all(15),
              suffixIcon: suffixIcon,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            items: items,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  InputBorder border(BuildContext context, {Color? color}) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color ?? Theme.of(context).cardColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      );
}
