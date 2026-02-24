/// Centralized API endpoint paths.
///
/// All endpoint strings live here — never hardcode paths in repos.
/// When backend changes a URL, update it in ONE place.
class Endpoints {
  Endpoints._();

  // Config
  static const String config = 'config';

  // Food
  static const String foodHome = 'api/food/home';
  static const String foodDetail = 'api/food/'; // + {id}
  static const String foodByCategory = 'api/food/category';

  // Cart
  static const String cart = 'api/cart';
  static const String cartItem = 'api/cart/'; // + {id}
  static const String applyPromo = 'api/cart/promo';
}
