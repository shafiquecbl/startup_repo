class AppConstants {
  // app name and package name
  static String appName = 'Startup Repo';

  // Base URL
  static String baseUrl = 'https://api.example.com/';

  // API Endpoints
  static const String configUrl = 'config';

  // Food
  static const String foodHome = 'api/food/home';
  static const String foodDetail = 'api/food/'; // + {id}
  static const String foodByCategory = 'api/food/category';

  // Cart
  static const String cart = 'api/cart';
  static const String cartItem = 'api/cart/'; // + {id}
  static const String applyPromo = 'api/cart/promo';
}
