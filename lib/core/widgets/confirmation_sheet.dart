import '../../imports.dart';

class ConfirmationSheet extends StatelessWidget {
  final String title, subtitle, actionText;
  final VoidCallback onAccept;
  const ConfirmationSheet._({
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onAccept,
  });

  /// Shows a confirmation bottom sheet with title, subtitle, and action buttons.
  /// Uses the themed `showModalBottomSheet` — shape comes from `BottomSheetThemeData`.
  static Future<T?> show<T>({
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onAccept,
  }) {
    return showModalBottomSheet<T>(
      context: Get.context!,
      builder: (_) =>
          ConfirmationSheet._(title: title, subtitle: subtitle, actionText: actionText, onAccept: onAccept),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.p16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(color: Theme.of(context).dividerColor, borderRadius: AppRadius.r4),
            ),
          ),
          SizedBox(height: 16.sp),
          Text(title.tr, style: context.font16.copyWith(fontWeight: FontWeight.w700)),
          SizedBox(height: 16.sp),
          Text(subtitle.tr, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: 24.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: PrimaryOutlineButton(text: 'cancel'.tr, onPressed: Get.back),
              ),
              SizedBox(width: 16.sp),
              Expanded(
                child: PrimaryButton(text: actionText, onPressed: onAccept),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
