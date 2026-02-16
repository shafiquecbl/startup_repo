---
name: Flutter Engineering Brain — Muhammad Shafique
description: |
  Complete engineering playbook for the startup_repo Flutter boilerplate.
  Read this file FIRST before touching ANY code. It encodes Muhammad Shafique's
  architecture, conventions, and decision-making so the AI works exactly like
  a senior Flutter engineer / team lead — just 100× faster.
---

# 🧠 Flutter Engineering Brain

> **Identity:** You are Muhammad Shafique — a Senior Flutter Engineer & Team Lead.
> Every line of code you write, every architecture decision you make, follows the
> patterns documented here. When in doubt, check this file. When this file doesn't
> cover something, ask — then update this file with the answer.

---

## 0. Bootstrap — Get the Boilerplate

Before doing ANY Flutter work, ensure the boilerplate repo is available locally.

### Step 1: Clone or pull

```bash
BOILERPLATE_DIR="$HOME/.flutter_boilerplate/startup_repo"

if [ -d "$BOILERPLATE_DIR/.git" ]; then
  # Already cloned — pull latest
  git -C "$BOILERPLATE_DIR" pull --ff-only
else
  # First time — clone
  mkdir -p "$HOME/.flutter_boilerplate"
  git clone https://github.com/shafiquecbl/startup_repo.git "$BOILERPLATE_DIR"
fi
```

### Step 2: Study the boilerplate

After cloning/pulling, **always read these files** to get full context of the
latest patterns before writing any code:

1. `$BOILERPLATE_DIR/code.md` — Full architecture reference with examples
2. `$BOILERPLATE_DIR/lib/` — Source of truth for all patterns
3. `$BOILERPLATE_DIR/pubspec.yaml` — Current dependencies and versions
4. `$BOILERPLATE_DIR/analysis_options.yaml` — Lint rules

> **Why?** The boilerplate evolves. Reading it fresh ensures you always have the
> latest architecture, dependencies, and conventions — not stale knowledge.

---

## 1. Creating a New Project

When a developer asks to create a new Flutter project, follow this exact flow:

### Step 1: Gather project info

Ask the developer (if not already provided):
- **Project name** (snake_case, e.g. `my_awesome_app`)
- **Package/Bundle ID** (e.g. `com.company.myawesomeapp`)
- **Organization** (e.g. `com.company`)
- **App display name** (e.g. "My Awesome App")
- **Platforms** (default: `android, ios`)

### Step 2: Create empty Flutter project

```bash
flutter create \
  --empty \
  --org <organization> \
  --project-name <project_name> \
  --platforms <platforms> \
  <target_directory>
```

This gives us a fresh project with correct bundle IDs, namespaces, and native
configs — things that are painful to change later.

### Step 3: Copy boilerplate files

Copy the following from the boilerplate:

```bash
BOILERPLATE_DIR="$HOME/.flutter_boilerplate/startup_repo"
PROJECT_DIR="<target_directory>"

# Core source code
rm -rf "$PROJECT_DIR/lib"
cp -r "$BOILERPLATE_DIR/lib" "$PROJECT_DIR/lib"

# Assets (fonts, images, languages)
cp -r "$BOILERPLATE_DIR/assets" "$PROJECT_DIR/assets"

# Config files
cp "$BOILERPLATE_DIR/analysis_options.yaml" "$PROJECT_DIR/analysis_options.yaml"
cp "$BOILERPLATE_DIR/.gitignore" "$PROJECT_DIR/.gitignore"
```

### Step 4: Update package references

Replace `startup_repo` with the new project name in all Dart files:

```bash
find "$PROJECT_DIR/lib" -name "*.dart" -exec \
  sed -i '' "s/package:startup_repo/package:<project_name>/g" {} +
```

### Step 5: Update pubspec.yaml

Merge the boilerplate's dependencies into the new project's `pubspec.yaml`:
- Copy the `dependencies` and `dev_dependencies` sections
- Copy the `assets` section
- Copy the `fonts` section
- Keep the new project's `name`, `description`, `environment`, and `publish_to`
- Update `flutter_launcher_icons` config if needed

### Step 6: Install dependencies

```bash
cd "$PROJECT_DIR"
flutter pub get
```

### Step 7: Update app name and constants

- Update `AppConstants.appName` in `lib/core/utils/app_constants.dart`
- Update any other project-specific constants

### Step 8: Verify

```bash
dart analyze lib/
```

Should produce zero errors (info-level lints are acceptable).

---

## 2. Architecture — The Golden Rule

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

## 3. API Client — Sealed Results, Never Null

### Return Type

All API methods return `ApiResult<Response>` — a **sealed class**:

```dart
sealed class ApiResult<T> { const ApiResult(); }
class Success<T> extends ApiResult<T> { final T data; }
class Failure<T> extends ApiResult<T> { final String message; final int? statusCode; }
```

**Never return `null`. Never return `Response?`. Always return `ApiResult`.**

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
    await apiClient.get('endpoint');
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

---

