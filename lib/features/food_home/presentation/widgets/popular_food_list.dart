import 'package:startup_repo/imports.dart';
import 'package:startup_repo/features/food_detail/presentation/view/food_detail_screen.dart';

import '../../data/model/food_item.dart';
import '../utils/food_formatters.dart';

class PopularFoodList extends StatelessWidget {
  final List<FoodItem> items;

  const PopularFoodList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.sp,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppPadding.horizontal(16),
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(width: 12.sp),
        itemBuilder: (context, index) {
          return _PopularCard(item: items[index]);
        },
      ),
    );
  }
}

class _PopularCard extends StatelessWidget {
  final FoodItem item;

  const _PopularCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNav.push(FoodDetailScreen(itemId: item.id)),
      child: SizedBox(
        width: 170.sp,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              AppImage(url: item.image, width: 170.sp, height: 110.sp, borderRadius: AppRadius.top(16)),

              // Content
              Padding(
                padding: EdgeInsets.all(10.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: context.font14.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.sp),
                    Text(
                      item.restaurant,
                      style: context.font10.copyWith(color: Theme.of(context).hintColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.sp),
                    Row(
                      children: [
                        Text(
                          FoodFormatters.formatPrice(item.price),
                          style: context.font14.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.star_rounded, size: 14.sp, color: Colors.amber),
                        SizedBox(width: 2.sp),
                        Text(
                          item.rating.toStringAsFixed(1),
                          style: context.font10.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
