import 'package:startup_repo/imports.dart';
import '../../data/model/cart_item.dart';
import '../../domain/service/cart_service.dart';

class CartController extends GetxController implements GetxService {
  final CartService cartService;
  CartController({required this.cartService});

  static CartController get find => Get.find<CartController>();

  // ─── State ──────────────────────────────────────────────────

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);

  double _discount = 0;
  double get discount => _discount;

  String? _appliedPromoCode;
  String? get appliedPromoCode => _appliedPromoCode;

  // ─── Computed Properties ────────────────────────────────────

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => _items.isEmpty;

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee {
    if (_items.isEmpty) return 0;
    // Highest delivery fee among all items' restaurants
    return _items.map((i) => i.foodItem.deliveryFee).reduce((a, b) => a > b ? a : b);
  }

  double get total => (subtotal - _discount + deliveryFee).clamp(0, double.infinity);

  // ─── User Intents ───────────────────────────────────────────

  /// Add item to cart (or merge if same food + options exist)
  void addItem(CartItem item) {
    final int existingIndex = _items.indexWhere(
      (i) =>
          i.foodItem.id == item.foodItem.id &&
          i.selectedSize?.id == item.selectedSize?.id &&
          _sameAddons(i, item),
    );

    if (existingIndex != -1) {
      // Merge — increase quantity
      final CartItem existing = _items[existingIndex];
      _items[existingIndex] = existing.copyWith(quantity: existing.quantity + item.quantity);
    } else {
      _items.add(item);
    }

    _recalculateDiscount();
    update();
  }

  /// Remove item from cart
  void removeItem(String cartItemId) {
    _items.removeWhere((i) => i.cartItemId == cartItemId);
    _recalculateDiscount();
    update();
  }

  /// Update item quantity
  void updateQuantity(String cartItemId, int qty) {
    if (qty <= 0) {
      removeItem(cartItemId);
      return;
    }

    final int index = _items.indexWhere((i) => i.cartItemId == cartItemId);
    if (index == -1) return;

    _items[index] = _items[index].copyWith(quantity: qty);
    _recalculateDiscount();
    update();
  }

  /// Apply promo code
  Future<void> applyPromoCode(String code) async {
    if (code.isEmpty) return;

    // DUMMY: hardcoded promo codes
    if (code.toUpperCase() == 'WELCOME50') {
      _discount = subtotal * 0.5; // 50% off
      _appliedPromoCode = code;
      AppDialog.showToast('50% discount applied!');
    } else if (code.toUpperCase() == 'FREE10') {
      _discount = 10.0;
      _appliedPromoCode = code;
      AppDialog.showToast('SAR 10 discount applied!');
    } else {
      AppDialog.showToast('Invalid promo code');
      return;
    }
    // REAL: final discountAmount = await cartService.applyPromo(code);

    update();
  }

  /// Remove applied promo code
  void removePromoCode() {
    _discount = 0;
    _appliedPromoCode = null;
    update();
  }

  /// Clear entire cart
  void clearCart() {
    _items.clear();
    _discount = 0;
    _appliedPromoCode = null;
    update();
  }

  /// Checkout
  void onCheckout() {
    if (_items.isEmpty) {
      AppDialog.showToast('Your cart is empty');
      return;
    }
    // Navigate to checkout, pass order data, etc.
    AppDialog.showToast('Order placed! (demo)');
    clearCart();
  }

  // ─── Private Helpers ────────────────────────────────────────

  /// Check if two cart items have the same addon selections
  bool _sameAddons(CartItem a, CartItem b) {
    if (a.selectedAddons.length != b.selectedAddons.length) return false;
    final Set<String> aIds = a.selectedAddons.map((e) => e.id).toSet();
    final Set<String> bIds = b.selectedAddons.map((e) => e.id).toSet();
    return aIds.containsAll(bIds) && bIds.containsAll(aIds);
  }

  /// Recalculate discount after cart changes
  void _recalculateDiscount() {
    if (_appliedPromoCode == null) return;
    // Re-apply same promo logic
    if (_appliedPromoCode!.toUpperCase() == 'WELCOME50') {
      _discount = subtotal * 0.5;
    }
    // Fixed amount discounts stay as-is
  }
}
