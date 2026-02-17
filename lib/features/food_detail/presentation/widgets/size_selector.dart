import 'package:startup_repo/imports.dart';

import '../../../food_home/presentation/utils/food_formatters.dart';
import '../../data/model/food_size.dart';

class SizeSelector extends StatelessWidget {
  final List<FoodSize> sizes;
  final FoodSize? selectedSize;
  final ValueChanged<FoodSize> onSizeSelected;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.horizontal(16),
      child: Row(
        children: sizes.map((size) {
          final isSelected = selectedSize?.id == size.id;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.sp),
              child: GestureDetector(
                onTap: () => onSizeSelected(size),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Material(
                    color: isSelected ? AppColors.primary : Theme.of(context).cardColor,
                    shape: AppRadius.r16Shape,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.sp),
                      child: Column(
                        children: [
                          Text(
                            size.name,
                            style: context.font14.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : null,
                            ),
                          ),
                          SizedBox(height: 2.sp),
                          Text(
                            size.priceAdjustment == 0
                                ? 'Base price'
                                : '+${FoodFormatters.formatPrice(size.priceAdjustment)}',
                            style: context.font10.copyWith(
                              color: isSelected ? Colors.white70 : Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
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
