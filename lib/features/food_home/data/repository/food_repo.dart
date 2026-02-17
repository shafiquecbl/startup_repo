import 'package:startup_repo/core/api/api_result.dart';
import 'package:http/http.dart';

abstract class FoodRepo {
  Future<ApiResult<Response>> fetchHome();
  Future<ApiResult<Response>> fetchFoodDetail(String id);
  Future<ApiResult<Response>> fetchByCategory(String categoryId);
}