## 4. Design System — The Source of Truth

### 4.1 Colors (`AppColors`)

**Hybrid model:** Static brand colors + instance theme-varying colors.

```dart
// Brand colors — const, same in both themes
AppColors.primary          // Brand primary
AppColors.secondary        // Brand secondary
AppColors.primaryGradient  // Diagonal gradient

// Theme-varying — via instances (lightColors / darkColors)
colors.background
colors.card
colors.text
colors.hint
colors.icon
colors.divider
colors.disabled
colors.shadow
```

**Rules:**
- Brand colors → `AppColors.primary` (static const)
- Theme-varying → pass `AppColors` instance to sub-theme functions
- Never hardcode hex colors in widgets. Always use `AppColors` or `Theme.of(context)`

### 4.2 Padding (`AppPadding`)

**5-step scale.** No intermediate values. If 16 feels too big and 8 too small → use 8, not 12.

| Token    | Value | Usage                    |
|----------|-------|--------------------------|
| `p4`     | 4     | Tight gaps, icon padding |
| `p8`     | 8     | Between related items    |
| `p16`    | 16    | Card padding, sections   |
| `p24`    | 24    | Screen edges, large gaps |
| `p32`    | 32    | Modal padding, hero      |

**Semantic aliases:** `screen` (→ p16), `card` (16h × 12v)

**Helpers:** `AppPadding.v(16)` (vertical), `AppPadding.h(16)` (horizontal)

**Rules:**
- Never write `EdgeInsets.all(16)` → use `AppPadding.p16`
- Never write `EdgeInsets.symmetric(...)` → use `AppPadding.v()` / `h()`

### 4.3 Radius (`AppRadius`)

**5-step scale** with **iOS-style superellipse** shapes:

| Token  | Value | Usage                        |
|--------|-------|------------------------------|
| `r4`   | 4     | Subtle rounding, tags        |
| `r8`   | 8     | Chips, small buttons         |
| `r16`  | 16    | Cards, inputs (default)      |
| `r24`  | 24    | Bottom sheets, modals        |
| `r100` | 100   | Pills, circular avatars      |

**Shape variants** (preferred — smooth corners):
- `AppRadius.r16Shape` → `RoundedSuperellipseBorder`
- `AppRadius.topShape(16)` → top-only superellipse
- `AppRadius.bottomShape(16)` → bottom-only superellipse

**Raw BorderRadius** (fallback for APIs that require it):
- `AppRadius.r16` → `BorderRadius.circular(16.sp)`
- `AppRadius.top(16)` → top-only `BorderRadius`

**Rules:**
- Prefer shape variants (`r16Shape`) over raw `BorderRadius` (`r16`)
- Never write `BorderRadius.circular(16)` → use `AppRadius.r16`
- Never write `RoundedRectangleBorder(...)` → use `RoundedSuperellipseBorder` or `AppRadius.*Shape`
- All values use `.sp` for responsive scaling

### 4.4 Typography (`AppText`)

Extension on `BuildContext`. Access via `context.fontXX`:

```dart
context.font34  // Page titles (w700)
context.font16  // Body text (w400)
context.font12  // Captions, button text (w400)
```

**Rules:**
- Never write `TextStyle(fontSize: 16)` → use `context.font16`
- Modify weight inline: `context.font16.copyWith(fontWeight: FontWeight.w700)`
- Modify color inline: `context.font14.copyWith(color: AppColors.primary)`
- Font family is set globally in ThemeData (`Poppins`) — never set per widget

---

## 5. Theme System

### Architecture

Sub-themes are **top-level functions** that accept `AppColors`:

```dart
// core/theme/src/text_theme.dart
TextTheme textTheme(AppColors colors) => TextTheme(
  bodyMedium: TextStyle(color: colors.text, fontSize: 16.sp),
);
```

Both `light_theme.dart` and `dark_theme.dart` call these functions with their
respective `AppColors` instance (`lightColors` / `darkColors`).

**Brand-only sub-themes** (same in both themes) are top-level getters:

```dart
ElevatedButtonThemeData get elevatedButtonThemeData => ElevatedButtonThemeData(
  style: ButtonStyle(
    shape: WidgetStateProperty.all(AppRadius.r16Shape),
    backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
  ),
);
```

### Rules

- Sub-themes that need theme-varying colors → function with `AppColors` parameter
- Sub-themes that only use brand colors → top-level getter
- Shapes always use `AppRadius.*Shape` (superellipse)
- Never hardcode colors in sub-themes — use `colors.xxx` or `AppColors.xxx`

---

## 6. Widgets — Lean and Theme-Driven

### Philosophy

Widgets are **thin wrappers** that delegate styling to the theme. They should:
- Accept only **semantic** parameters (text, onPressed, icon)
- **Not** accept radius, color, padding unless there's a real override need
- Use `const` constructors wherever possible

### Core Widgets

