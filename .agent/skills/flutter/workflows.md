# Workflows — Design-First & Feature Creation

> **When to read:** Before building any new screen, feature, or multi-screen flow.

---

## Design-First Workflow — Analyze Before You Code

> **⚠️ CRITICAL: NEVER start building screens immediately.** Always analyze the
> full design/requirements first. Consistency comes from understanding the whole
> picture before writing the first widget.

### When This Applies

This workflow is mandatory when:
- Building a new app or major feature set (multiple screens)
- Receiving a Figma file, design images, or spec document
- Even when given just a feature list with no visuals

### Phase 1: Design Audit

Before writing ANY screen code, study the entire design and answer:

1. **Screen inventory** — List every screen/page in the feature set
2. **Repeating patterns** — Which UI elements appear on multiple screens?
   - Cards, list tiles, headers, bottom bars, status badges, empty states, etc.
3. **Token check** — Do the designs use spacings/radii/colors outside our token
   scale? If yes → **snap to the nearest token**, don't invent new ones
4. **Interaction patterns** — Pull-to-refresh, infinite scroll, swipe-to-dismiss,
   bottom sheets — which screens share them?
5. **State patterns** — Which screens need loading, empty, error states?

### Phase 2: Component Planning

Based on the audit, identify widgets to build **before** any screen:

**Widget placement rule:**
| Condition | Location | Example |
|-----------|----------|---------|
| Used in **≥2 features** | `lib/core/widgets/` | `StatusBadge`, `UserAvatar` |
| Used in **1 feature only** | `lib/features/<name>/presentation/view/widgets/` | `OrderTimeline` |

**Widget naming rule:** Name by **what it is**, not **where it's used**:
- ✅ `StatusBadge` — reusable, semantic
- ❌ `HomeScreenBadge` — tied to one screen, misleading

**Checklist for each shared widget:**
- [ ] What parameters does it need? (think about ALL use cases)
- [ ] Does it need loading/empty/error variants?
- [ ] Can it use `const` constructor?
- [ ] Does it follow the existing design token scale?

### Phase 3: Screen Assembly

Now — and only now — build screens:
- Screens are **compositions** of shared widgets + feature-specific widgets
- Every screen should follow a consistent skeleton:
  ```dart
  Scaffold(
    appBar: AppBar(title: Text('Title'.tr)),
    body: SafeArea(
      child: Padding(
        padding: AppPadding.screen,  // consistent screen padding
        child: ...
      ),
    ),
  )
  ```

### Phase 4: Consistency Review

After building, verify:
- [ ] All spacings use `AppPadding` tokens (no hardcoded values)
- [ ] All radii use `AppRadius` tokens
- [ ] All text styles use `context.fontXX`
- [ ] All colors use `AppColors` or `Theme.of(context)`
- [ ] No duplicated widget patterns that should be extracted
- [ ] Consistent screen structure (padding, SafeArea, AppBar)

### Token Snapping Rule

If a design specifies a value outside the token scale:

| Design says | Our scale | Action |
|-------------|-----------|--------|
| 12px padding | 8 / **16** | Snap to `p8` or `p16` (nearest) |
| 10px radius | 8 / **16** | Snap to `r8` or `r16` (nearest) |
| 14px font | 12 / **16** | Snap to `context.font12` or `context.font16` |
| #FF5722 color | — | Add to `AppColors` if it's a brand color, otherwise use `Theme` |

**Never create a one-off token.** Snap to the existing scale and flag the
discrepancy to the design team.

---

## Adding a New Feature — Dummy-Data-First Workflow

> **Philosophy:** Build the complete feature with dummy data FIRST. The UI is fully
> functional, the architecture is production-ready, and swapping to real APIs is a
> one-line change per endpoint. Then generate an API spec doc for backend devs.

> **Reference implementation:** Study `lib/features/food_home/`, `food_detail/`,
> and `cart/` — they demonstrate every pattern described below.

### Feature Directory Scaffold

Create the full structure upfront:

```
lib/features/<feature>/
├── data/
│   ├── model/
│   │   ├── <feature>_model.dart         # Data model (fromJson, toJson)
│   │   └── dummy/
│   │       └── dummy_<feature>_data.dart # Dummy data + container class
│   └── repository/
│       ├── <feature>_repo.dart           # Abstract interface
│       └── <feature>_repo_impl.dart      # ApiClient calls
├── domain/
│   ├── binding/
│   │   └── <feature>_binding.dart        # DI wiring (repo + service + controller)
│   └── service/
│       ├── <feature>_service.dart         # Abstract interface
│       └── <feature>_service_impl.dart    # Business logic + dummy fallback
└── presentation/
    ├── controller/
    │   └── <feature>_controller.dart      # State + user intents
    └── view/
        ├── <feature>_screen.dart          # Main screen
        └── widgets/
            └── ...                        # Feature-specific widgets
```

