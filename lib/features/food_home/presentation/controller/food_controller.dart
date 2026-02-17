import 'package:startup_repo/imports.dart';
import '../../data/model/food_category.dart';
import '../../data/model/food_item.dart';
import '../../data/model/promo_banner.dart';
import '../../data/model/dummy/dummy_home_data.dart';
import '../../domain/service/food_service.dart';

class FoodController extends GetxController implements GetxService {
  final FoodService foodService;
  FoodController({required this.foodService});

  static FoodController get find => Get.find<FoodController>();

  // ─── State ──────────────────────────────────────────────────

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  List<PromoBanner> _banners = [];
  List<PromoBanner> get banners => _banners;

  List<FoodCategory> _categories = [];
  List<FoodCategory> get categories => _categories;

  List<FoodItem> _popularItems = [];
  List<FoodItem> get popularItems => _popularItems;

  List<FoodItem> _allItems = [];
  List<FoodItem> get allItems => _allItems;

  List<FoodItem> _filteredItems = [];
  List<FoodItem> get filteredItems => _filteredItems;

  final String _selectedCategoryId = 'all';
  String get selectedCategoryId => _selectedCategoryId;

  // ─── User Intents ───────────────────────────────────────────

  /// Load all home screen data
  Future<void> loadHome() async {
    isLoading = true;

    // DUMMY: swap this one line when backend is ready
    final FoodHomeData home = FoodHomeData.dummy();
    // REAL: final home = await foodService.fetchHome();

    _banners = home.banners;
    _categories = home.categories;
    _popularItems = home.popularItems;
    _allItems = home.allItems;
    _filteredItems = home.allItems;

    isLoading = false;
  }

  /// Navigate to category screen
  void onCategorySelected(String categoryId) {
    if (categoryId == 'view_all') {
      // Navigate to all categories screen
      AppDialog.showToast('All categories (demo)');
      return;
    }

    // Navigate to category-specific screen
    final FoodCategory? category = _categories.firstWhereOrNull((c) => c.id == categoryId);
    if (category != null) {
      AppDialog.showToast('${category.name} category (demo)');
    }
  }

  /// Toggle favorite on a food item
  void toggleFavorite(String itemId) {
    _allItems = _allItems.map((item) {
      if (item.id == itemId) return item.copyWith(isFavorite: !item.isFavorite);
      return item;
    }).toList();

    _popularItems = _popularItems.map((item) {
      if (item.id == itemId) return item.copyWith(isFavorite: !item.isFavorite);
      return item;
    }).toList();

    _filteredItems = _filteredItems.map((item) {
      if (item.id == itemId) return item.copyWith(isFavorite: !item.isFavorite);
      return item;
    }).toList();

    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadHome();
  }
}
