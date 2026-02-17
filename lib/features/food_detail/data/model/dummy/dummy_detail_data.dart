import 'package:startup_repo/features/food_home/data/model/dummy/dummy_home_data.dart';
import '../food_addon.dart';
import '../food_detail.dart';
import '../food_size.dart';

// ─────────────────────────────────────────────────────────────
// Shared sizes & addons (reused across details)
// ─────────────────────────────────────────────────────────────

const _burgerSizes = [
  FoodSize(id: 's1', name: 'Regular', priceAdjustment: 0),
  FoodSize(id: 's2', name: 'Large', priceAdjustment: 8),
  FoodSize(id: 's3', name: 'Double', priceAdjustment: 15),
];

const _pizzaSizes = [
  FoodSize(id: 's1', name: 'Small (8")', priceAdjustment: 0),
  FoodSize(id: 's2', name: 'Medium (12")', priceAdjustment: 12),
  FoodSize(id: 's3', name: 'Large (16")', priceAdjustment: 20),
];

const _drinkSizes = [
  FoodSize(id: 's1', name: 'Small', priceAdjustment: 0),
  FoodSize(id: 's2', name: 'Medium', priceAdjustment: 4),
  FoodSize(id: 's3', name: 'Large', priceAdjustment: 7),
];

// ─────────────────────────────────────────────────────────────
// Food Details (for detail screen)
// ─────────────────────────────────────────────────────────────

