# Architecture & API Client

> Read before creating/modifying any feature, service, repo, or controller.

---

## Feature Structure

```
lib/features/<feature>/
├── data/
│   ├── model/          # fromJson, toJson, const constructors
│   │   └── dummy/      # dummy_<feature>_data.dart
│   └── repository/     # abstract + impl (API calls only)
├── domain/
│   ├── binding/        # Get.lazyPut wiring
│   └── service/        # abstract + impl (business logic)
└── presentation/
    ├── controller/     # GetxController
    └── view/           # widgets (UI only)
```

**Chain:** `Controller → Service → Repository → ApiClient`

---

## Controller

```dart
class FeatureController extends GetxController implements GetxService {
  final FeatureService featureService;
  FeatureController({required this.featureService});

  static FeatureController get find => Get.find<FeatureController>();

  FeatureModel? _data;
  FeatureModel? get data => _data;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) { _isLoading = value; update(); }

  Future<void> load() async {
    isLoading = true;
    _data = await featureService.getData(); // null = failed, toast already shown
    isLoading = false;
  }
}
```

---

## Service — Returns the Model, NOT ApiResult

```dart
// ✅ DEFAULT — unwrap in service, controller gets clean model
Future<FeatureModel?> getData() async {
  final ApiResult<Response> result = await featureRepo.getData();
  if (result case Success(data: final response)) {
    return FeatureModel.fromJson(jsonDecode(response.body));
  }
  return null; // Failure — API client already showed toast
}

// Use List<Model> (empty on failure) or Model (dummy fallback) as appropriate.
// Reference: food_home/domain/service/food_service_impl.dart
```

```dart
// ⚠️ EXCEPTION — return ApiResult<Model> ONLY when controller must react to failure
// (e.g., config load failure → redirect). Reference: splash_service_impl.dart
```

| Scenario | Return type |
|----------|-------------|
| Failure = show empty state | `Model?` |
| Failure = show empty list | `List<Model>` |
| Failure = show dummy data | `Model` (never null) |
| Failure = block the flow | `ApiResult<Model>` ⚠️ |

---

## Repository — Thin Pass-Through Only

```dart
// ✅ No logic. Only API calls. Always ApiResult<Response>.
Future<ApiResult<Response>> getData() async =>
    await apiClient.get(Endpoints.featureData);
```

---

## Endpoints (`core/utils/endpoints.dart`)

```dart
// ✅ All API paths here — grouped by feature
class Endpoints {
  Endpoints._();
  static const String config = 'config';
  static const String foodHome = 'api/food/home';
}

// ❌ NEVER put endpoint paths in AppConstants
```

---

## ApiResult — Sealed, Never Null

```dart
sealed class ApiResult<T> { const ApiResult(); }
class Success<T> extends ApiResult<T> { final T data; }
class Failure<T> extends ApiResult<T> { final String message; final int? statusCode; }
```

- **Repo always returns `ApiResult<Response>`** — never nullable
- Error toast is shown automatically by `ApiClientImpl` — callers never need try/catch

---

## Binding

```dart
class FeatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeatureRepo>(() => FeatureRepoImpl(apiClient: Get.find()));
    Get.lazyPut<FeatureService>(() => FeatureServiceImpl(featureRepo: Get.find()));
    Get.lazyPut(() => FeatureController(featureService: Get.find()));
  }
}
```

Add `FeatureBinding()` to the `bindings` list in `get_di.dart`.

**Critical:** A feature is not DI-complete until both are true:
1. Controller implements `GetxService`
2. Binding is registered in `core/helper/get_di.dart`

Missing either one causes runtime `Get.find()` failures.
