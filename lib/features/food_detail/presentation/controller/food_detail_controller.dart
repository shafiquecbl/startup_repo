import 'package:startup_repo/imports.dart';
import 'package:startup_repo/features/cart/presentation/controller/cart_controller.dart';

import '../../../cart/data/model/cart_item.dart';
import '../../../food_home/domain/service/food_service.dart';
import '../../data/model/dummy/dummy_detail_data.dart';
import '../../data/model/food_addon.dart';
import '../../data/model/food_detail.dart';
import '../../data/model/food_size.dart';

class FoodDetailController extends GetxController implements GetxService {
  final FoodService foodService;
  FoodDetailController({required this.foodService});

  static FoodDetailController get find => Get.find<FoodDetailController>();

  // ─── State ──────────────────────────────────────────────────

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  FoodDetail? _detail;
  FoodDetail? get detail => _detail;

  FoodSize? _selectedSize;
  FoodSize? get selectedSize => _selectedSize;

  /// Map of addonGroupId → Set of selected addon IDs
  final Map<String, Set<String>> _selectedAddons = {};
  Map<String, Set<String>> get selectedAddons => _selectedAddons;

  int _quantity = 1;
  int get quantity => _quantity;

  String _specialInstructions = '';
  String get specialInstructions => _specialInstructions;

  // ─── Computed Properties ────────────────────────────────────

  /// The total price: (basePrice + sizeAdjustment + addons) × quantity
  double get totalPrice {
    if (_detail == null) return 0;

    double base = _detail!.item.price;

    // Size adjustment
    if (_selectedSize != null) {
      base += _selectedSize!.priceAdjustment;
    }

    // Addons total
    double addonsTotal = 0;
    for (final AddonGroup group in _detail!.addonGroups) {
      final Set<String> selectedIds = _selectedAddons[group.id] ?? {};
      for (final FoodAddon addon in group.addons) {
        if (selectedIds.contains(addon.id)) {
          addonsTotal += addon.price;
        }
      }
    }

    return (base + addonsTotal) * _quantity;
  }

  /// Check if all required addon groups have a selection
  bool get requiredGroupsValid {
    if (_detail == null) return true;
    for (final AddonGroup group in _detail!.addonGroups) {
      if (group.isRequired) {
        final Set<String> selectedIds = _selectedAddons[group.id] ?? {};
        if (selectedIds.isEmpty) return false;
      }
    }
    return true;
  }

  /// Get all selected FoodAddon objects (flat list)
  List<FoodAddon> get allSelectedAddons {
    if (_detail == null) return [];
    final List<FoodAddon> result = [];
    for (final AddonGroup group in _detail!.addonGroups) {
      final Set<String> selectedIds = _selectedAddons[group.id] ?? {};
      for (final FoodAddon addon in group.addons) {
        if (selectedIds.contains(addon.id)) {
          result.add(addon);
        }
      }
    }
    return result;
  }

  // ─── User Intents ───────────────────────────────────────────

  /// Load detail for a food item by ID
  Future<void> loadFoodDetail(String id) async {
    isLoading = true;
    _resetSelections();

    // DUMMY: find from local list
    _detail = dummyFoodDetails.cast<FoodDetail?>().firstWhere((d) => d?.item.id == id, orElse: () => null);
    // REAL: _detail = await foodService.fetchFoodDetail(id);

    // Auto-select first size if available
    if (_detail != null && _detail!.sizes.isNotEmpty) {
      _selectedSize = _detail!.sizes.first;
    }

    isLoading = false;
  }

  /// Select a size (radio — single choice)
  void onSizeSelected(FoodSize size) {
    _selectedSize = size;
    update();
  }

  /// Toggle an addon within a group
  void onAddonToggled(String groupId, FoodAddon addon) {
    final AddonGroup? group = _detail?.addonGroups.firstWhere((g) => g.id == groupId);
    if (group == null) return;

    _selectedAddons[groupId] ??= {};

    if (group.maxSelections == 1) {
      // Radio behavior — replace selection
      _selectedAddons[groupId] = {addon.id};
    } else {
      // Checkbox behavior — toggle
      if (_selectedAddons[groupId]!.contains(addon.id)) {
        _selectedAddons[groupId]!.remove(addon.id);
      } else if (_selectedAddons[groupId]!.length < group.maxSelections) {
        _selectedAddons[groupId]!.add(addon.id);
      }
    }

    update();
  }

  /// Check if an addon is selected
  bool isAddonSelected(String groupId, String addonId) {
    return _selectedAddons[groupId]?.contains(addonId) ?? false;
  }

  /// Update quantity (clamped 1-99)
  void onQuantityChanged(int newQty) {
    _quantity = newQty.clamp(1, 99);
    update();
  }

  /// Update special instructions
  void onInstructionsChanged(String text) {
    _specialInstructions = text;
    // No update() call — text field manages its own state
  }

  /// Add current selection to cart
  void onAddToCart() {
    if (_detail == null) return;

    if (!requiredGroupsValid) {
      AppDialog.showToast('Please complete all required selections');
      return;
    }

    final CartItem cartItem = CartItem(
      cartItemId: DateTime.now().millisecondsSinceEpoch.toString(),
      foodItem: _detail!.item,
      selectedSize: _selectedSize,
      selectedAddons: allSelectedAddons,
      quantity: _quantity,
      specialInstructions: _specialInstructions.isNotEmpty ? _specialInstructions : null,
    );

    CartController.find.addItem(cartItem);
    Get.back();
    AppDialog.showToast('Added to cart!');
  }

  // ─── Private Helpers ────────────────────────────────────────

  void _resetSelections() {
    _selectedSize = null;
    _selectedAddons.clear();
    _quantity = 1;
    _specialInstructions = '';
  }
}
