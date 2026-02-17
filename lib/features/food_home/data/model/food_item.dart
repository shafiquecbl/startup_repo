class FoodItem {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;
  final double rating;
  final int ratingCount;
  final int deliveryTime; // in minutes
  final double deliveryFee;
  final String restaurant;
  final String categoryId;
  final bool isFavorite;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
    required this.ratingCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.restaurant,
    required this.categoryId,
    this.isFavorite = false,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
      deliveryTime: json['delivery_time'] ?? 30,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0,
      restaurant: json['restaurant'],
      categoryId: json['category_id'],
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'rating': rating,
      'rating_count': ratingCount,
      'delivery_time': deliveryTime,
      'delivery_fee': deliveryFee,
      'restaurant': restaurant,
      'category_id': categoryId,
      'is_favorite': isFavorite,
    };
  }

  FoodItem copyWith({bool? isFavorite}) {
    return FoodItem(
      id: id,
      name: name,
      description: description,
      image: image,
      price: price,
      rating: rating,
      ratingCount: ratingCount,
      deliveryTime: deliveryTime,
      deliveryFee: deliveryFee,
      restaurant: restaurant,
      categoryId: categoryId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