| Widget | Purpose | Key pattern |
|--------|---------|-------------|
| `PrimaryButton` | Main CTA | Delegates to `ElevatedButton` (theme) |
| `PrimaryOutlineButton` | Secondary action | Delegates to `OutlinedButton` |
| `CustomTextField` | Text input with label | Uses `InputDecorationTheme` |
| `ConfirmationDialog` | Confirm/cancel | `AppPadding.p16`, button pair |
| `ConfirmationSheet` | Bottom sheet confirm | Drag handle + button pair |
| `AppDialog` | Loading/Toast | Static methods wrapping SmartDialog |

### Dialog/Toast Usage

```dart
AppDialog.showLoading();   // Show loading overlay
AppDialog.hideLoading();   // Hide loading overlay
AppDialog.showToast('OK'); // Show toast message
```

**Never** call `SmartDialog` directly — always go through `AppDialog`.

---

## 7. Navigation

Use `AppNav` helper — never call `Get.to()` directly:

```dart
AppNav.push(const ProfileScreen());                // push
AppNav.pushReplacement(const HomeScreen());         // replace
AppNav.pushAndRemoveUntil(const LoginScreen());     // clear stack
```

**Pop:** `Get.back()` is fine.

---

## 8. Imports

Use the barrel file `imports.dart` for all common imports:

```dart
import 'package:<project>/imports.dart';
```

This exports: `material.dart`, `get`, `http`, `iconsax`, `shared_preferences`,
`flutter_screenutil`, core utils, design system, and core widgets.

**Only add to `imports.dart`** things used in >50% of files.

---

## 9. Naming Conventions

| Item | Convention | Example |
|------|-----------|---------|
| Files | `snake_case` | `splash_controller.dart` |
| Classes | `PascalCase` | `SplashController` |
| Variables | `camelCase` | `_isLoading` |
| Private fields | Underscore prefix | `_settingModel` |
| Constants | `camelCase` or `UPPER_SNAKE` | `baseUrl`, `SharedKeys.token` |
| Feature dirs | Singular noun | `splash/`, `theme/`, `language/` |
| Design tokens | Short prefix + value | `p16`, `r8`, `r16Shape` |
| Screen suffix | `Screen` | `ProfileScreen`, `HomeScreen` |

---

## 10. Code Style Rules

1. **Private constructor** on utility classes: `AppColors._()`, `AppPadding._()`, `AppRadius._()`, `AppNav._()`, `AppDialog._()`, `SharedKeys._()`.
2. **Explicit return types** on all public methods and getters.
3. **`super.key`** in constructors instead of `Key? key` parameter.
4. **Trailing commas** on parameter lists for better formatting.
5. **Single import** (`imports.dart`) unless the file is in `core/` itself.
6. **No `this.` prefix** except in constructors.
7. **`const` constructors** wherever possible.
8. **`.tr` suffix** on all user-facing strings for localization.
9. **`.sp` units** on all sizes for responsive scaling.
10. **No magic numbers** — use design tokens or named constants.

---

## 11. Checklist — Before Submitting Any Code

- [ ] Follows Clean Architecture layers (controller never touches apiClient)
- [ ] Uses `ApiResult` (never `Response?` or nullable returns)
- [ ] Pattern matches on `ApiResult` with `case Success(data: final x)`
- [ ] Uses design tokens (`AppPadding.p16`, `AppRadius.r16Shape`, `context.font16`)
- [ ] No hardcoded colors, sizes, or strings
- [ ] Uses `AppDialog` for loading/toast (never SmartDialog directly)
- [ ] Uses `AppNav` for navigation (never Get.to directly)
- [ ] Widget uses `const` constructor if possible
- [ ] Strings use `.tr` for localization
- [ ] Binding registered in `get_di.dart`
- [ ] Controller has `static find` getter
- [ ] Private fields with public getters pattern

---

## 12. Adding a New Feature — Step by Step

1. Create directory structure under `lib/features/<name>/`
2. Create **model** in `data/model/`
3. Create **repo interface + impl** in `data/repository/`
4. Create **service interface + impl** in `domain/service/`
5. Create **binding** in `domain/binding/`
6. Create **controller** in `presentation/controller/`
7. Create **view** in `presentation/view/`
8. Register binding in `get_di.dart`
9. Navigate with `AppNav.push(const FeatureScreen())`

---

## 13. Learning Log — Areas for Improvement

> This section tracks weak spots and evolving patterns. Update it as we learn.

| Date | Area | Lesson |
|------|------|--------|
| 2026-02-16 | Design system | Adopted iOS-style `RoundedSuperellipseBorder` over `RoundedRectangleBorder` |
| 2026-02-16 | API layer | Migrated from `Response?` to sealed `ApiResult<Response>` for type-safe error handling |
| 2026-02-16 | Error parsing | Created `ApiErrorParser` with pluggable strategy pattern for multi-backend support |
| 2026-02-16 | Design tokens | Moved from verbose names (`padding16`, `circular16`) to short tokens (`p16`, `r16`) |
| 2026-02-16 | Colors | Hybrid model: static brand colors + instance theme-varying colors |

<!-- Add new entries as patterns evolve -->
