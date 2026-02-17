import 'package:startup_repo/imports.dart';
import '../../data/repository/cart_repo.dart';
import '../../data/repository/cart_repo_impl.dart';
import '../service/cart_service.dart';
import '../service/cart_service_impl.dart';
import '../../presentation/controller/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<CartRepo>(() => CartRepoImpl(client: Get.find()));

    // Service
    Get.lazyPut<CartService>(() => CartServiceImpl(cartRepo: Get.find()));

    // Controller
    Get.lazyPut(() => CartController(cartService: Get.find()));
  }
}
