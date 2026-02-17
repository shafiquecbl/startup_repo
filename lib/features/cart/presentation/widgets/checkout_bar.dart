import 'package:startup_repo/imports.dart';
import '../../../food_home/presentation/utils/food_formatters.dart';

class CheckoutBar extends StatelessWidget {
  final double total;
  final int itemCount;
  final VoidCallback onCheckout;

  const CheckoutBar({super.key, required this.total, required this.itemCount, required this.onCheckout});

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
      child: Row(
        children: [
          // Total info
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FoodFormatters.formatPrice(total),
                style: context.font20.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              Text(
                '$itemCount item${itemCount > 1 ? 's' : ''}',
                style: context.font10.copyWith(color: Theme.of(context).hintColor),
              ),
            ],
          ),
          SizedBox(width: 16.sp),

          // Checkout button
          Expanded(
            child: PrimaryButton(text: 'Place Order', onPressed: onCheckout),
          ),
        ],
      ),
    );
  }
}
