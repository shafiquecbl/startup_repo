import 'package:startup_repo/features/food_home/presentation/widgets/food_item_card.dart' show FoodItemCard;
import 'package:startup_repo/imports.dart';
import '../../data/model/food_item.dart';

class FoodList extends StatelessWidget {
  final List<FoodItem> items;
  const FoodList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: AppPadding.horizontal(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.sp),
      itemBuilder: (context, index) {
        final item = items[index];
        return FoodItemCard(item: item);
      },
    );
  }
}
