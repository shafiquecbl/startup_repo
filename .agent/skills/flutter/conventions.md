# Conventions — Quick Reference

> Project-specific rules only. General Dart/Flutter rules are assumed known.

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
- **`dart analyze`** — run after every file change, zero errors
- **`.tr`** — all user-facing strings must be translated
- **`const`** — use wherever possible

---

## Pre-Submit Checklist

- [ ] `dart analyze` — zero errors
- [ ] No `setState` (use `ValueNotifier` or `GetBuilder`)
- [ ] No hardcoded colors/sizes (use tokens)
- [ ] No `Get.to()` / `Get.arguments` (use `AppNav` + constructors)
- [ ] No `Get.put()` (use `Get.lazyPut()`)
- [ ] All strings use `.tr`
- [ ] All vars/params/returns have explicit types
- [ ] Endpoints use `Endpoints.xxx` (not `AppConstants`)
- [ ] Class-based widgets only (no `Widget _buildX()`)
- [ ] `dispose()` called for all controllers, focus nodes, notifiers
