import 'package:startup_repo/features/food_home/data/model/food_item.dart';
import 'food_addon.dart';
import 'food_size.dart';

/// Extended food model with customization options (sizes, addons).
/// Used on the detail screen. Inherits display fields from [FoodItem].
class FoodDetail {
  final FoodItem item;
  final String fullDescription;
  final List<String> ingredients;
  final double calories;
  final List<FoodSize> sizes;
  final List<AddonGroup> addonGroups;

  const FoodDetail({
    required this.item,
    required this.fullDescription,
    required this.ingredients,
    required this.calories,
    required this.sizes,
    required this.addonGroups,
  });

  factory FoodDetail.fromJson(Map<String, dynamic> json) {
    return FoodDetail(
      item: FoodItem.fromJson(json),
      fullDescription: json['full_description'] ?? '',
      ingredients: json['ingredients'] != null ? List<String>.from(json['ingredients']) : [],
      calories: (json['calories'] as num?)?.toDouble() ?? 0,
      sizes: json['sizes'] != null ? (json['sizes'] as List).map((s) => FoodSize.fromJson(s)).toList() : [],
      addonGroups: json['addon_groups'] != null
          ? (json['addon_groups'] as List).map((g) => AddonGroup.fromJson(g)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ...item.toJson(),
      'full_description': fullDescription,
      'ingredients': ingredients,
      'calories': calories,
      'sizes': sizes.map((s) => s.toJson()).toList(),
      'addon_groups': addonGroups.map((g) => g.toJson()).toList(),
    };
  }
}
