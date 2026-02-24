# Conventions — Navigation, Imports, Naming, Code Style

> **When to read:** Quick reference for naming, imports, navigation patterns,
> and the pre-submit checklist.

---

## Navigation — Constructor-Based, Type-Safe

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

We don't target web. If web support is ever needed, add `go_router` at that point.

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

## Imports

Use the barrel file `imports.dart` for all common imports:

```dart
import 'package:<project>/imports.dart';
```

This exports: `material.dart`, `get`, `http`, `iconsax`, `shared_preferences`,
`flutter_screenutil`, core utils, design system, and core widgets.

**Only add to `imports.dart`** things used in >50% of files.

---

## Naming Conventions

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

## Code Style Rules

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

## Checklist — Before Submitting Any Code

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
