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
- Add `project_type: startup_repo` after the `description` field (identifies this project)
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

## 6. Widgets — Theme-First, Class-Based, Lean

### ⚠️ Rule 1: Class-Based Only — No Exceptions

**NEVER use function/method-based widgets.** Every reusable piece of UI MUST be a
`StatelessWidget` or `StatefulWidget` class. This is non-negotiable.

```dart
// ❌ WRONG — Function widget (anti-pattern)
Widget _buildHeader() {
  return Container(
    padding: AppPadding.p16,
    child: Text('Header', style: context.font16),
  );
}

// ✅ CORRECT — Class-based widget
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.p16,
      child: Text('Header', style: context.font16),
    );
  }
}
```

**Why:** Flutter diffs by widget type (classes get smart diffing, functions don't),
`const` prevents rebuilds, classes show in DevTools.

### ⚠️ Rule 2: Theme-First — Use Built-in Widgets

**Decision tree before creating any widget:**

```
Need a styled widget?
├─ Can ThemeData sub-theme achieve the design?
│   └─ YES → Use the built-in widget directly. DONE.
├─ Need the built-in + 1-2 fixed convenience params (e.g. loading)?
│   └─ YES → Create a thin wrapper (like PrimaryButton).
└─ Truly novel UI that no built-in covers?
    └─ YES → Create a custom widget (RARE).
```

**Built-in widgets you must NEVER recreate — theme them instead:**

| Built-in Widget | Theme Key | Common Anti-Pattern |
|-----------------|-----------|---------------------|
| `ElevatedButton` | `ElevatedButtonThemeData` | Custom button with hardcoded colors |
| `OutlinedButton` | `OutlinedButtonThemeData` | Custom outline button with borders |
| `TextButton` | `TextButtonThemeData` | Custom text-only button |
| `IconButton` | `IconButtonThemeData` | Custom icon tap target |
| `TextFormField` | `InputDecorationTheme` | Styling borders/colors per-instance |
| `showDialog` | `DialogTheme` | Building custom dialog containers |
| `showModalBottomSheet` | `BottomSheetThemeData` | Building custom sheet widgets |
| `AppBar` | `AppBarTheme` | Custom header widgets |
| `Card` | `CardTheme` | Custom container with shadows |
| `ListTile` | `ListTileThemeData` | Custom row layouts |
| `Divider` | `DividerThemeData` | `Container(height: 1, color: ...)` |
| `DropdownMenu` | `DropdownMenuThemeData` | Custom dropdown widgets |
| `Icon` | `IconThemeData` | Setting size/color per-instance |
| `Chip` | `ChipThemeData` | Custom tag/badge widgets |
| `TabBar` | `TabBarTheme` | Custom tab implementations |
| `NavigationBar` | `NavigationBarThemeData` | Custom bottom navs |
| `SnackBar` | `SnackBarThemeData` | Custom toast containers |
| `Switch` | `SwitchThemeData` | Custom toggle widgets |
| `Checkbox` | `CheckboxThemeData` | Custom checkmark widgets |
| `Radio` | `RadioThemeData` | Custom radio buttons |
| `FloatingActionButton` | `FloatingActionButtonThemeData` | Custom FABs |
| `Slider` | `SliderThemeData` | Custom range selectors |
| `ProgressIndicator` | `ProgressIndicatorThemeData` | Custom loaders |

### Concrete Examples — Anti-Pattern vs. Correct

#### TextFormField (the #1 offender)

```dart
// ❌ WRONG — Manually styling at every usage site
TextFormField(
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.blue, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.red),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    hintStyle: TextStyle(color: Colors.grey),
  ),
)

// ✅ CORRECT — Define InputDecorationTheme ONCE in theme, use bare widget
// In core/theme/src/input_decoration_theme.dart:
InputDecorationTheme inputDecorationTheme(AppColors colors) => InputDecorationTheme(
  filled: true,
  fillColor: colors.card,
  border: OutlineInputBorder(borderRadius: AppRadius.r16, borderSide: BorderSide.none),
  focusedBorder: OutlineInputBorder(borderRadius: AppRadius.r16, borderSide: BorderSide(color: colors.primary)),
  contentPadding: AppPadding.p16,
);

// Then anywhere in the app — just use it clean:
TextFormField(hintText: 'enter_email'.tr)
// or use our convenience wrapper when you need a label:
CustomTextField(labelText: 'email', hintText: 'enter_email')
```

#### ElevatedButton

```dart
// ❌ WRONG — Hardcoding style at call site
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF6C63FF),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    padding: EdgeInsets.symmetric(vertical: 14),
  ),
  onPressed: () {},
  child: Text('Submit'),
)

// ✅ CORRECT — Theme handles everything, call site is clean
// In core/theme/src/elevated_button_theme.dart:
ElevatedButtonThemeData elevatedButtonTheme(AppColors colors) => ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: colors.primary,
    foregroundColor: Colors.white,
    shape: AppRadius.r16Shape,
    padding: AppPadding.p16,
  ),
);

// Then in any screen — zero styling:
ElevatedButton(onPressed: () {}, child: Text('Submit'.tr))
// or use our wrapper for loading/icon:
PrimaryButton(text: 'Submit', isLoading: controller.isLoading, onPressed: () {})
```

#### Card

```dart
// ❌ WRONG — Custom Container with manual shadow
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
  ),
  child: content,
)

// ✅ CORRECT — Use Card widget with CardTheme
// In core/theme/src/card_theme.dart (if needed):
CardThemeData cardTheme(AppColors colors) => CardThemeData(
  color: colors.card,
  shape: AppRadius.r16Shape,
  elevation: 0,
);

// Then:
Card(child: Padding(padding: AppPadding.p16, child: content))
```

#### Switch / Checkbox / Radio

```dart
// ❌ WRONG — Styling per instance
Switch(
  value: isEnabled,
  onChanged: onChanged,
  activeColor: Color(0xFF6C63FF),
  activeTrackColor: Color(0xFF6C63FF).withOpacity(0.3),
  inactiveThumbColor: Colors.grey,
  inactiveTrackColor: Colors.grey[300],
)

// ✅ CORRECT — Theme it once, use bare widget everywhere
// In theme:
SwitchThemeData switchTheme(AppColors colors) => SwitchThemeData(
  thumbColor: WidgetStatePropertyAll(colors.primary),
  trackColor: WidgetStateProperty.resolveWith((states) =>
    states.contains(WidgetState.selected) ? colors.primary.withOpacity(0.3) : colors.divider,
  ),
);

// Then:
Switch(value: isEnabled, onChanged: onChanged)
```

#### Divider

```dart
// ❌ WRONG — Manual separator
Container(height: 1, color: Colors.grey[300], margin: EdgeInsets.symmetric(vertical: 8))

// ✅ CORRECT — Built-in Divider with DividerTheme
const Divider()
```

> **Key takeaway:** If you find yourself writing `style:`, `decoration:`, or
> `color:` directly on a built-in widget, STOP. That styling belongs in the
> ThemeData sub-theme, not at the call site. The ONLY exception is a genuine
> one-off override (rare).

### Rule 3: Static `.show()` for Dialogs/Sheets

All dialogs, sheets, and overlays use a **static method on the class**:

```dart
// ❌ WRONG — loose function
showConfirmationDialog(title: '...', onAccept: () {});

// ✅ CORRECT — static method (discoverable: type ClassName. → IDE shows all)
ConfirmationDialog.show(title: '...', onAccept: () {});
ConfirmationSheet.show(title: '...', onAccept: () {});
AppDialog.showLoading();
AppDialog.showToast('OK');
```

### Our Wrapper Widgets (convenience only)

| Widget | Wraps | Added Value |
|--------|-------|-------------|
| `PrimaryButton` | `ElevatedButton` | `isLoading`, `icon` convenience |
| `PrimaryOutlineButton` | `OutlinedButton` | `isLoading`, `icon` convenience |
| `CustomTextField` | `TextFormField` | Label above field, icon wiring |
| `ConfirmationDialog` | `showDialog` | Static `.show()`, pre-built layout |
| `ConfirmationSheet` | `showModalBottomSheet` | Static `.show()`, pre-built layout |
| `AppDialog` | `SmartDialog` | Unified loading/toast API |
| `AppImage` | `CachedNetworkImage` / `Image.asset` | Unified network+asset, shimmer, error |
| `CustomTextField` | `TextFormField` | Label, icon wiring, focusNode |

### State Widgets (use these everywhere)

```dart
// Loading — centered spinner
const LoadingWidget()

// Empty state — icon + title + optional subtitle + optional action
EmptyStateWidget(
  icon: Iconsax.box,
  title: 'no_items',
  subtitle: 'no_items_subtitle',
  actionText: 'add_item',
  onAction: () {},
)

// Error state — message + optional retry
ErrorStateWidget(
  message: 'something_went_wrong',
  onRetry: () => controller.loadData(),
)
```

### Skeleton Loading (use for shimmer placeholders)

```dart
const SkeletonBox(height: 120)              // rectangular skeleton
const SkeletonCircle(size: 48)              // circular (avatars)
const SkeletonLine(height: 14)              // text line
const SkeletonLine(height: 12, width: 150)  // shorter text line
const SkeletonListTile()                    // leading circle + 2 lines
```

### Image Handling

Use `AppImage` for all images — handles network (shimmer + error + caching)
and asset images through a single widget:

```dart
// Network image with border radius
AppImage(url: user.avatar, width: 48.sp, height: 48.sp, borderRadius: AppRadius.r24)

// Asset image
AppImage(asset: Images.logo, width: 120.sp)

// Card image
AppImage(url: post.imageUrl, height: 200.sp, borderRadius: AppRadius.r16)

// Basic network (fills parent)
AppImage(url: imageUrl)
```

**Rules:**
- **Never** use `Image.network()` directly — no loading/error states
- **Always** provide `width`/`height` or constrain with parent
- Use `borderRadius` param instead of wrapping in `ClipRRect`

### Form Validation Pattern

Validate on submit + use **FocusNodes** for field switching:

```dart
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailCtrl,
            focusNode: _emailFocus,
            labelText: 'email',
            hintText: 'enter_email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => _passFocus.requestFocus(),
            validator: (v) => v == null || v.isEmpty ? 'email_required'.tr : null,
          ),
          CustomTextField(
            controller: _passCtrl,
            focusNode: _passFocus,
            labelText: 'password',
            hintText: 'enter_password',
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            validator: (v) => v != null && v.length < 6 ? 'password_min_6'.tr : null,
          ),
          SizedBox(height: 24.sp),
          GetBuilder<AuthController>(builder: (con) {
            return PrimaryButton(
              text: 'login',
              isLoading: con.isLoading,
              onPressed: _submit,
            );
          }),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      AuthController.find.login(_emailCtrl.text, _passCtrl.text);
    }
  }
}
```

**Rules:**
- Validate on submit, not on every keystroke
- Use `FocusNode` + `onSubmitted` + `requestFocus()` for field switching
- Use `TextInputAction.next` on intermediate fields, `.done` on last field
- Dispose all controllers and focus nodes in `dispose()`
- Use `.tr` for all validation messages
- Use `isLoading` on the submit button

---

## 7. Navigation — Constructor-Based, Type-Safe

### Philosophy

We use **constructor-based navigation** (not named routes). This is a deliberate
architectural choice:

| | Constructor-based (ours) | Named routes |
|---|---|---|
| **Type safety** | ✅ Compiler catches missing params | ❌ Runtime errors |
| **Refactoring** | ✅ Rename param → all callers update | ❌ String-based, breaks silently |
| **Discoverability** | ✅ IDE shows required params | ❌ Must remember argument keys |
| **const support** | ✅ `const Screen()` works | ❌ Not possible |
| **Web/deep links** | ❌ No URL support | ✅ `/profile/123` |

We don't target web (Flutter's web performance isn't production-ready for us).
If web support is ever needed, add `go_router` at that point — don't pollute
the mobile architecture preemptively.

### Usage

Use `AppNav` helper — never call `Get.to()` directly:

```dart
// Pass parameters directly via constructor — type-safe, discoverable
AppNav.push(ProfileScreen(userId: '123'));          // push
AppNav.pushReplacement(const HomeScreen());         // replace
AppNav.pushAndRemoveUntil(const LoginScreen());     // clear stack
```

**Pop:** `Get.back()` is fine.

### Rules

- **Always** use `AppNav` for forward navigation
- **Always** pass data via constructor parameters (never via Get.arguments)
- **Always** use `const` when the screen has no parameters
- **Never** create a route table or use named routes (unless web is required)

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
11. **Class-based widgets only** — never use function/method widgets (`Widget _buildX()`).
12. **Constructor-based navigation** — pass data via screen constructors, not named routes.
13. **Theme-first widgets** — use built-in Flutter widgets with ThemeData, don't recreate them.
14. **Static `.show()` pattern** — dialogs/sheets use `ClassName.show()`, not loose functions.

---

## 11. Checklist — Before Submitting Any Code

- [ ] Follows Clean Architecture layers (controller never touches apiClient)
- [ ] Uses `ApiResult` (never `Response?` or nullable returns)
- [ ] Pattern matches on `ApiResult` with `case Success(data: final x)`
- [ ] Uses design tokens (`AppPadding.p16`, `AppRadius.r16Shape`, `context.font16`)
- [ ] No hardcoded colors, sizes, or strings
- [ ] Uses `AppDialog` for loading/toast (never SmartDialog directly)
- [ ] Uses `AppNav` for navigation (never Get.to directly)
- [ ] All widgets are class-based (no `Widget _buildX()` methods)
- [ ] Widget uses `const` constructor if possible
- [ ] Screen params passed via constructor (never Get.arguments)
- [ ] Strings use `.tr` for localization
- [ ] Binding registered in `get_di.dart`
- [ ] Controller has `static find` getter
- [ ] Private fields with public getters pattern
- [ ] Uses built-in widgets with theme (not custom recreations)
- [ ] Dialogs/sheets use static `.show()` pattern
- [ ] Loading/empty/error states use `LoadingWidget`, `EmptyStateWidget`, `ErrorStateWidget`

---

## 12. Design-First Workflow — Analyze Before You Code

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

## 13. Adding a New Feature — Step by Step

1. **Run Design-First Workflow** (Section 12) if this is a multi-screen feature
2. Create directory structure under `lib/features/<name>/`
3. Create **shared widgets** first (identified in Phase 2) → `core/widgets/`
4. Create **model** in `data/model/`
5. Create **repo interface + impl** in `data/repository/`
6. Create **service interface + impl** in `domain/service/`
7. Create **binding** in `domain/binding/`
8. Create **controller** in `presentation/controller/`
9. Create **view** in `presentation/view/`
10. Register binding in `get_di.dart`
11. Navigate with `AppNav.push(const FeatureScreen())`

---

## 14. Learning Log — Areas for Improvement

> This section tracks weak spots and evolving patterns. Update it as we learn.

| Date | Area | Lesson |
|------|------|--------|
| 2026-02-16 | Design system | Adopted iOS-style `RoundedSuperellipseBorder` over `RoundedRectangleBorder` |
| 2026-02-16 | API layer | Migrated from `Response?` to sealed `ApiResult<Response>` for type-safe error handling |
| 2026-02-16 | Error parsing | Created `ApiErrorParser` with pluggable strategy pattern for multi-backend support |
| 2026-02-16 | Design tokens | Moved from verbose names (`padding16`, `circular16`) to short tokens (`p16`, `r16`) |
| 2026-02-16 | Colors | Hybrid model: static brand colors + instance theme-varying colors |
| 2026-02-17 | Widgets | Enforced class-based widgets only — banned `Widget _buildX()` function widgets |
| 2026-02-17 | Navigation | Documented constructor-based navigation philosophy over named routes |
| 2026-02-17 | Workflow | Added Design-First Workflow — audit design before coding, extract shared widgets first |
| 2026-02-17 | Theme-first | Enforce built-in widgets + ThemeData over custom recreations. 23 widgets mapped to theme keys |
| 2026-02-17 | Dialogs | Refactored to static `.show()` pattern — `ConfirmationDialog.show()`, `ConfirmationSheet.show()` |
| 2026-02-17 | Buttons | Added `isLoading` to `PrimaryButton` / `PrimaryOutlineButton` |
| 2026-02-17 | State widgets | Created `EmptyStateWidget`, `ErrorStateWidget`, skeleton loading widgets |

<!-- Add new entries as patterns evolve -->
