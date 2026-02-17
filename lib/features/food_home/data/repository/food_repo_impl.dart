import 'package:startup_repo/core/api/api_client.dart';
import 'package:startup_repo/core/api/api_result.dart';
import 'package:startup_repo/core/utils/app_constants.dart';
import 'package:http/http.dart';
import 'food_repo.dart';

class FoodRepoImpl extends FoodRepo {
  final ApiClient client;
  FoodRepoImpl({required this.client});

  @override
  Future<ApiResult<Response>> fetchHome() async {
    return await client.get(AppConstants.foodHome);
  }

  @override
  Future<ApiResult<Response>> fetchFoodDetail(String id) async {
    return await client.get('${AppConstants.foodDetail}$id');
  }

  @override
  Future<ApiResult<Response>> fetchByCategory(String categoryId) async {
    return await client.get(AppConstants.foodByCategory, queryParams: {'category_id': categoryId});
  }
}
