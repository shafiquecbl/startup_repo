# Workflows

> Read before building a new screen or feature.

---

## Quick Rules

1. **Design-first before screen code** — inventory screens, spot shared patterns, check tokens, plan widgets.
2. **Build widget files before assembling screens** — screens stay orchestration-only.
3. **Use existing components first** — search before creating new widgets/models/services.
4. **Core vs feature widgets** — `core/widgets/` for 2+ features; otherwise `presentation/widgets/`.
5. **Use focused feature folders** — split monoliths into real feature owners like `food_home`, `food_detail`, `cart`.
6. **Build dummy-data-first** — complete model, dummy data, repo, service, binding, controller, UI before API swap.
7. **Keep API swap simple** — dummy line and real service line should be easy to replace.
8. **Respect data ownership** — import owner models across features instead of duplicating them.
9. **Document backend contract** — write `docs/api/<feature>_api.md` after dummy feature build.
10. **Clean before sign-off** — delete dead comments, stale TODOs, and abandoned branches in active flows.

---

## Design-First — Before Any Screen Code

| Step | Action |
|------|--------|
| 1. Inventory | List every screen in the feature set |
| 2. Spot repeating patterns | Cards, tiles, badges, empty states used on 2+ screens |
| 3. Token-check | Snap non-token values to nearest token (no new tokens) |
| 4. Plan widgets | `core/widgets/` if used in ≥2 features, else `presentation/widgets/` |
| 5. Build widget files first | One meaningful widget class per file, then assemble screens |
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
    ├── view/
    │   └── <feature>_screen.dart       # orchestration only
    └── widgets/                        # one meaningful widget per file
```

### Build Order: Model → Dummy → Repo → Service → Binding → Controller → UI

### Feature Organization

Prefer focused features over monoliths.

```
// ✅ CORRECT
features/food_home/
features/food_detail/
features/cart/

// ❌ WRONG
features/food/  // home + detail + cart mixed together
```

Use cross-feature imports for real ownership instead of merging unrelated screens into one feature.

### File Split Heuristic

Create a separate widget file when the UI has a meaningful name, logic, state, callback contract, or reuse.

Rules:
- screen file = orchestration only
- extracted widget class = own file
- shared across 2+ features = `core/widgets/`
- large feature widget set = subfolders under `widgets/`
- tiny one-off layout = keep inline; do not invent a widget name just to split

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

---

## Production Cleanup

Before sign-off:
- delete dead commented code
- delete stale TODOs in active flows
- use the working behavior or an explicit safe fallback
- do not leave abandoned branches inside production widgets/controllers
