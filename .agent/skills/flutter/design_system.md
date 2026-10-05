# Design System — Tokens Reference

> Read before styling anything. Use tokens — never hardcode values.

---

## Quick Rules

1. **No hardcoded design values** — use app tokens for spacing, radius, typography, and colors.
2. **Use short token names** — `p16`, `r16`, `font16`; no verbose duplicates like `padding16`.
3. **Spacing uses `AppPadding` or `.sp`** — no raw `EdgeInsets.all(16)` or `SizedBox(height: 16)`.
4. **Radii use `AppRadius`** — all shaped corners use `RoundedSuperellipseBorder`.
5. **Brand colors are static** — `AppColors.primary`, `secondary`, `error`.
6. **Theme-varying colors come from context/theme** — background, surface, card, text, subtext, divider.
7. **Typography uses context extensions** — `context.font10` through `context.font32`.
8. **Use `copyWith` for variants** — change weight/color on an existing text style.
9. **Snap one-off design values** — use the matching approved token when it exists; otherwise choose the nearest one.
10. **Add new tokens only for repeated need** — never for a single screen.
11. **Keep generated design drafts out of the project** — save only the approved final asset; after approval, remove obsolete project variants and keep one canonical filename.
12. **Keep brand surfaces exact** — launcher, native splash, Flutter splash, and in-app primary actions must resolve to one brand-color source of truth. Give Android adaptive and Android 12 marks their own safe-zone canvases, regenerate platform outputs, and verify color plus visible bounds instead of reusing one asset everywhere.

---

## AppPadding

| Token | Value | Use |
|-------|-------|-----|
| `AppPadding.p4` | 4sp | Tight gaps |
| `AppPadding.p8` | 8sp | Small gaps |
| `AppPadding.p12` | 12sp | Medium gaps |
| `AppPadding.p16` | 16sp | Standard padding |
| `AppPadding.p20` | 20sp | Large padding |
| `AppPadding.p24` | 24sp | Section spacing |
| `AppPadding.screen` | 16sp H | Screen edge padding |

Use short token names: `p16`, `r16`, `font16`.
Do not create verbose duplicates like `padding16`, `circular16`, or `bodyText16`.

---

## AppRadius

| Token | Value | Use |
|-------|-------|-----|
| `AppRadius.r8` | 8sp | Chips, tags |
| `AppRadius.r12` | 12sp | Cards (small) |
| `AppRadius.r16` | 16sp | Cards, inputs, buttons |
| `AppRadius.r24` | 24sp | Sheets, avatars |
| `AppRadius.r100` | 100sp | Pills, dots |

All radii use **`RoundedSuperellipseBorder`** (iOS squircle), not `RoundedRectangleBorder`.

```dart
// ❌ WRONG
BorderRadius.circular(16)

// ✅ CORRECT
AppRadius.r16  // returns RoundedSuperellipseBorder
```

---

## AppColors

```dart
// Static brand colors (same in all themes)
AppColors.primary    // brand primary
AppColors.secondary  // brand secondary
AppColors.error      // red

// Instance colors (change with theme — use via AppColors.of(context).xxx)
AppColors.of(context).background
AppColors.of(context).surface
AppColors.of(context).card
AppColors.of(context).text
AppColors.of(context).subtext
AppColors.of(context).divider
```

Use static colors only for fixed brand/system colors.
Use `AppColors.of(context)` for theme-varying surfaces, text, subtext, and dividers.

---

## Typography

```dart
// Font extensions on BuildContext
context.font10  context.font12  context.font14
context.font16  context.font18  context.font20
context.font24  context.font28  context.font32

// Use copyWith for weight/color variations
context.font16.copyWith(fontWeight: FontWeight.w700, color: Colors.white)
```

---

## Spacing

```dart
// Use SizedBox with .sp suffix — never hardcoded pixels
SizedBox(height: 16.sp)
SizedBox(width: 8.sp)

// ❌ WRONG
SizedBox(height: 16)
Padding(padding: EdgeInsets.all(16))

// ✅ CORRECT
SizedBox(height: 16.sp)
Padding(padding: AppPadding.p16)
```
