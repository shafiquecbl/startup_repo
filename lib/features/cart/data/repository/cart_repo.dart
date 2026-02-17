import 'package:startup_repo/core/api/api_result.dart';
import 'package:http/http.dart';

abstract class CartRepo {
  Future<ApiResult<Response>> getCart();
  Future<ApiResult<Response>> addToCart(Map<String, dynamic> body);
  Future<ApiResult<Response>> updateCartItem(String id, Map<String, dynamic> body);
  Future<ApiResult<Response>> removeCartItem(String id);
  Future<ApiResult<Response>> applyPromo(String code);
}
