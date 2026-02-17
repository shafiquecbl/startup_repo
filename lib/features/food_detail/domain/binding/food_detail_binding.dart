import 'package:startup_repo/imports.dart';
import 'package:startup_repo/features/food_home/domain/service/food_service.dart';
import '../../presentation/controller/food_detail_controller.dart';

class FoodDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FoodDetailController(foodService: Get.find<FoodService>()));
  }
}
