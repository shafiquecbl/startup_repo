import 'package:startup_repo/imports.dart';
import '../controller/food_detail_controller.dart';
import '../widgets/food_detail_header.dart';
import '../widgets/food_detail_body.dart';
import '../widgets/add_to_cart_bar.dart';

class FoodDetailScreen extends StatefulWidget {
  final String itemId;

  const FoodDetailScreen({super.key, required this.itemId});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  @override
  void initState() {
    super.initState();
    FoodDetailController.find.loadFoodDetail(widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<FoodDetailController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.detail == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.warning_2, size: 48.sp, color: Theme.of(context).hintColor),
                  SizedBox(height: 12.sp),
                  Text('Item not found', style: context.font16),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Scrollable content
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero image
                    FoodDetailHeader(imageUrl: controller.detail!.item.image),

                    // Body content
                    const FoodDetailBody(),
                  ],
                ),
              ),

              // Sticky bottom bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AddToCartBar(totalPrice: controller.totalPrice, onAddToCart: controller.onAddToCart),
              ),
            ],
          );
        },
      ),
    );
  }
}
