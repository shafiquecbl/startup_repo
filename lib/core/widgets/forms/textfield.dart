import 'package:startup_repo/imports.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final AppIconData? prefixIcon;
  final AppIconData? suffixIcon;
  final bool obscureText;
  final EdgeInsetsGeometry? padding;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final int? minLines;
  final int maxLines;
  final bool autofocus;
  final bool enabled;
  final void Function()? onTap;
  final FocusNode? focusNode;

  const CustomTextField({
    this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.padding,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.minLines,
    this.maxLines = 1,
    this.autofocus = false,
    this.enabled = true,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsetsDirectional.only(top: labelText != null ? 16.sp : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (labelText != null) ...[
            // title
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(labelText ?? '', style: context.font14.copyWith(fontWeight: FontWeight.w700)),
            ),
            SizedBox(height: 8.sp),
          ],
          TextFormField(
            onTapOutside: (PointerDownEvent event) => FocusScope.of(context).unfocus(),
            controller: controller,
            obscureText: obscureText,
            minLines: obscureText ? 1 : minLines,
            maxLines: obscureText ? 1 : maxLines,
            validator: validator,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            onSaved: onSaved,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            autofocus: autofocus,
            enabled: enabled,
            onTap: onTap,
            focusNode: focusNode,
            decoration: InputDecoration(
              prefixIcon: prefixIcon != null
                  ? AppIcon(icon: prefixIcon!, size: 20.sp, color: context.theme.hintColor)
                  : null,
              suffixIcon: suffixIcon != null
                  ? AppIcon(icon: suffixIcon!, size: 20.sp, color: context.theme.hintColor)
                  : null,
              hintText: hintText,
            ),
            style: context.font14.copyWith(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}

class CustomDropDown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? labelText;
  final String? hintText;
  const CustomDropDown({
    required this.items,
    this.labelText,
    required this.onChanged,
    this.hintText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(labelText ?? '', style: context.font14.copyWith(fontWeight: FontWeight.w700)),
          ),
          SizedBox(height: 8.sp),
        ],
        DropdownButtonFormField<T>(
          decoration: InputDecoration(labelText: hintText),
          dropdownColor: Theme.of(context).cardColor,
          style: context.font14,
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
