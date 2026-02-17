class FoodAddon {
  final String id;
  final String name;
  final double price;

  const FoodAddon({required this.id, required this.name, required this.price});

  factory FoodAddon.fromJson(Map<String, dynamic> json) {
    return FoodAddon(id: json['id'], name: json['name'], price: (json['price'] as num).toDouble());
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price};
  }
}

/// A group of addons (e.g. "Choose your bread", "Extra toppings")
class AddonGroup {
  final String id;
  final String name;
  final bool isRequired;
  final int maxSelections; // 1 = radio (single choice), >1 = checkbox (multi)
  final List<FoodAddon> addons;

  const AddonGroup({
    required this.id,
    required this.name,
    required this.isRequired,
    this.maxSelections = 1,
    required this.addons,
  });

  factory AddonGroup.fromJson(Map<String, dynamic> json) {
    return AddonGroup(
      id: json['id'],
      name: json['name'],
      isRequired: json['is_required'] ?? false,
      maxSelections: json['max_selections'] ?? 1,
      addons: (json['addons'] as List).map((a) => FoodAddon.fromJson(a)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_required': isRequired,
      'max_selections': maxSelections,
      'addons': addons.map((a) => a.toJson()).toList(),
    };
  }
}
