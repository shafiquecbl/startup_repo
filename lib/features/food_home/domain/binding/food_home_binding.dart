import 'package:startup_repo/imports.dart';
import '../../data/repository/food_repo.dart';
import '../../data/repository/food_repo_impl.dart';
import '../../domain/service/food_service.dart';
import '../../domain/service/food_service_impl.dart';
import '../../presentation/controller/food_controller.dart';

class FoodHomeBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<FoodRepo>(() => FoodRepoImpl(client: Get.find()));

    // Service
    Get.lazyPut<FoodService>(() => FoodServiceImpl(foodRepo: Get.find()));

    // Controller
    Get.lazyPut(() => FoodController(foodService: Get.find()));
  }
}
