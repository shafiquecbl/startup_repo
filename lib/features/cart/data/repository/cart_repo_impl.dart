import 'package:startup_repo/core/api/api_client.dart';
import 'package:startup_repo/core/api/api_result.dart';
import 'package:startup_repo/core/utils/endpoints.dart';
import 'package:http/http.dart';
import 'cart_repo.dart';

class CartRepoImpl extends CartRepo {
  final ApiClient client;
  CartRepoImpl({required this.client});

  @override
  Future<ApiResult<Response>> getCart() async {
    return await client.get(Endpoints.cart);
  }

  @override
  Future<ApiResult<Response>> addToCart(Map<String, dynamic> body) async {
    return await client.post(Endpoints.cart, body);
  }

  @override
  Future<ApiResult<Response>> updateCartItem(String id, Map<String, dynamic> body) async {
    return await client.put('${Endpoints.cartItem}$id', body);
  }

  @override
  Future<ApiResult<Response>> removeCartItem(String id) async {
    return await client.delete('${Endpoints.cartItem}$id');
  }

  @override
  Future<ApiResult<Response>> applyPromo(String code) async {
    return await client.post(Endpoints.applyPromo, {'code': code});
  }
}
