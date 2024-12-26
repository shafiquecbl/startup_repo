import '../../imports.dart';

Future showConfirmationDialog({
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
        padding: paddingDefault,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title.tr,
              style: bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
            ),
            Divider(height: spacingLarge),
            Text(
              subtitle.tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: spacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: PrimaryOutlineButton(
                    text: 'cancel'.tr,
                    onPressed: pop,
                    textColor: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                SizedBox(width: spacingDefault),
                Expanded(child: PrimaryButton(text: actionText, onPressed: onAccept)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