**When to split into multiple features:** If a requirement has clearly distinct
screens with their own state (e.g. a listing screen, a detail screen, and a cart),
give each its own feature directory. They share models via cross-feature imports.

**Reference:** `food_home/` (listing), `food_detail/` (detail), `cart/` (cart)
are three independent features that share models.

### Build Order — Bottom Up

Follow this exact order. Each step produces a working, testable layer.

#### Step 1: Models (`data/model/`)

Create data models with `fromJson`, `toJson`, and `const` constructors:

```dart
class FoodItem {
  final String id;
  final String name;
  final double price;
  // ... all fields

  const FoodItem({required this.id, required this.name, required this.price});

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
    id: json['id'],
    name: json['name'],
    price: (json['price'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'price': price};
}
```

**Reference:** `food_home/data/model/food_item.dart`

#### Step 2: Dummy Data (`data/model/dummy/`)

Create realistic dummy data that exercises all UI states:

```dart
// dummy_home_data.dart
import '../food_item.dart';

final List<FoodItem> dummyFoodItems = [
  const FoodItem(id: '1', name: 'Smash Burger', price: 32.0, ...),
  const FoodItem(id: '2', name: 'Margherita Pizza', price: 45.0, ...),
  // ... enough items to fill the UI realistically
];

/// Container class for the screen's data (used by service + controller)
class FoodHomeData {
  final List<FoodItem> allItems;
  const FoodHomeData({required this.allItems});

  factory FoodHomeData.dummy() => FoodHomeData(allItems: dummyFoodItems);

  factory FoodHomeData.fromJson(Map<String, dynamic> json) => FoodHomeData(
    allItems: (json['all_items'] as List).map((i) => FoodItem.fromJson(i)).toList(),
  );
}
```

**Rules:**
- Use realistic data (real names, plausible prices, real image URLs)
- Include enough items to test scrolling, pagination, empty states
- Create a container class (`XxxData`) that matches the expected API response shape
- Container has both `factory .dummy()` and `factory .fromJson()`

**Reference:** `food_home/data/model/dummy/dummy_home_data.dart`

#### Step 3: Repository (`data/repository/`)

Define the API interface. Use real endpoint paths even though the API doesn't exist yet:

```dart
// food_repo.dart — abstract interface
abstract class FoodRepo {
  Future<ApiResult<Response>> fetchHome();
  Future<ApiResult<Response>> fetchFoodDetail(String id);
}

// food_repo_impl.dart — implementation
class FoodRepoImpl extends FoodRepo {
  final ApiClient client;
  FoodRepoImpl({required this.client});

  @override
  Future<ApiResult<Response>> fetchHome() async =>
    await client.get(Endpoints.foodHome);  // 'api/food/home'

  @override
  Future<ApiResult<Response>> fetchFoodDetail(String id) async =>
    await client.get('${Endpoints.foodDetail}$id');
}
```

**Rules:**
- Repo is a **thin pass-through** — no logic, just API calls
- Define endpoint paths in `Endpoints` (e.g. `static const String foodHome = 'api/food/home'`)
- Always return `ApiResult<Response>` (never nullable)

**Reference:** `food_home/data/repository/food_repo.dart` + `food_repo_impl.dart`

#### Step 4: Service (`domain/service/`)

Service handles business logic and **falls back to dummy data** when API is unavailable:

```dart
// food_service.dart — abstract interface
abstract class FoodService {
  Future<FoodHomeData> fetchHome();
}

// food_service_impl.dart — implementation with dummy fallback
class FoodServiceImpl extends FoodService {
  final FoodRepo foodRepo;
  FoodServiceImpl({required this.foodRepo});

  @override
  Future<FoodHomeData> fetchHome() async {
    final result = await foodRepo.fetchHome();
    if (result case Success(data: final response)) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return FoodHomeData.fromJson(data);
    }
    return FoodHomeData.dummy(); // ← fallback to dummy
  }
}
```

**The Dummy Fallback Pattern:** When the API returns `Failure` (because it doesn't
exist yet), the service returns dummy data instead. The controller and UI work
identically regardless of source.

**Reference:** `food_home/domain/service/food_service_impl.dart`

#### Step 5: Binding (`domain/binding/`)

Wire everything in one binding per feature:

```dart
class FoodHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodRepo>(() => FoodRepoImpl(client: Get.find()));
    Get.lazyPut<FoodService>(() => FoodServiceImpl(foodRepo: Get.find()));
    Get.lazyPut(() => FoodController(foodService: Get.find()));
  }
}
```

