import 'package:startup_repo/features/food_detail/data/model/food_detail.dart';
import '../../data/model/food_item.dart';
import '../../data/model/dummy/dummy_home_data.dart';

abstract class FoodService {
  Future<FoodHomeData> fetchHome();
  Future<FoodDetail?> fetchFoodDetail(String id);
  Future<List<FoodItem>> fetchByCategory(String categoryId);
}
