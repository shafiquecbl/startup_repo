import 'package:startup_repo/imports.dart';
import '../controller/cart_controller.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/promo_code_input.dart';
import '../widgets/order_summary.dart';
import '../widgets/checkout_bar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart', style: context.font18.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Get.back()),
        actions: [
          GetBuilder<CartController>(
            builder: (cart) {
              if (cart.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: cart.clearCart,
                child: Text('Clear', style: context.font12.copyWith(color: Colors.redAccent)),
              );
            },
          ),
        ],
      ),
      body: GetBuilder<CartController>(
        builder: (cart) {
          if (cart.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.bag, size: 64.sp, color: Theme.of(context).hintColor),
                  SizedBox(height: 16.sp),
                  Text('Your cart is empty', style: context.font16.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8.sp),
                  Text(
                    'Add some delicious items!',
                    style: context.font14.copyWith(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Scrollable content
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 120.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cart items
                    Padding(
                      padding: AppPadding.horizontal(16),
                      child: Column(
                        children: cart.items.map((item) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.sp),
                            child: CartItemCard(
                              item: item,
                              onQuantityChanged: (qty) => cart.updateQuantity(item.cartItemId, qty),
                              onRemove: () => cart.removeItem(item.cartItemId),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(height: 16.sp),

                    // Promo code
                    Padding(
                      padding: AppPadding.horizontal(16),
                      child: PromoCodeInput(
                        appliedCode: cart.appliedPromoCode,
                        onApply: cart.applyPromoCode,
                        onRemove: cart.removePromoCode,
                      ),
                    ),

                    SizedBox(height: 16.sp),

                    // Order summary
                    Padding(
                      padding: AppPadding.horizontal(16),
                      child: OrderSummary(
                        subtotal: cart.subtotal,
                        deliveryFee: cart.deliveryFee,
                        discount: cart.discount,
                        total: cart.total,
                      ),
                    ),
                  ],
                ),
              ),

              // Checkout bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CheckoutBar(total: cart.total, itemCount: cart.itemCount, onCheckout: cart.onCheckout),
              ),
            ],
          );
        },
      ),
    );
  }
}