final List<FoodDetail> dummyFoodDetails = [
  // Smash Burger
  FoodDetail(
    item: dummyFoodItems[0],
    fullDescription:
        'Our signature Smash Burger features two perfectly smashed beef patties, '
        'seared on a blazing hot griddle for maximum crust. Topped with melted '
        'American cheddar, tangy pickles, fresh lettuce, sliced tomato, and our '
        'house-made special sauce on a toasted brioche bun.',
    ingredients: ['Beef Patties', 'Cheddar', 'Pickles', 'Lettuce', 'Tomato', 'Special Sauce', 'Brioche Bun'],
    calories: 680,
    sizes: _burgerSizes,
    addonGroups: [
      const AddonGroup(
        id: 'g1',
        name: 'Choose Your Bun',
        isRequired: true,
        maxSelections: 1,
        addons: [
          FoodAddon(id: 'a1', name: 'Classic Brioche', price: 0),
          FoodAddon(id: 'a2', name: 'Sesame Bun', price: 0),
          FoodAddon(id: 'a3', name: 'Lettuce Wrap (Low Carb)', price: 2),
        ],
      ),
      const AddonGroup(
        id: 'g2',
        name: 'Extra Toppings',
        isRequired: false,
        maxSelections: 5,
        addons: [
          FoodAddon(id: 'a4', name: 'Extra Cheese', price: 3),
          FoodAddon(id: 'a5', name: 'Bacon', price: 5),
          FoodAddon(id: 'a6', name: 'Jalapeños', price: 2),
          FoodAddon(id: 'a7', name: 'Fried Egg', price: 4),
          FoodAddon(id: 'a8', name: 'Caramelized Onions', price: 3),
        ],
      ),
      const AddonGroup(
        id: 'g3',
        name: 'Sides',
        isRequired: false,
        maxSelections: 3,
        addons: [
          FoodAddon(id: 'a9', name: 'French Fries', price: 8),
          FoodAddon(id: 'a10', name: 'Sweet Potato Fries', price: 10),
          FoodAddon(id: 'a11', name: 'Onion Rings', price: 9),
          FoodAddon(id: 'a12', name: 'Coleslaw', price: 5),
        ],
      ),
    ],
  ),

  // Margherita Pizza
  FoodDetail(
    item: dummyFoodItems[1],
    fullDescription:
        'A timeless classic — our Margherita is crafted with hand-stretched dough, '
        'topped with imported San Marzano tomato sauce, fresh buffalo mozzarella, '
        'fragrant basil leaves, and a drizzle of extra virgin olive oil. '
        'Baked in our stone-fired oven at 450°C for the perfect char.',
    ingredients: ['Dough', 'San Marzano Tomatoes', 'Buffalo Mozzarella', 'Basil', 'Olive Oil'],
    calories: 820,
    sizes: _pizzaSizes,
    addonGroups: [
      const AddonGroup(
        id: 'g1',
        name: 'Crust Type',
        isRequired: true,
        maxSelections: 1,
        addons: [
          FoodAddon(id: 'a1', name: 'Classic Hand-Tossed', price: 0),
          FoodAddon(id: 'a2', name: 'Thin & Crispy', price: 0),
          FoodAddon(id: 'a3', name: 'Stuffed Cheese Crust', price: 8),
        ],
      ),
      const AddonGroup(
        id: 'g2',
        name: 'Extra Toppings',
        isRequired: false,
        maxSelections: 6,
        addons: [
          FoodAddon(id: 'a4', name: 'Extra Mozzarella', price: 5),
          FoodAddon(id: 'a5', name: 'Mushrooms', price: 4),
          FoodAddon(id: 'a6', name: 'Black Olives', price: 3),
          FoodAddon(id: 'a7', name: 'Pepperoni', price: 6),
          FoodAddon(id: 'a8', name: 'Bell Peppers', price: 3),
          FoodAddon(id: 'a9', name: 'Fresh Arugula', price: 4),
        ],
      ),
    ],
  ),

  // Salmon Maki Roll
  FoodDetail(
    item: dummyFoodItems[2],
    fullDescription:
        'Our premium Salmon Maki features the freshest Atlantic salmon, '
        'hand-sliced and paired with ripe avocado, crisp cucumber, and '
        'seasoned sushi rice, all wrapped in premium nori seaweed. '
        'Served with wasabi, pickled ginger, and soy sauce.',
    ingredients: ['Atlantic Salmon', 'Sushi Rice', 'Avocado', 'Cucumber', 'Nori', 'Wasabi', 'Ginger'],
    calories: 420,
    sizes: const [
      FoodSize(id: 's1', name: '6 Pieces', priceAdjustment: 0),
      FoodSize(id: 's2', name: '8 Pieces', priceAdjustment: 12),
      FoodSize(id: 's3', name: '12 Pieces', priceAdjustment: 22),
    ],
    addonGroups: [
      const AddonGroup(
        id: 'g1',
        name: 'Extras',
        isRequired: false,
        maxSelections: 4,
        addons: [
          FoodAddon(id: 'a1', name: 'Extra Salmon', price: 10),
          FoodAddon(id: 'a2', name: 'Spicy Mayo', price: 2),
          FoodAddon(id: 'a3', name: 'Tempura Flakes', price: 3),
          FoodAddon(id: 'a4', name: 'Miso Soup', price: 8),
          FoodAddon(id: 'a5', name: 'Edamame', price: 7),
        ],
      ),
    ],
  ),

  // Iced Caramel Latte
  FoodDetail(
    item: dummyFoodItems[6],
    fullDescription:
        'Our Iced Caramel Latte is made with double-shot espresso, '
        'rich house-made caramel sauce, and cold silky milk poured over '
        'crystal-clear ice. Topped with whipped cream and a caramel drizzle.',
    ingredients: ['Espresso', 'Caramel Syrup', 'Cold Milk', 'Ice', 'Whipped Cream'],
    calories: 280,
    sizes: _drinkSizes,
    addonGroups: [
      const AddonGroup(
        id: 'g1',
        name: 'Milk Option',
        isRequired: true,
        maxSelections: 1,
        addons: [
          FoodAddon(id: 'a1', name: 'Full Cream Milk', price: 0),
          FoodAddon(id: 'a2', name: 'Oat Milk', price: 3),
          FoodAddon(id: 'a3', name: 'Almond Milk', price: 3),
          FoodAddon(id: 'a4', name: 'Soy Milk', price: 2),
        ],
      ),
      const AddonGroup(
        id: 'g2',
        name: 'Extra Shots & Syrups',
        isRequired: false,
        maxSelections: 3,
        addons: [
          FoodAddon(id: 'a5', name: 'Extra Shot', price: 4),
          FoodAddon(id: 'a6', name: 'Vanilla Syrup', price: 2),
          FoodAddon(id: 'a7', name: 'Hazelnut Syrup', price: 2),
          FoodAddon(id: 'a8', name: 'Extra Whipped Cream', price: 3),
        ],
      ),
    ],
  ),
];
