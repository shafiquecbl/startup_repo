# Architecture & API Client

> **When to read:** Before creating any new feature, modifying a controller/service/repo,
> or writing API integration code.

---

## Architecture — The Golden Rule

**Clean Architecture + Feature-First.** Every feature is self-contained:

```
lib/features/<feature>/
├── data/
│   ├── model/          # Data models (fromJson, toJson)
│   └── repository/     # Interface + Implementation (API calls)
├── domain/
│   ├── binding/        # GetX DI wiring
│   └── service/        # Interface + Implementation (business logic)
└── presentation/
    ├── controller/     # GetxController (state, methods)
    └── view/           # Widgets (UI only)
```

**The Chain:** `Controller → Service → Repository → ApiClient`

### Rules

- **Controller** holds state and calls service. Never touches ApiClient directly.
- **Service** contains business logic, transforms data. Calls repository.
- **Repository** is a thin pass-through to ApiClient. No logic here.
- **Binding** wires everything via `Get.lazyPut`. Registered in `get_di.dart`.
- **View** is dumb UI. Uses `GetBuilder<Controller>` to rebuild. No business logic.

### Binding Pattern (always follow this)

```dart
class FeatureBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    Get.lazyPut<FeatureRepo>(() => FeatureRepoImpl(apiClient: Get.find()));
    // service
    Get.lazyPut<FeatureService>(() => FeatureServiceImpl(featureRepo: Get.find()));
    // controller
    Get.lazyPut(() => FeatureController(featureService: Get.find()));
  }
}
```

Then add `FeatureBinding()` to the `bindings` list in `get_di.dart`.

### Controller Pattern

```dart
class FeatureController extends GetxController {
  final FeatureService featureService;
  FeatureController({required this.featureService});

  // Static finder — the preferred way to access controllers
  static FeatureController get find => Get.find<FeatureController>();

  // Private state with public getters
  FeatureModel? _data;
  FeatureModel? get data => _data;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    update(); // notify listeners
  }

  Future<void> loadData() async {
    isLoading = true;
    final result = await featureService.getData();
    if (result case Success(data: final data)) {
      _data = data;
    }
    // Failure? Toast was already shown by API client. Nothing to do.
    isLoading = false;
  }
}
```

Key conventions:
- **Static `find` getter** on every controller
- **Private fields** with public getters (`_data` / `data`)
- **Loading setter** that calls `update()` automatically
- **Pattern matching** on `ApiResult` with `case Success(data: final x)`
- **Failure comment:** `// Failure? Toast was already shown by API client.`

---

## API Client — Sealed Results, Never Null

### Return Type

All API methods return `ApiResult<Response>` — a **sealed class**:

```dart
sealed class ApiResult<T> { const ApiResult(); }
class Success<T> extends ApiResult<T> { final T data; }
class Failure<T> extends ApiResult<T> { final String message; final int? statusCode; }
```

**Never return `null`. Never return `Response?`. Always return `ApiResult`.**

### Endpoints (`core/utils/endpoints.dart`)

All API endpoint paths live in the `Endpoints` class — **never hardcode paths in repos**:

```dart
class Endpoints {
  Endpoints._();

  static const String config = 'config';
  static const String foodHome = 'api/food/home';
  static const String foodDetail = 'api/food/'; // + {id}
}
```

**Rules:**
- **NEVER** put endpoint strings in `AppConstants` — they belong in `Endpoints`
- `AppConstants` is only for app-level config (name, base URL)
- Group endpoints by feature with comments

### Repository Pattern

```dart
abstract class FeatureRepo {
  Future<ApiResult<Response>> getData();
}

class FeatureRepoImpl implements FeatureRepo {
  final ApiClient apiClient;
  FeatureRepoImpl({required this.apiClient});

  @override
  Future<ApiResult<Response>> getData() async =>
    await apiClient.get(Endpoints.featureData);
}
```

### Service Pattern — Transform Results

Services unwrap `ApiResult<Response>` into `ApiResult<Model>`:

```dart
@override
Future<ApiResult<FeatureModel>> getData() async {
  final result = await featureRepo.getData();
  return switch (result) {
    Success(data: final response) => _parse(response.body),
    Failure(:final message, :final statusCode) => Failure(message, statusCode: statusCode),
  };
}

ApiResult<FeatureModel> _parse(String body) {
  try {
    return Success(FeatureModel.fromJson(jsonDecode(body)));
  } catch (_) {
    return const Failure('Failed to parse data');
  }
}
```

### Error Handling

- `ApiClientImpl` handles **all** error display automatically via `AppDialog.showToast()`
- `ApiErrorParser` extracts messages from multiple backend formats
- Callers **never need try/catch** for API errors — just check `Success` vs `Failure`
- The only exception: `showLoading()` / `hideLoading()` pairs in controllers
