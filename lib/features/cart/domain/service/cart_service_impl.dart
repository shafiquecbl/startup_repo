import 'dart:convert';
import 'package:startup_repo/core/api/api_result.dart';
import '../../data/model/cart_item.dart';
import '../../data/repository/cart_repo.dart';
import 'cart_service.dart';

class CartServiceImpl extends CartService {
  final CartRepo cartRepo;
  CartServiceImpl({required this.cartRepo});

  @override
  Future<List<CartItem>> getCart() async {
    final result = await cartRepo.getCart();
    if (result case Success(data: final response)) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['items'] as List).map((i) => CartItem.fromJson(i)).toList();
    }
    return [];
  }

  @override
  Future<bool> addToCart(CartItem item) async {
    final result = await cartRepo.addToCart(item.toJson());
    return result is Success;
  }

  @override
  Future<bool> updateCartItem(CartItem item) async {
    final result = await cartRepo.updateCartItem(item.cartItemId, item.toJson());
    return result is Success;
  }

  @override
  Future<bool> removeCartItem(String cartItemId) async {
    final result = await cartRepo.removeCartItem(cartItemId);
    return result is Success;
  }

  @override
  Future<double?> applyPromo(String code) async {
    final result = await cartRepo.applyPromo(code);
    if (result case Success(data: final response)) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['discount'] as num?)?.toDouble();
    }
    return null;
  }
}
