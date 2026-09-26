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
8. **Repository is infrastructure-only** — calls `ApiClient`, storage, or database and returns raw `ApiResult<Object?>`; no feature models, parsing, or business logic.
9. **Service owns feature logic** — converts models to request data, unwraps `ApiResult`, parses raw JSON, and returns plain values/models to controllers.
10. **Controller owns UI state** — no `ApiResult`, raw response parsing, repository calls, or `FutureBuilder`-owned feature state.
11. **Typed inputs represent one action** — a cohesive form/action payload travels UI → controller → service as one model.
12. **Do not model by parameter count** — independent ids, pages, queries, and toggles may stay scalars; avoid one-field wrappers and mechanical `3+` rules.
13. **Endpoint paths live in `Endpoints`** — never in `AppConstants`, views, controllers, or repos.
14. **Repository `ApiResult` is sealed and never nullable** — services translate it into the simplest feature-facing result.
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

  bool _hasError = false;
  bool get hasError => _hasError;

  Future<void> load() async {
    isLoading = true;
    _data = await featureService.getData();
    _hasError = _data == null;
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

## Service — Feature Logic and Parsing

```dart
Future<FeatureModel?> getData() async {
  final ApiResult<Object?> result = await featureRepo.getData();
  if (result case Success<Object?>(data: final Object? data)) {
    return FeatureModel.fromJson(readJsonMap(data));
  }
  return null;
}
```

- A model query returns `Model?`: model = success, `null` = failure/no usable response.
- A list query returns `List<Model>?`: `null` = failure, `[]` = successful empty result.
- A mutation can return `bool`: `true` = success, `false` = failure.
- Do not return dummy data after a failed production request. Dummy data belongs in previews/tests/catalogs.
- Controllers never receive `ApiResult<Object?>`.

---

## Repository — Thin Pass-Through Only

```dart
// No model import. No JSON parsing. No business decision.
Future<ApiResult<Object?>> getData() =>
    apiClient.execute(const ApiRequest(method: ApiMethod.get, path: Endpoints.featureData));
```

Repositories may call the API client, local database, secure storage, or preferences. They only adapt those
infrastructure calls. The service decides what the raw result means for the feature.

---

## Models — Request / Response / Route Params

Create an input/request model when values form one user action, such as signup, checkout, or profile submission. Build
it at the UI submit boundary and pass the same typed value through controller and service. This keeps those contracts
stable when the form gains or loses a field. The service validates/normalizes it and converts it to raw transport data
before calling the repository.

Do not create a model only because a method has several parameters. Independent ids, page numbers, search queries,
and single toggles normally remain explicit scalar parameters. A one-value wrapper normally makes the flow harder to
read.

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

Keep each model in a focused file. Do not collect unrelated request and response models into one large file.

Services convert request models to `Map<String, dynamic>` before calling repositories. Repositories do not import
feature models.

---

## Multipart / Media Uploads

Keep uploads inside the same feature chain:

`UI → Controller → Feature Service → Repository → ApiClient`

- The service owns validation, normalization, file limits, and the logical user action.
- The repository converts raw fields and file paths/bytes into multipart transport and performs the request.
- The API client sends the request and returns `ApiResult<Object?>` like every other endpoint.
- Prefer one multipart request when fields and files belong to one save action and the backend supports it.
- Use separate upload calls only when the backend contract or an independently retryable media lifecycle requires it.
- Do not add a generic `UploadService` merely because a request contains a file.
- Repositories still do not accept or parse feature response models.

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

- **Repository always returns `ApiResult<Object?>`** — never nullable.
- `Success<Object?>.data` is the raw decoded transport body from Dio.
- The service parses that value into the feature model.
- Transport/backend error feedback remains centralized in the API client.

---

## Error Parsing

Use `ApiErrorParser` for backend error messages.

Rules:

- backend error parsing lives under `core/api/support/`
- `DioApiClient` maps failures once
- repositories/services/controllers do not parse backend error payloads
- add parser strategies when backend formats differ; do not scatter `jsonDecode` error checks

Response data parsing is different: the feature service parses successful raw data into its models.

---

## Loading Lifecycle

Model these transitions deliberately:

`initial → loading → content | empty | error → refreshing | paginating`

- Start initial loading from the controller lifecycle or an explicit screen entry method.
- Keep loaded data in controller state so ordinary rebuilds/navigation do not refetch it.
- Initial failure and successful empty data are different states.
- Refresh keeps current content visible; it must not clear the screen back to initial loading.
- Pagination appends data and uses footer progress; a page failure preserves the existing list.
- A button/tile mutation owns its local loading state instead of blocking the whole screen.
- Retry, pull-to-refresh, pagination, and user actions are explicit request events.
- Do not use `FutureBuilder` for repository/service calls. Rebuilding it can recreate futures and duplicate requests.

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