Register in `get_di.dart`:
```dart
final List<Bindings> bindings = [
  // ... existing bindings
  FoodHomeBinding(),
];
```

**Reference:** `food_home/domain/binding/food_home_binding.dart`

#### Step 6: Controller (`presentation/controller/`)

Controller holds state and calls service. Use `// DUMMY:` / `// REAL:` comments
to mark swap points:

```dart
Future<void> loadHome() async {
  isLoading = true;

  // DUMMY: swap this one line when backend is ready
  final FoodHomeData home = FoodHomeData.dummy();
  // REAL: final home = await foodService.fetchHome();

  _banners = home.banners;
  _allItems = home.allItems;
  isLoading = false;
}
```

**The DUMMY/REAL Pattern:** Comment out the real call, use dummy directly. When
backend is ready: delete the `// DUMMY` line, uncomment the `// REAL` line. Done.

**Reference:** `food_home/presentation/controller/food_controller.dart`

#### Step 7: UI (`presentation/view/`)

Build screens and widgets. They consume controller state — completely unaware
whether data is dummy or real:

```dart
class FoodHomeScreen extends StatelessWidget {
  const FoodHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('food_home'.tr)),
      body: GetBuilder<FoodController>(builder: (con) {
        if (con.isLoading) return const LoadingWidget();
        return ListView(
          padding: AppPadding.screen,
          children: [
            PromoBannerCarousel(banners: con.banners),
            // ... more widgets
          ],
        );
      }),
    );
  }
}
```

**Rules:**
- Run Design-First Workflow (above) before building screens
- Widgets are class-based, theme-first, no business logic
- Extract reusable widgets into `widgets/` subdirectory

### Cross-Feature Dependencies

When models are shared across features, import with **absolute package paths**:

```dart
// In cart/data/model/cart_item.dart:
import 'package:startup_repo/features/food_home/data/model/food_item.dart';
import 'package:startup_repo/features/food_detail/data/model/food_addon.dart';
```

**Owner rule:** The model lives in the feature where it's primarily defined.
Other features import it as a dependency.

| Model | Owner | Imported by |
|-------|-------|-------------|
| `FoodItem` | `food_home` | `food_detail`, `cart` |
| `FoodDetail` | `food_detail` | `food_home` (service) |
| `FoodAddon` | `food_detail` | `cart` |
| `CartItem` | `cart` | `food_detail` (controller) |

**Reference:** `cart/data/model/cart_item.dart` imports from both `food_home` and `food_detail`.

### API Specification Document

After building the feature, generate a markdown document for backend developers.
Save it as `docs/api/<feature>_api.md` in the project root.

**Template:**

```markdown
# <Feature> API Specification

## Overview
Brief description of what this feature does and its data flow.

---

### `GET /api/food/home`

**Purpose:** Fetch all data needed for the food home screen.

**Request:**
- Headers: `Authorization: Bearer <token>`
- Query params: none

**Response (200):**
\```json
{
  "banners": [
    {"id": "b1", "image": "https://...", "title": "50% Off", "subtitle": "Use code WELCOME50"}
  ],
  "categories": [
    {"id": "burger", "name": "Burgers", "icon": "🍔", "is_selected": false}
  ],
  "popular_items": [
    {"id": "1", "name": "Smash Burger", "price": 32.0, "rating": 4.8, ...}
  ],
  "all_items": [...]
}
\```
```

**Rules:**
- Response JSON shapes MUST match the model's `fromJson` keys exactly
- Use the dummy data values as example responses
- Include all endpoints the repo defines (one section per endpoint)
- Add error response shapes if relevant

**Reference:** Derive the JSON from models in `food_home/data/model/` and `food_detail/data/model/`.

### Swap to Real API

When backend delivers the API:

1. **Controller:** Delete `// DUMMY:` line, uncomment `// REAL:` line
2. **Service:** Dummy fallback still works as a safety net (returns dummy on `Failure`)
3. **Delete dummy files** once API is stable (`data/model/dummy/`)
4. **No other changes** — models, UI, controllers all stay the same

### Summary Checklist

- [ ] Created feature directory scaffold
- [ ] Models with `fromJson` / `toJson` / `const` constructors
- [ ] Dummy data with realistic values + container class
- [ ] Repo interface + impl with endpoint paths in `Endpoints`
- [ ] Service with dummy fallback pattern
- [ ] Binding wiring repo → service → controller
- [ ] Controller with `// DUMMY:` / `// REAL:` swap comments
- [ ] UI with class-based, theme-first widgets
- [ ] Binding registered in `get_di.dart`
- [ ] Cross-feature imports use absolute `package:` paths
- [ ] API spec document generated for backend team
