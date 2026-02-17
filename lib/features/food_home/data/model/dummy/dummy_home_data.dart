import '../food_category.dart';
import '../food_item.dart';
import '../promo_banner.dart';

// ─────────────────────────────────────────────────────────────
// Banners
// ─────────────────────────────────────────────────────────────

final List<PromoBanner> dummyBanners = [
  const PromoBanner(
    id: 'b1',
    image: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80',
    title: '50% Off Your First Order',
    subtitle: 'Use code WELCOME50',
  ),
  const PromoBanner(
    id: 'b2',
    image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80',
    title: 'Free Delivery This Weekend',
    subtitle: 'On orders above SAR 50',
  ),
  const PromoBanner(
    id: 'b3',
    image: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800&q=80',
    title: 'Family Meal Deals',
    subtitle: 'Feed 4 for SAR 99',
  ),
];

// ─────────────────────────────────────────────────────────────
// Categories
// ─────────────────────────────────────────────────────────────

final List<FoodCategory> dummyCategories = [
  const FoodCategory(id: 'all', name: 'All', icon: '🍽️', isSelected: true),
  const FoodCategory(id: 'burger', name: 'Burgers', icon: '🍔'),
  const FoodCategory(id: 'pizza', name: 'Pizza', icon: '🍕'),
  const FoodCategory(id: 'sushi', name: 'Sushi', icon: '🍣'),
  const FoodCategory(id: 'chicken', name: 'Chicken', icon: '🍗'),
  const FoodCategory(id: 'pasta', name: 'Pasta', icon: '🍝'),
  const FoodCategory(id: 'dessert', name: 'Desserts', icon: '🍰'),
  const FoodCategory(id: 'coffee', name: 'Coffee', icon: '☕'),
];

// ─────────────────────────────────────────────────────────────
// Food Items (for lists)
// ─────────────────────────────────────────────────────────────

final List<FoodItem> dummyFoodItems = [
  const FoodItem(
    id: '1',
    name: 'Smash Burger',
    description: 'Double smashed beef patties with cheddar, pickles & special sauce',
    image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&q=80',
    price: 32.0,
    rating: 4.8,
    ratingCount: 1240,
    deliveryTime: 25,
    deliveryFee: 5.0,
    restaurant: 'Burger Lab',
    categoryId: 'burger',
    isFavorite: true,
  ),
  const FoodItem(
    id: '2',
    name: 'Margherita Pizza',
    description: 'Fresh mozzarella, San Marzano tomatoes, basil on hand-tossed dough',
    image: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=600&q=80',
    price: 45.0,
    rating: 4.6,
    ratingCount: 890,
    deliveryTime: 30,
    deliveryFee: 0,
    restaurant: 'Pizza House',
    categoryId: 'pizza',
  ),
  const FoodItem(
    id: '3',
    name: 'Salmon Maki Roll',
    description: 'Fresh Atlantic salmon, avocado, cucumber wrapped in nori',
    image: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=600&q=80',
    price: 55.0,
    rating: 4.9,
    ratingCount: 620,
    deliveryTime: 35,
    deliveryFee: 8.0,
    restaurant: 'Sushi Zen',
    categoryId: 'sushi',
    isFavorite: true,
  ),
  const FoodItem(
    id: '4',
    name: 'Crispy Fried Chicken',
    description: 'Southern-style fried chicken with honey drizzle & coleslaw',
    image: 'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=600&q=80',
    price: 38.0,
    rating: 4.7,
    ratingCount: 2100,
    deliveryTime: 20,
    deliveryFee: 3.0,
    restaurant: 'Cluck & Co',
    categoryId: 'chicken',
  ),
  const FoodItem(
    id: '5',
    name: 'Truffle Pasta',
    description: 'Handmade fettuccine with black truffle cream sauce & parmesan',
    image: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=600&q=80',
    price: 62.0,
    rating: 4.5,
    ratingCount: 430,
    deliveryTime: 30,
    deliveryFee: 5.0,
    restaurant: 'Pasta Fresca',
    categoryId: 'pasta',
  ),
  const FoodItem(
    id: '6',
    name: 'Tiramisu Cake',
    description: 'Classic Italian tiramisu with mascarpone, espresso & cocoa',
    image: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=600&q=80',
    price: 28.0,
    rating: 4.8,
    ratingCount: 760,
    deliveryTime: 25,
    deliveryFee: 5.0,
    restaurant: 'Sweet Bites',
    categoryId: 'dessert',
  ),
  const FoodItem(
    id: '7',
    name: 'Iced Caramel Latte',
    description: 'Smooth espresso, caramel syrup, cold milk over ice',
    image: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=600&q=80',
    price: 22.0,
    rating: 4.4,
    ratingCount: 1560,
    deliveryTime: 15,
    deliveryFee: 3.0,
    restaurant: 'Brew & Bean',
    categoryId: 'coffee',
  ),
  const FoodItem(
    id: '8',
    name: 'BBQ Chicken Pizza',
    description: 'Smoky BBQ sauce, grilled chicken, red onion & mozzarella',
    image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&q=80',
    price: 52.0,
    rating: 4.7,
    ratingCount: 1100,
    deliveryTime: 30,
    deliveryFee: 0,
    restaurant: 'Pizza House',
    categoryId: 'pizza',
  ),
  const FoodItem(
    id: '9',
    name: 'Wagyu Cheese Burger',
    description: 'Premium wagyu beef, aged cheddar, caramelized onions, brioche bun',
    image: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&q=80',
    price: 58.0,
    rating: 4.9,
    ratingCount: 340,
    deliveryTime: 30,
    deliveryFee: 5.0,
    restaurant: 'Burger Lab',
    categoryId: 'burger',
  ),
  const FoodItem(
    id: '10',
    name: 'Dragon Roll',
    description: 'Shrimp tempura, eel, avocado, tobiko with sweet soy glaze',
    image: 'https://images.unsplash.com/photo-1617196034796-73dfa7b1fd56?w=600&q=80',
    price: 48.0,
    rating: 4.6,
    ratingCount: 520,
    deliveryTime: 35,
    deliveryFee: 8.0,
    restaurant: 'Sushi Zen',
    categoryId: 'sushi',
  ),
];

// ─────────────────────────────────────────────────────────────
// Home Data Container (used by controller)
// ─────────────────────────────────────────────────────────────

class FoodHomeData {
  final List<PromoBanner> banners;
  final List<FoodCategory> categories;
  final List<FoodItem> popularItems;
  final List<FoodItem> allItems;

  const FoodHomeData({
    required this.banners,
    required this.categories,
    required this.popularItems,
    required this.allItems,
  });

  /// Dummy data for development — swap to real API when backend is ready
  factory FoodHomeData.dummy() {
    return FoodHomeData(
      banners: dummyBanners,
      categories: dummyCategories,
      popularItems: dummyFoodItems.where((i) => i.rating >= 4.7).toList(),
      allItems: dummyFoodItems,
    );
  }

  factory FoodHomeData.fromJson(Map<String, dynamic> json) {
    return FoodHomeData(
      banners: (json['banners'] as List).map((b) => PromoBanner.fromJson(b)).toList(),
      categories: (json['categories'] as List).map((c) => FoodCategory.fromJson(c)).toList(),
      popularItems: (json['popular_items'] as List).map((i) => FoodItem.fromJson(i)).toList(),
      allItems: (json['all_items'] as List).map((i) => FoodItem.fromJson(i)).toList(),
    );
  }
}
