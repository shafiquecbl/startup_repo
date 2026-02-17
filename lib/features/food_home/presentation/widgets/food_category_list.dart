import 'package:startup_repo/imports.dart';
import '../../data/model/food_category.dart';

class FoodCategoryList extends StatelessWidget {
  final List<FoodCategory> categories;
  final ValueChanged<String> onCategoryTap;

  const FoodCategoryList({super.key, required this.categories, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    // 4 items per row, max 2 rows = 8 slots
    // If categories >= 7: show first 7 + View All (8th)
    // If categories < 7: show all + View All
    const int crossAxisCount = 4;
    const int maxVisible = 7; // reserve 1 slot for View All
    final List<FoodCategory> visible = categories.length > maxVisible
        ? categories.sublist(0, maxVisible)
        : categories;
    final int totalSlots = visible.length + 1; // +1 for View All

    return Padding(
      padding: AppPadding.horizontal(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12.sp,
          crossAxisSpacing: 12.sp,
          childAspectRatio: 1, // square
        ),
        itemCount: totalSlots,
        itemBuilder: (context, index) {
          if (index == visible.length) {
            return _ViewAllChip(onTap: () => onCategoryTap('view_all'));
          }
          final FoodCategory category = visible[index];
          return _CategoryChip(category: category, onTap: () => onCategoryTap(category.id));
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final FoodCategory category;
  final VoidCallback onTap;

  const _CategoryChip({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(category.icon, style: TextStyle(fontSize: 28.sp)),
            SizedBox(height: 4.sp),
            Text(
              category.name,
              style: context.font10.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewAllChip extends StatelessWidget {
  final VoidCallback onTap;

  const _ViewAllChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.primary.withAlpha(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.more, size: 28.sp, color: AppColors.primary),
            SizedBox(height: 4.sp),
            Text(
              'View All',
              style: context.font10.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
