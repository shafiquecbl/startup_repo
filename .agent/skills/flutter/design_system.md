# Design System & Theme

> **When to read:** Before styling any widget, creating theme sub-themes,
> or choosing colors/sizes/radii.

---

## Colors (`AppColors`)

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

---

## Padding (`AppPadding`)

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

---

## Radius (`AppRadius`)

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

---

## Typography (`AppText`)

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

## Theme System

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
