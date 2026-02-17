import '../../data/model/cart_item.dart';

abstract class CartService {
  Future<List<CartItem>> getCart();
  Future<bool> addToCart(CartItem item);
  Future<bool> updateCartItem(CartItem item);
  Future<bool> removeCartItem(String cartItemId);
  Future<double?> applyPromo(String code);
}
