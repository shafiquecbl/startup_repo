# Workflows

> Read before building a new screen or feature.

---

## Quick Rules

1. **Design-first before screen code** — inventory screens, spot shared patterns, check tokens, plan widgets.
2. **Build widget files before assembling screens** — screens stay orchestration-only.
3. **Use existing components first** — search before creating new widgets/models/services.
4. **Core vs feature widgets** — `core/widgets/` for 2+ features; otherwise `presentation/widgets/`.
5. **Use focused feature folders** — split monoliths by distinct domain responsibility.
6. **Dummy data stays isolated** — use it for previews, catalogs, and tests; never as a silent production fallback.
7. **One active path** — do not keep commented dummy/real alternatives in controllers or services.
8. **Respect data ownership** — import owner models across features instead of duplicating them.
9. **Document backend contract only when needed** — write `docs/api/<feature>_api.md` only when requested or the task includes backend handoff.
10. **Clean before sign-off** — delete dead comments, stale TODOs, and abandoned branches in active flows.
11. **Plan every UI state** — initial, loading, refreshing, paginating, error, empty, and content where applicable.

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

**Snap rule:** Design says 12px padding → use the existing `p12` token. If no exact token exists, use the nearest
approved token instead of creating a one-off value.

---

## New Feature

> Build the real feature flow. Dummy data may support design/testing, but it must not become a second commented
> production path.

### Directory Scaffold

```
lib/features/<feature>/
├── data/
│   ├── model/
│   │   ├── <feature>_model.dart
│   │   └── dummy/dummy_<feature>_data.dart  # only for requested previews/tests/demos
│   └── repository/
│       ├── <feature>_repo.dart          # abstract
│       └── <feature>_repo_impl.dart     # ApiClient calls
├── domain/
│   ├── binding/<feature>_binding.dart
│   └── service/
│       ├── <feature>_service.dart       # abstract
│       └── <feature>_service_impl.dart  # parsing + feature logic
└── presentation/
    ├── controller/<feature>_controller.dart
    ├── view/
    │   └── <feature>_screen.dart       # orchestration only
    └── widgets/                        # one meaningful widget per file
```

### Build Order: Contract → Model → Repo → Service → Binding → Controller → UI

### Feature Organization

Prefer focused features over monoliths.

```
// ✅ CORRECT — separate domain responsibilities
features/catalog/
features/item_detail/
features/checkout/

// ❌ WRONG
features/store/  // unrelated catalog, detail, and checkout flows mixed together
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

Use this file from previews, catalogs, or tests. If a temporary demo build needs it, wire a clearly named demo
implementation in DI. Do not comment/uncomment production lines, and do not replace a failed API response with dummy
success data.

#### Repo
```dart
// Always thin — no logic, just API calls + Endpoints
class FeatureRepoImpl extends FeatureRepo {
  final ApiClient client;
  FeatureRepoImpl({required this.client});

  @override
  Future<ApiResult<Object?>> fetchData() =>
      client.execute(const ApiRequest(method: ApiMethod.get, path: Endpoints.featureData));
}
```

#### Service
```dart
@override
Future<FeatureData?> fetchData() async {
  final ApiResult<Object?> result = await featureRepo.fetchData();
  if (result case Success<Object?>(data: final Object? data)) {
    return FeatureData.fromJson(readJsonMap(data));
  }
  return null;
}
```

#### Controller
```dart
Future<void> load() async {
  isLoading = true;
  _data = await featureService.fetchData();
  _hasError = _data == null;
  isLoading = false;
}
```

#### UI
```dart
GetBuilder<FeatureController>(builder: (con) {
  if (con.isInitialLoading) return const FeatureSkeleton();
  if (con.hasError) return ErrorStateWidget(message: 'error', onRetry: con.load);
  if (con.data!.items.isEmpty) return const EmptyStateWidget(...);
  return FeatureContent(
    data: con.data!,
    isRefreshing: con.isRefreshing,
    isPaginating: con.isPaginating,
  );
})
```

Do not use `FutureBuilder` for this flow. The controller owns the request lifecycle and keeps loaded data across normal
widget rebuilds. Retry, refresh, and pagination call explicit controller methods. Refresh and pagination preserve
existing content; a local mutation reports progress on the affected action instead of replacing the full screen.

---

## Cross-Feature Imports

```dart
// Use absolute package paths when importing from another feature
import 'package:<pubspec_name>/features/catalog/data/model/item.dart';
```

Replace `<pubspec_name>` with the current package name from `pubspec.yaml`. Keep one owning feature for each model;
other features import that model instead of duplicating it.

---

## API Spec Doc

Create `docs/api/<feature>_api.md` only when the user requests it or backend handoff is part of the task. Do not add
documentation as an automatic side effect of ordinary feature work.

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
