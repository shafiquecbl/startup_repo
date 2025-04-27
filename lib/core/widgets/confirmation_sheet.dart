import 'package:startup_repo/core/utils/app_padding.dart';
import 'package:startup_repo/core/utils/app_size.dart';
import 'package:startup_repo/core/utils/app_text.dart';
import '../../imports.dart';

Future showConfirmationSheet({
  required String title,
  required String subtitle,
  required String actionText,
  required Function() onAccept,
}) {
  return showModalBottomSheet(
    context: Get.context!,
    builder: (context) => ConfirmationSheet(
      title: title,
      subtitle: subtitle,
      actionText: actionText,
      onAccept: onAccept,
    ),
  );
}

class ConfirmationSheet extends StatelessWidget {
  final String title, subtitle, actionText;
  final Function() onAccept;
  const ConfirmationSheet({
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onAccept,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.padding16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(height: AppSize.s16),
          Text(title.tr, style: context.font16.copyWith(fontWeight: FontWeight.w700)),
          SizedBox(height: AppSize.s16),
          Text(
            subtitle.tr,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: AppSize.s24),
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
              SizedBox(width: AppSize.s16),
              Expanded(child: PrimaryButton(text: actionText, onPressed: onAccept)),
            ],
          ),
        ],
      ),
    );
  }
}
