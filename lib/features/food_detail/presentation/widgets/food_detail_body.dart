import 'package:startup_repo/imports.dart';
import '../../data/model/food_detail.dart';
import '../controller/food_detail_controller.dart';
import 'food_detail_info.dart';
import 'size_selector.dart';
import 'addon_group.dart';
import 'quantity_selector.dart';

class FoodDetailBody extends StatelessWidget {
  const FoodDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FoodDetailController>(
      builder: (controller) {
        if (controller.isLoading || controller.detail == null) {
          return const SizedBox.shrink();
        }

        final FoodDetail detail = controller.detail!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info section
            FoodDetailInfo(detail: detail),

            SizedBox(height: 16.sp),

            // Size selector
            if (detail.sizes.isNotEmpty) ...[
              const _SectionTitle(title: 'Choose Size'),
              SizeSelector(
                sizes: detail.sizes,
                selectedSize: controller.selectedSize,
                onSizeSelected: controller.onSizeSelected,
              ),
              SizedBox(height: 16.sp),
            ],

            // Addon groups
            for (final group in detail.addonGroups) ...[
              _SectionTitle(
                title: group.name,
                subtitle: group.isRequired ? 'Required' : 'Optional (up to ${group.maxSelections})',
                isRequired: group.isRequired,
              ),
              AddonGroupWidget(
                group: group,
                selectedAddonIds: controller.selectedAddons[group.id] ?? {},
                onAddonToggled: (addon) => controller.onAddonToggled(group.id, addon),
              ),
              SizedBox(height: 16.sp),
            ],

            // Quantity selector
            const _SectionTitle(title: 'Quantity'),
            Padding(
              padding: AppPadding.horizontal(16),
              child: QuantitySelector(quantity: controller.quantity, onChanged: controller.onQuantityChanged),
            ),

            SizedBox(height: 16.sp),

            // Special instructions
            const _SectionTitle(title: 'Special Instructions'),
            Padding(
              padding: AppPadding.horizontal(16),
              child: TextFormField(
                maxLines: 3,
                onChanged: controller.onInstructionsChanged,
                decoration: const InputDecoration(hintText: 'e.g. No onions, extra sauce on the side...'),
              ),
            ),

            // Bottom spacing for the sticky bar
            SizedBox(height: 100.sp),
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isRequired;

  const _SectionTitle({required this.title, this.subtitle, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.sp, 0, 16.sp, 8.sp),
      child: Row(
        children: [
          Text(title, style: context.font16.copyWith(fontWeight: FontWeight.w600)),
          if (isRequired) ...[
            SizedBox(width: 6.sp),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.sp, vertical: 2.sp),
              decoration: BoxDecoration(color: Colors.redAccent.withAlpha(25), borderRadius: AppRadius.r4),
              child: Text(
                'Required',
                style: context.font8.copyWith(color: Colors.redAccent, fontWeight: FontWeight.w600),
              ),
            ),
          ],
          if (subtitle != null && !isRequired) ...[
            SizedBox(width: 6.sp),
            Text(subtitle!, style: context.font10.copyWith(color: Theme.of(context).hintColor)),
          ],
        ],
      ),
    );
  }
}
