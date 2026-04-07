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

### Large Controllers — Mixin Composition

When controller > **~150 lines** or has **3+ concerns**, split into mixins:

```
presentation/
├── controller/feature_controller.dart  # thin orchestrator only
└── mixin/
    ├── auth_mixin.dart    # one concern per file
    └── timer_mixin.dart
```

```dart
// Controller just wires + calls lifecycle hooks
class FeatureController extends GetxController
    with AuthMixin, TimerMixin implements GetxService {
  @override final FeatureService featureService; // satisfies mixin contracts
  static FeatureController get find => Get.find<FeatureController>();
  @override void onClose() { disposeTimer(); super.onClose(); }
}

// Mixin owns one concern
mixin TimerMixin on GetxController {
  FeatureService get featureService;    // contract — controller provides
  Future<void> stopListener();          // contract — other mixin provides
  Timer? _timer;
  void disposeTimer() => _timer?.cancel(); // controller calls in onClose()
}
```

**Rules:** Never call `Get.find` inside a mixin. Every mixin with resources must have `disposeXxx()`.
**Reference:** `ycab_user/features/ride_booking/presentation/`

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

## Models — Request / Response / Route Params

When passing **3+ params** to a method or navigating with data — use a typed model.

| Use | Suffix | Has |
|-----|--------|-----|
| Data sent to API | `XxxRequestModel` | `toJson()` |
| Data from API | `XxxModel` | `fromJson()` |
| Screen navigation data | `XxxRouteParamsModel` | nothing |

```dart
// ❌ service.signup(name, email, password, phone)
// ✅
class SignupRequestModel {
  final String name; final String email; final String password;
  const SignupRequestModel({required this.name, required this.email, required this.password});
  Map<String, dynamic> toJson() => {'name': name, 'email': email, 'password': password};
}
Future<void> signup({required SignupRequestModel request}) async { ... }
```

File placement: `data/model/<feature>_route_models.dart` for request + route param models.
**Reference:** `ycab_user/features/ride_booking/data/model/book_ride_route_models.dart`

---

## Endpoints (`core/utils/endpoints.dart`)

```dart
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
- Error toast shown automatically by `ApiClientImpl` — callers never need try/catch

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

Add `FeatureBinding()` to `get_di.dart`. Controller must implement `GetxService` or `Get.find()` will fail.
