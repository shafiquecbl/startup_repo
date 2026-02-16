import '../../imports.dart';

Future<dynamic> showConfirmationDialog({
  required String title,
  required String subtitle,
  required String actionText,
  required Function() onAccept,
}) {
  return showDialog(
    context: Get.context!,
    builder: (context) => ConfirmationDialog(
      title: title,
      subtitle: subtitle,
      actionText: actionText,
      onAccept: onAccept,
    ),
  );
}

class ConfirmationDialog extends StatelessWidget {
  final String title, subtitle, actionText;
  final Function() onAccept;
  const ConfirmationDialog({
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onAccept,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: AppPadding.p16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title.tr,
              style: context.font16.copyWith(fontWeight: FontWeight.w700),
            ),
            Divider(height: 24.sp),
            Text(subtitle.tr, textAlign: TextAlign.center, style: context.font14),
            SizedBox(height: 24.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: PrimaryOutlineButton(text: 'cancel'.tr, onPressed: Get.back)),
                SizedBox(width: 16.sp),
                Expanded(child: PrimaryButton(text: actionText, onPressed: onAccept)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
