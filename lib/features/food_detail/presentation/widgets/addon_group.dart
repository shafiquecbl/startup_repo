import 'package:startup_repo/imports.dart';
import '../../../food_home/presentation/utils/food_formatters.dart';
import '../../data/model/food_addon.dart';

class AddonGroupWidget extends StatelessWidget {
  final AddonGroup group;
  final Set<String> selectedAddonIds;
  final ValueChanged<FoodAddon> onAddonToggled;

  const AddonGroupWidget({
    super.key,
    required this.group,
    required this.selectedAddonIds,
    required this.onAddonToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.horizontal(16),
      child: Column(
        children: group.addons.map((addon) {
          final bool isSelected = selectedAddonIds.contains(addon.id);
          final bool isRadio = group.maxSelections == 1;

          return Padding(
            padding: EdgeInsets.only(bottom: 6.sp),
            child: GestureDetector(
              onTap: () => onAddonToggled(addon),
              child: Material(
                color: isSelected ? AppColors.primary.withAlpha(12) : Theme.of(context).cardColor,
                shape: RoundedSuperellipseBorder(
                  borderRadius: AppRadius.r16,
                  side: BorderSide(color: isSelected ? AppColors.primary : Colors.transparent, width: 1.5),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
                  child: Row(
                    children: [
                      // Radio / Checkbox indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 20.sp,
                        height: 20.sp,
                        decoration: ShapeDecoration(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          shape: isRadio
                              ? const CircleBorder()
                              : RoundedSuperellipseBorder(
                                  borderRadius: AppRadius.r4,
                                  side: BorderSide(
                                    color: isSelected ? AppColors.primary : Theme.of(context).hintColor,
                                    width: 1.5,
                                  ),
                                ),
                        ),
                        child: isSelected ? Icon(Icons.check, size: 14.sp, color: Colors.white) : null,
                      ),

                      SizedBox(width: 12.sp),

                      // Addon name
                      Expanded(
                        child: Text(
                          addon.name,
                          style: context.font14.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),

                      // Price
                      Text(
                        FoodFormatters.formatAddonPrice(addon.price),
                        style: context.font12.copyWith(
                          color: addon.price == 0 ? Colors.green : AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
