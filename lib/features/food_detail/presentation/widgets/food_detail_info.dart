import 'package:startup_repo/imports.dart';
import '../../../food_home/data/model/food_item.dart';
import '../../../food_home/presentation/utils/food_formatters.dart';
import '../../data/model/food_detail.dart';

class FoodDetailInfo extends StatelessWidget {
  final FoodDetail detail;

  const FoodDetailInfo({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final FoodItem item = detail.item;

    return Padding(
      padding: AppPadding.horizontal(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(item.name, style: context.font24.copyWith(fontWeight: FontWeight.w700)),
          SizedBox(height: 4.sp),

          // Restaurant
          Text(item.restaurant, style: context.font14.copyWith(color: Theme.of(context).hintColor)),
          SizedBox(height: 12.sp),

          // Stats row
          Row(
            children: [
              _StatChip(
                icon: Icons.star_rounded,
                iconColor: Colors.amber,
                text: FoodFormatters.formatRating(item.rating, item.ratingCount),
              ),
              SizedBox(width: 12.sp),
              _StatChip(icon: Iconsax.clock, text: FoodFormatters.formatDeliveryTime(item.deliveryTime)),
              SizedBox(width: 12.sp),
              _StatChip(icon: Iconsax.truck, text: FoodFormatters.formatDeliveryFee(item.deliveryFee)),
            ],
          ),
          SizedBox(height: 12.sp),

          // Price
          Text(
            FoodFormatters.formatPrice(item.price),
            style: context.font20.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
          SizedBox(height: 12.sp),

          // Description
          Text(
            detail.fullDescription,
            style: context.font14.copyWith(color: Theme.of(context).hintColor, height: 1.5),
          ),

          // Ingredients + Calories
          if (detail.ingredients.isNotEmpty) ...[
            SizedBox(height: 12.sp),
            Wrap(
              spacing: 6.sp,
              runSpacing: 6.sp,
              children: [
                for (final ingredient in detail.ingredients)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(15),
                      borderRadius: AppRadius.r100,
                    ),
                    child: Text(
                      ingredient,
                      style: context.font10.copyWith(color: AppColors.primary, fontWeight: FontWeight.w500),
                    ),
                  ),
                if (detail.calories > 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
                    decoration: BoxDecoration(
                      color: Colors.orange.withAlpha(20),
                      borderRadius: AppRadius.r100,
                    ),
                    child: Text(
                      '🔥 ${FoodFormatters.formatCalories(detail.calories)}',
                      style: context.font10.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String text;

  const _StatChip({required this.icon, this.iconColor, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: AppRadius.r8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: iconColor ?? Theme.of(context).hintColor),
          SizedBox(width: 4.sp),
          Text(text, style: context.font10.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
