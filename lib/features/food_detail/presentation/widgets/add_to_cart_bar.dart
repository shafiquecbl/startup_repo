import 'package:startup_repo/imports.dart';

import '../../../food_home/presentation/utils/food_formatters.dart';

class AddToCartBar extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onAddToCart;

  const AddToCartBar({super.key, required this.totalPrice, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.sp, 12.sp, 16.sp, MediaQuery.of(context).padding.bottom + 12.sp),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 16, offset: const Offset(0, -4)),
        ],
      ),
      child: PrimaryButton(
        text: 'Add to Cart • ${FoodFormatters.formatPrice(totalPrice)}',
        onPressed: onAddToCart,
      ),
    );
  }
}
