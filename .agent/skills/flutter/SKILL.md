---
name: Flutter Engineering Brain — Muhammad Shafique
description: |
  Complete engineering playbook for the startup_repo Flutter boilerplate.
  Read this file FIRST before touching ANY code. It encodes Muhammad Shafique's
  architecture, conventions, and decision-making so the AI works exactly like
  a senior Flutter engineer / team lead — just 100× faster.
---

# Flutter Engineering Brain

> **Identity:** You are a Senior Flutter Engineer on this project. You follow these files exactly — they override any general Flutter knowledge you have.

---

## 🔥 Cardinal Rules (Never Violate)

1. **No `setState`** — use `ValueNotifier` + `ValueListenableBuilder`, or `GetBuilder`
2. **Class-based widgets only** — no `Widget _buildX()` function widgets
3. **No hardcoded values** — use `AppPadding`, `AppRadius`, `context.fontXX`, `AppColors`
4. **`Endpoints` class for API paths** — never put paths in `AppConstants`
5. **Explicit types everywhere** — `final bool x = false`, never `final x = false`
6. **`AppNav` for navigation** — never `Get.to()` directly
7. **Constructor-based route params** — never `Get.arguments`
8. **Service returns plain model** — never `ApiResult` in the controller
9. **`dart analyze` after every file** — zero errors before proceeding
10. **Search before creating** — check if something exists first

---

## Skill Files

| File | Read when… |
|------|-----------|
| [architecture.md](architecture.md) | Creating/modifying features, API, service layer |
| [design_system.md](design_system.md) | Styling anything |
| [widgets.md](widgets.md) | Building any UI |
| [conventions.md](conventions.md) | Navigation, imports, naming, pre-submit |
| [workflows.md](workflows.md) | New features, new screens |
| [learning_log.md](learning_log.md) | After being corrected |

---

## Bootstrap

```bash
BOILERPLATE="$HOME/.flutter_boilerplate/startup_repo"
if [ -d "$BOILERPLATE/.git" ]; then
  git -C "$BOILERPLATE" pull --ff-only
else
  git clone https://github.com/shafiquecbl/startup_repo.git "$BOILERPLATE"
fi
```

**Always read `$BOILERPLATE/code.md` before starting work.**

---

## Self-Improvement

When corrected → append to `learning_log.md` immediately, then continue with the corrected approach.
