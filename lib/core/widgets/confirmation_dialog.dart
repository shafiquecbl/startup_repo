import 'package:startup_repo/core/utils/app_padding.dart';
import 'package:startup_repo/core/utils/design_system.dart';
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
        padding: AppPadding.padding16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title.tr,
              style: context.font16.copyWith(fontWeight: FontWeight.w700),
            ),
            Divider(height: AppSize.s24),
            Text(subtitle.tr, textAlign: TextAlign.center, style: context.font14),
            SizedBox(height: AppSize.s24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: PrimaryOutlineButton(
                    text: 'cancel'.tr,
                    onPressed: pop,
                    textColor: context.textTheme.bodyLarge!.color,
                  ),
                ),
                SizedBox(width: AppSize.s16),
                Expanded(child: PrimaryButton(text: actionText, onPressed: onAccept)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
