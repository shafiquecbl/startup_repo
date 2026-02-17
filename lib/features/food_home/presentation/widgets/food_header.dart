import 'package:startup_repo/features/cart/presentation/controller/cart_controller.dart';
import 'package:startup_repo/features/cart/presentation/view/cart_screen.dart';
import 'package:startup_repo/imports.dart';

class FoodHeader extends StatelessWidget {
  const FoodHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.sp, 16.sp, 16.sp, 8.sp),
      child: Row(
        children: [
          // Delivery address
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivering to', style: context.font12.copyWith(color: AppColors.primary)),
                SizedBox(height: 2.sp),
                Row(
                  children: [
                    Text('Home — Riyadh, KSA', style: context.font16.copyWith(fontWeight: FontWeight.w700)),
                    SizedBox(width: 4.sp),
                    Icon(Iconsax.arrow_down_1, size: 16.sp),
                  ],
                ),
              ],
            ),
          ),

          // Cart icon with badge
          GetBuilder<CartController>(
            builder: (cart) {
              return GestureDetector(
                onTap: () => AppNav.push(const CartScreen()),
                child: Container(
                  padding: AppPadding.p8,
                  decoration: ShapeDecoration(
                    color: AppColors.primary.withAlpha(25),
                    shape: AppRadius.r16Shape,
                  ),
                  child: Badge(
                    isLabelVisible: cart.itemCount > 0,
                    label: Text('${cart.itemCount}', style: const TextStyle(fontSize: 10)),
                    child: Icon(Iconsax.bag_2, color: AppColors.primary, size: 24.sp),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
