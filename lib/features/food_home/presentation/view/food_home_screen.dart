import 'package:startup_repo/core/widgets/primary_safe_area.dart';
import 'package:startup_repo/features/food_home/presentation/widgets/food_list.dart';
import 'package:startup_repo/imports.dart';
import '../controller/food_controller.dart';
import '../widgets/food_header.dart';
import '../widgets/promo_banner_carousel.dart';
import '../widgets/food_category_list.dart';
import '../widgets/popular_food_list.dart';

class FoodHomeScreen extends StatelessWidget {
  const FoodHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryAnnotatedRegion(
      child: Scaffold(
        body: GetBuilder<FoodController>(
          builder: (controller) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const FoodHeader(),

                    SizedBox(height: 16.sp),

                    // Promo banners
                    if (controller.banners.isNotEmpty) PromoBannerCarousel(banners: controller.banners),

                    SizedBox(height: 20.sp),

                    // Categories
                    if (controller.categories.isNotEmpty) ...[
                      Padding(
                        padding: AppPadding.horizontal(16),
                        child: Text(
                          'Categories',
                          style: context.font18.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(height: 12.sp),
                      FoodCategoryList(
                        categories: controller.categories,
                        onCategoryTap: controller.onCategorySelected,
                      ),
                    ],

                    SizedBox(height: 20.sp),

                    // Popular Items
                    if (controller.popularItems.isNotEmpty) ...[
                      Padding(
                        padding: AppPadding.horizontal(16),
                        child: Text(
                          'Popular Now',
                          style: context.font18.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(height: 12.sp),
                      PopularFoodList(items: controller.popularItems),
                    ],

                    SizedBox(height: 20.sp),

                    // All Items
                    Padding(
                      padding: AppPadding.horizontal(16),
                      child: Text('All Items', style: context.font18.copyWith(fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(height: 12.sp),

                    FoodList(items: controller.filteredItems),

                    SizedBox(height: 20.sp),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
