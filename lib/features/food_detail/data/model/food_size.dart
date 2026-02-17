class FoodSize {
  final String id;
  final String name;
  final double priceAdjustment;

  const FoodSize({required this.id, required this.name, required this.priceAdjustment});

  factory FoodSize.fromJson(Map<String, dynamic> json) {
    return FoodSize(
      id: json['id'],
      name: json['name'],
      priceAdjustment: (json['price_adjustment'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price_adjustment': priceAdjustment};
  }
}
