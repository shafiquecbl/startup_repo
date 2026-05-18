# Conventions — Quick Reference

> Project-specific rules only. General Dart/Flutter rules are assumed known.

---

## Quick Rules

1. **Use `AppNav` for navigation** — no direct `Get.to()`, `Get.back()`, or route shortcuts in views.
2. **Pass route data through constructors** — never use `Get.arguments`.
3. **Core imports use barrel file** — use `package:startup_repo/imports.dart` for shared core exports.
4. **Feature-local imports stay local** — models/repos/own widgets can use relative imports.
5. **Explicit types everywhere** — variables, params, fields, and return types are written out.
6. **Use `Get.lazyPut()` for DI** — never `Get.put()` for feature registration.
7. **Run `dart analyze` after each file** — fix errors before moving to the next file.
8. **User-facing strings use `.tr`** — no raw visible English in widgets.
9. **Use `const` wherever possible** — constructors, widgets, lists, and values.
10. **Dispose owned resources** — controllers, focus nodes, notifiers, streams, timers.
11. **Pair backing fields with getters** — declare each private field directly above its getter.
12. **No dead paths** — remove stale TODOs and commented production branches.

---

## Navigation — `AppNav`

```dart
// ✅ CORRECT
AppNav.to(const ProfileScreen(userId: user.id));  // pass data via constructor
AppNav.back();
AppNav.offAll(const HomeScreen());

// ❌ WRONG
Get.to(() => ProfileScreen(), arguments: user.id); // no Get.arguments ever
Get.back();
```

---

## Imports — Barrel File

```dart
// ✅ CORRECT — single import covers all core
import 'package:startup_repo/imports.dart';

// ❌ WRONG — individual imports for core files
import 'package:startup_repo/core/utils/app_constants.dart';
import 'package:startup_repo/core/theme/...';
```

Feature-local files (models, repos, own widgets) still use relative imports.

---

## Code Style Rules

- **Explicit types** — `final bool x = false`, never `final x = false`
- **Return types** — every method must have explicit return type
- **`Get.lazyPut`** — never `Get.put()`
- **`dart format --page-width 110`** — run before analyze on changed Dart files
- **`dart analyze`** — run after every file change, zero errors
- **`.tr`** — all user-facing strings must be translated
- **`const`** — use wherever possible
- **Backing field + getter pairs** — keep each private field immediately above its getter
- **No dead paths** — delete stale TODOs and commented-out production code

## Pre-Submit Checklist

- [ ] `dart analyze` — zero errors
- [ ] `dart format --page-width 110` ran on changed Dart files
- [ ] No `setState` (use `ValueNotifier` or `GetBuilder`)
- [ ] No hardcoded colors/sizes (use tokens)
- [ ] No `Get.to()` / `Get.arguments` (use `AppNav` + constructors)
- [ ] No `Get.put()` (use `Get.lazyPut()`)
- [ ] All strings use `.tr`
- [ ] All vars/params/returns have explicit types
- [ ] Private backing fields are paired directly with getters
- [ ] Endpoints use `Endpoints.xxx` (not `AppConstants`)
- [ ] Class-based widgets only (no `Widget _buildX()`)
- [ ] `dispose()` called for all controllers, focus nodes, notifiers
- [ ] No TODO/dead commented code in active production paths
- [ ] Controller extends `GetxController implements GetxService`
- [ ] Feature binding exists **and** is registered in `core/helper/get_di.dart`
- [ ] Extracted widget classes live in separate widget files
