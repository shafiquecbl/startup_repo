import 'package:startup_repo/imports.dart';
import 'package:startup_repo/features/food_detail/presentation/view/food_detail_screen.dart';
import '../../data/model/food_item.dart';
import '../controller/food_controller.dart';
import '../utils/food_formatters.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem item;

  const FoodItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNav.push(FoodDetailScreen(itemId: item.id)),
      child: Card(
        child: Row(
          children: [
            // Image
            AppImage(url: item.image, width: 110.sp, height: 110.sp, borderRadius: AppRadius.r16),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      item.name,
                      style: context.font16.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.sp),

                    // Description
                    Text(
                      item.description,
                      style: context.font12.copyWith(color: Theme.of(context).hintColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.sp),

                    // Price + info row
                    Row(
                      children: [
                        Text(
                          FoodFormatters.formatPrice(item.price),
                          style: context.font14.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const Spacer(),

                        // Rating
                        Icon(Icons.star_rounded, size: 14.sp, color: Colors.amber),
                        SizedBox(width: 2.sp),
                        Text(item.rating.toStringAsFixed(1), style: context.font10),

                        SizedBox(width: 8.sp),

                        // Delivery time
                        Icon(Iconsax.clock, size: 12.sp, color: Theme.of(context).hintColor),
                        SizedBox(width: 2.sp),
                        Text(
                          FoodFormatters.formatDeliveryTime(item.deliveryTime),
                          style: context.font10.copyWith(color: Theme.of(context).hintColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Favorite button
            Padding(
              padding: EdgeInsets.only(right: 8.sp),
              child: GestureDetector(
                onTap: () => FoodController.find.toggleFavorite(item.id),
                child: Icon(
                  item.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: item.isFavorite ? Colors.redAccent : Theme.of(context).hintColor,
                  size: 22.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
