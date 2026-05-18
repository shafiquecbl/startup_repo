# Architecture & API Client

> Read before creating/modifying any feature, service, repo, or controller.

---

## Quick Rules

1. **Feature folders stay layered** — `data/`, `domain/`, `presentation/`; screens in `presentation/view/`, extracted widgets in `presentation/widgets/`.
2. **Do not invent architecture layers** — do not add new top-level feature layers or bypass the defined layer responsibilities.
3. **Enums live beside models** — keep feature enums in `features/<feature>/data/enum/`, just like models live in `data/model/`.
4. **Flow is one-way** — `Controller → Service → Repository → ApiClient`.
5. **Controller owns UI state** — loading/data/error fields, `update()`, and lifecycle cleanup live in controller.
6. **Controller implements `GetxService`** — feature binding must register it in `core/helper/get_di.dart`.
7. **Large controllers split into mixins** — split after ~150 lines or 3+ concerns; mixins never call `Get.find()`.
8. **Repository is API-only** — only calls `ApiClient`, returns `ApiResult<Response>`, no parsing/business logic.
9. **Service owns parsing** — unwraps `ApiResult`, parses JSON, returns plain model/list/null to controller.
10. **Controller never handles raw API** — no `Response`, no `ApiResult`, no `jsonDecode` in controllers.
11. **Typed models for data boundaries** — use `XxxRequestModel`, `XxxModel`, `XxxRouteParamsModel`.
12. **3+ params need a model** — no loose method/navigation arg lists.
13. **Endpoint paths live in `Endpoints`** — never in `AppConstants`, views, controllers, or repos.
14. **`ApiResult` is sealed and never nullable** — failure is explicit, not `null`.
15. **Error parsing is centralized** — use `ApiErrorParser`; do not parse raw error bodies elsewhere.
16. **Stable UI mapping lives in enum/model getters** — no duplicated mapping methods in widgets.

---

## Feature Structure

```
lib/features/<feature>/
├── data/
│   ├── model/          # fromJson, toJson, const constructors
│   │   └── dummy/      # dummy_<feature>_data.dart
│   ├── enum/           # feature enums and enum mapping extensions
│   └── repository/     # abstract + impl (API calls only)
├── domain/
│   ├── binding/        # Get.lazyPut wiring
│   └── service/        # abstract + impl (business logic)
└── presentation/
    ├── controller/     # GetxController
    ├── view/           # route screens only
    └── widgets/        # extracted feature widgets
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

| Scenario                   | Return type           |
| -------------------------- | --------------------- |
| Failure = show empty state | `Model?`              |
| Failure = show empty list  | `List<Model>`         |
| Failure = show dummy data  | `Model` (never null)  |
| Failure = block the flow   | `ApiResult<Model>` ⚠️ |

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

| Use                    | Suffix                | Has          |
| ---------------------- | --------------------- | ------------ |
| Data sent to API       | `XxxRequestModel`     | `toJson()`   |
| Data from API          | `XxxModel`            | `fromJson()` |
| Screen navigation data | `XxxRouteParamsModel` | nothing      |

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

## Error Parsing

Use `ApiErrorParser` for backend error messages.

Rules:

- parsing logic lives in `core/api/error.dart`
- `ApiClientImpl` calls parser once in `_handleResponse`
- repositories/services/controllers do not parse raw error bodies
- add parser strategies when backend formats differ; do not scatter `jsonDecode` error checks

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

---

## Stable UI Mapping

Move stable mapping logic into enums/models instead of duplicating widget methods.
Feature enums live under `features/<feature>/data/enum/`.

```dart
// ✅ enum owns mapping
enum OrderStatus {
  pending,
  outForDelivery;

  int get deliveryStep => switch (this) {
    OrderStatus.pending => 0,
    OrderStatus.outForDelivery => 2,
  };
}

// ❌ repeated in multiple widgets
int deliveryStepForStatus(OrderStatus status) => ...
```
