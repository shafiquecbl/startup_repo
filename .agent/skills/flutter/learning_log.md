# Learning Log — Self-Improving Skills

> **Purpose:** This file tracks corrections, discoveries, and evolving patterns.
> It is the skill system's memory — how it gets better session after session.

---

## How Self-Improvement Works

### When You Get Corrected

When the developer corrects your approach during a work session:

1. **Understand** what you did wrong and what the correct approach is
2. **Check** if this correction is already documented in any skill file
3. **If NOT documented** → append a new row to the log table below
4. **Format:** `| YYYY-MM-DD | area | lesson learned |`

### Promoting Entries to Skills

Periodically (or when the developer asks), entries should be promoted:

1. Review the learning log for patterns (multiple entries in same area)
2. Write the lesson as a permanent rule in the appropriate skill file
3. Mark the log entry as promoted with ✅ prefix in the lesson column
4. This keeps skill files up-to-date with real-world corrections

### Example Flow

```
Developer: "No, we don't use Get.put() — always Get.lazyPut()"
→ AI appends: | 2026-02-24 | Architecture | Always use Get.lazyPut(), never Get.put() |
→ Next session: AI reads this and avoids the mistake
→ Later: Entry is promoted to architecture.md as a permanent rule
```

---

## Log

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
| 2026-02-17 | Feature workflow | Added Dummy-Data-First workflow — build complete features with dummy data, generate API spec docs for backend devs |
| 2026-02-17 | Feature organization | Split monolithic `food/` into independent `food_home/`, `food_detail/`, `cart/` features with cross-feature imports |

<!-- Add new entries below this line -->
