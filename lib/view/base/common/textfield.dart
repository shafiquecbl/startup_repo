import 'package:startup_repo/imports.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final EdgeInsetsGeometry? padding;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function()? onTap;

  const CustomTextField(
      {this.controller,
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
      this.onTap,
      this.prefixIcon,
      this.suffixIcon,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsetsDirectional.only(top: labelText != null ? spacingDefault : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (labelText != null) ...[
            // title
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(labelText ?? '', style: bodyMedium(context).copyWith(fontWeight: FontWeight.w700)),
            ),
            SizedBox(height: spacingSmall),
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
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, size: 20.sp, color: Theme.of(context).hintColor)
                  : null,
              suffixIcon: suffixIcon != null
                  ? Icon(suffixIcon, size: 20.sp, color: Theme.of(context).hintColor)
                  : null,
              hintText: hintText,
            ),
            style: bodyMedium(context).copyWith(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}

class CustomDropDown extends StatelessWidget {
  final List<DropdownMenuItem> items;
  final Function(dynamic) onChanged;
  final String? labelText;
  final String? hintText;
  const CustomDropDown(
      {required this.items, this.labelText, required this.onChanged, this.hintText, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(labelText ?? '', style: bodyMedium(context).copyWith(fontWeight: FontWeight.w700)),
          ),
          SizedBox(height: spacingSmall),
        ],
        DropdownButtonFormField(
          decoration: InputDecoration(labelText: hintText),
          dropdownColor: Theme.of(context).cardColor,
          style: bodyMedium(context),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
