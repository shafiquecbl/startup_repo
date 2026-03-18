# Design System — Tokens Reference

> Read before styling anything. Use tokens — never hardcode values.

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
