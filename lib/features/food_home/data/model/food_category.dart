class FoodCategory {
  final String id;
  final String name;
  final String icon;
  final bool isSelected;

  const FoodCategory({required this.id, required this.name, required this.icon, this.isSelected = false});

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      isSelected: json['is_selected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'icon': icon, 'is_selected': isSelected};
  }

  FoodCategory copyWith({bool? isSelected}) {
    return FoodCategory(id: id, name: name, icon: icon, isSelected: isSelected ?? this.isSelected);
  }
}
