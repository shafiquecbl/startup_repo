import 'dart:convert';
import 'package:startup_repo/core/api/api_result.dart';
import 'package:startup_repo/features/food_detail/data/model/food_detail.dart';
import '../../data/model/food_item.dart';
import '../../data/model/dummy/dummy_home_data.dart';
import '../../data/repository/food_repo.dart';
import 'food_service.dart';

class FoodServiceImpl extends FoodService {
  final FoodRepo foodRepo;
  FoodServiceImpl({required this.foodRepo});

  @override
  Future<FoodHomeData> fetchHome() async {
    final result = await foodRepo.fetchHome();
    if (result case Success(data: final response)) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return FoodHomeData.fromJson(data);
    }
    return FoodHomeData.dummy(); // fallback to dummy
  }

  @override
  Future<FoodDetail?> fetchFoodDetail(String id) async {
    final result = await foodRepo.fetchFoodDetail(id);
    if (result case Success(data: final response)) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return FoodDetail.fromJson(data);
    }
    return null;
  }

  @override
  Future<List<FoodItem>> fetchByCategory(String categoryId) async {
    final result = await foodRepo.fetchByCategory(categoryId);
    if (result case Success(data: final response)) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['items'] as List).map((i) => FoodItem.fromJson(i)).toList();
    }
    return [];
  }
}
