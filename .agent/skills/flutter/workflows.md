# Workflows

> Read before building a new screen or feature.

---

## Design-First — Before Any Screen Code

| Step | Action |
|------|--------|
| 1. Inventory | List every screen in the feature set |
| 2. Spot repeating patterns | Cards, tiles, badges, empty states used on 2+ screens |
| 3. Token-check | Snap non-token values to nearest token (no new tokens) |
| 4. Plan widgets | `core/widgets/` if used in ≥2 features, else `view/widgets/` |
| 5. Build widgets first | Then assemble screens from widgets |
| 6. Consistency review | All spacings/radii/colors use tokens, same `Scaffold` structure |
| 7. Production cleanup | Remove TODO/dead commented paths from active flows before sign-off |

**Snap rule:** Design says 12px padding → use `p8` or `p16`. Never create a one-off value.

---

## Dummy-Data-First — New Feature

> Build complete feature with dummy data first. Swap to real API in one line per endpoint.
> **Reference implementation:** `food_home/`, `food_detail/`, `cart/`

### Directory Scaffold

```
lib/features/<feature>/
├── data/
│   ├── model/
│   │   ├── <feature>_model.dart
│   │   └── dummy/dummy_<feature>_data.dart
│   └── repository/
│       ├── <feature>_repo.dart          # abstract
│       └── <feature>_repo_impl.dart     # ApiClient calls
├── domain/
│   ├── binding/<feature>_binding.dart
│   └── service/
│       ├── <feature>_service.dart       # abstract
│       └── <feature>_service_impl.dart  # logic + dummy fallback
└── presentation/
    ├── controller/<feature>_controller.dart
    └── view/
        ├── <feature>_screen.dart
        └── widgets/
```

### Build Order: Model → Dummy → Repo → Service → Binding → Controller → UI

### File Split Heuristic (avoid over-fragmentation)

Keep a widget in its own file only if one is true:
- reused in 2+ places
- over ~70 lines or has meaningful logic
- likely to be tested independently

Otherwise, colocate as a private class in the parent file (still class-based, never `Widget _buildX`).

#### Model
```dart
class FeatureModel {
  final String id;
  const FeatureModel({required this.id});
  factory FeatureModel.fromJson(Map<String, dynamic> json) =>
      FeatureModel(id: json['id'] as String);
  Map<String, dynamic> toJson() => {'id': id};
}
```

#### Dummy Data
```dart
// dummy_feature_data.dart
final List<FeatureModel> dummyFeatureItems = [
  const FeatureModel(id: '1'),
  // ... realistic data that fills the UI
];

class FeatureData {
  final List<FeatureModel> items;
  const FeatureData({required this.items});
  factory FeatureData.dummy() => FeatureData(items: dummyFeatureItems);
  factory FeatureData.fromJson(Map<String, dynamic> json) => FeatureData(
    items: (json['items'] as List).map((dynamic i) => FeatureModel.fromJson(i)).toList(),
  );
}
```

#### Repo
```dart
// Always thin — no logic, just API calls + Endpoints
class FeatureRepoImpl extends FeatureRepo {
  final ApiClient client;
  FeatureRepoImpl({required this.client});

  @override
  Future<ApiResult<Response>> fetchData() async =>
      await client.get(Endpoints.featureData);
}
```

#### Service — DUMMY/REAL Swap Pattern
```dart
@override
Future<FeatureData?> fetchData() async {
  final ApiResult<Response> result = await featureRepo.fetchData();
  if (result case Success(data: final response)) {
    return FeatureData.fromJson(jsonDecode(response.body));
  }
  return null;
}
```

#### Controller — DUMMY/REAL Comment
```dart
Future<void> load() async {
  isLoading = true;

  // DUMMY: swap this line when backend is ready
  _data = FeatureData.dummy();
  // REAL: _data = await featureService.fetchData();

  isLoading = false;
}
```

When backend is ready: delete `// DUMMY` line, uncomment `// REAL`. Done.

#### UI
```dart
GetBuilder<FeatureController>(builder: (con) {
  if (con.isLoading) return const LoadingWidget();
  if (con.data == null) return const EmptyStateWidget(...);
  return FeatureContent(data: con.data!);
})
```

---

## Cross-Feature Imports

```dart
// Use absolute package paths when importing from another feature
import 'package:startup_repo/features/food_home/data/model/food_item.dart';
```

| Model | Owner feature | Imported by |
|-------|--------------|-------------|
| `FoodItem` | `food_home` | `food_detail`, `cart` |
| `FoodAddon` | `food_detail` | `cart` |
| `CartItem` | `cart` | `food_detail` |

---

## API Spec Doc

After building, generate `docs/api/<feature>_api.md` for backend devs.

```markdown
### `GET /api/feature/data`
**Response (200):**
\```json
{"items": [{"id": "1", ...}]}
\```
Response JSON must match model's `fromJson` keys exactly.
```
