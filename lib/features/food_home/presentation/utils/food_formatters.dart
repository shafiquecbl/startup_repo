/// Pure formatting utilities for the food feature.
/// No state, no side effects — just input → output transformations.
class FoodFormatters {
  FoodFormatters._();

  /// Format price: 25.0 → "SAR 25.00", 25.5 → "SAR 25.50"
  static String formatPrice(double price) {
    return 'SAR ${price.toStringAsFixed(2)}';
  }

  /// Format delivery time: 25 → "25-35 min"
  static String formatDeliveryTime(int minutes) {
    return '$minutes-${minutes + 10} min';
  }

  /// Format rating: (4.5, 120) → "4.5 (120)"
  static String formatRating(double rating, int count) {
    return '${rating.toStringAsFixed(1)} ($count)';
  }

  /// Format large counts: 1240 → "1.2k", 890 → "890"
  static String formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }

  /// Format calories: 680 → "680 kcal"
  static String formatCalories(double calories) {
    return '${calories.toInt()} kcal';
  }

  /// Format addon price for display: 0 → "Free", 3.0 → "+SAR 3.00"
  static String formatAddonPrice(double price) {
    if (price == 0) return 'Free';
    return '+SAR ${price.toStringAsFixed(2)}';
  }

  /// Format delivery fee: 0 → "Free delivery", 5 → "SAR 5.00 delivery"
  static String formatDeliveryFee(double fee) {
    if (fee == 0) return 'Free delivery';
    return 'SAR ${fee.toStringAsFixed(2)} delivery';
  }
}
