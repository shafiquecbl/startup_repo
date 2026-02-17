import 'package:startup_repo/imports.dart';
import 'package:startup_repo/features/food_detail/presentation/widgets/quantity_selector.dart';
import '../../../food_home/presentation/utils/food_formatters.dart';
import '../../data/model/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppPadding.p8,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            AppImage(url: item.foodItem.image, width: 80.sp, height: 80.sp, borderRadius: AppRadius.r16),

            SizedBox(width: 10.sp),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + remove button
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.foodItem.name,
                          style: context.font14.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onRemove,
                        child: Icon(Iconsax.trash, size: 16.sp, color: Colors.redAccent),
                      ),
                    ],
                  ),

                  // Customization summary
                  if (item.customizationSummary.isNotEmpty) ...[
                    SizedBox(height: 2.sp),
                    Text(
                      item.customizationSummary,
                      style: context.font10.copyWith(color: Theme.of(context).hintColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  SizedBox(height: 8.sp),

                  // Price + quantity
                  Row(
                    children: [
                      Text(
                        FoodFormatters.formatPrice(item.totalPrice),
                        style: context.font14.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      const Spacer(),
                      QuantitySelector(quantity: item.quantity, onChanged: onQuantityChanged),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
