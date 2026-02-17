import '../../../food_detail/data/model/food_addon.dart';
import '../../../food_detail/data/model/food_size.dart';
import '../../../food_home/data/model/food_item.dart';

class CartItem {
  final String cartItemId;
  final FoodItem foodItem;
  final FoodSize? selectedSize;
  final List<FoodAddon> selectedAddons;
  final int quantity;
  final String? specialInstructions;

  const CartItem({
    required this.cartItemId,
    required this.foodItem,
    this.selectedSize,
    this.selectedAddons = const [],
    this.quantity = 1,
    this.specialInstructions,
  });

  /// Calculate total price:
  /// (basePrice + sizeAdjustment + sum(addonPrices)) × quantity
  double get totalPrice {
    double base = foodItem.price;
    if (selectedSize != null) base += selectedSize!.priceAdjustment;
    final double addonsTotal = selectedAddons.fold(0.0, (sum, a) => sum + a.price);
    return (base + addonsTotal) * quantity;
  }

  /// Unit price (before quantity multiplication)
  double get unitPrice {
    double base = foodItem.price;
    if (selectedSize != null) base += selectedSize!.priceAdjustment;
    final double addonsTotal = selectedAddons.fold(0.0, (sum, a) => sum + a.price);
    return base + addonsTotal;
  }

  /// Summary of customizations for display
  String get customizationSummary {
    final parts = <String>[];
    if (selectedSize != null) parts.add(selectedSize!.name);
    for (final addon in selectedAddons) {
      parts.add(addon.name);
    }
    return parts.join(', ');
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cart_item_id'],
      foodItem: FoodItem.fromJson(json['food_item']),
      selectedSize: json['selected_size'] != null ? FoodSize.fromJson(json['selected_size']) : null,
      selectedAddons: json['selected_addons'] != null
          ? (json['selected_addons'] as List).map((a) => FoodAddon.fromJson(a)).toList()
          : [],
      quantity: json['quantity'] ?? 1,
      specialInstructions: json['special_instructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_item_id': cartItemId,
      'food_item': foodItem.toJson(),
      'selected_size': selectedSize?.toJson(),
      'selected_addons': selectedAddons.map((a) => a.toJson()).toList(),
      'quantity': quantity,
      'special_instructions': specialInstructions,
    };
  }

  CartItem copyWith({
    FoodSize? selectedSize,
    List<FoodAddon>? selectedAddons,
    int? quantity,
    String? specialInstructions,
  }) {
    return CartItem(
      cartItemId: cartItemId,
      foodItem: foodItem,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedAddons: selectedAddons ?? this.selectedAddons,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}
