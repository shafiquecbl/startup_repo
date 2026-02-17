import 'package:startup_repo/imports.dart';

/// A standardized empty state widget for screens with no data.
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppPadding.p24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64.sp, color: Theme.of(context).hintColor),
            SizedBox(height: 16.sp),
            Text(
              title.tr,
              style: context.font16.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: 8.sp),
              Text(
                subtitle!.tr,
                style: context.font14.copyWith(color: Theme.of(context).hintColor),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              SizedBox(height: 24.sp),
              PrimaryButton(text: actionText!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

/// A standardized error state widget with retry option.
class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorStateWidget({required this.message, this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppPadding.p24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.warning_2, size: 64.sp, color: Theme.of(context).colorScheme.error),
            SizedBox(height: 16.sp),
            Text(
              message.tr,
              style: context.font14.copyWith(color: Theme.of(context).hintColor),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: 24.sp),
              PrimaryOutlineButton(
                text: 'retry'.tr,
                onPressed: onRetry,
                icon: Icon(Iconsax.refresh, size: 18.sp),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
