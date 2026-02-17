import 'package:startup_repo/imports.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Widget? icon;
  final bool isLoading;
  const PrimaryButton({required this.text, this.onPressed, this.icon, this.isLoading = false, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const Loading(size: 20)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[icon!, SizedBox(width: 8.sp)],
                Text(text.tr, style: context.font12.copyWith(fontWeight: FontWeight.w600)),
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
  final bool isLoading;
  const PrimaryOutlineButton({
    required this.onPressed,
    this.text,
    this.icon,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const Loading(size: 20)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[icon!, SizedBox(width: 8.sp)],
                if (text != null) Text(text!, style: context.font12.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
    );
  }
}
