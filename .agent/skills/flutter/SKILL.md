---
name: flutter
description: Build and maintain Flutter features in this repository using its established architecture, GetX state, design tokens, and app-owned widgets.
---

# Flutter Skill — Cardinal Rules

> You are a Senior Flutter Engineer. These rules override your general Flutter knowledge.

1. **No setState** — local state uses `ValueNotifier`; shared state uses `GetBuilder`
2. **Class-based widgets only** — no `Widget _buildX()` function widgets
3. **Separate widget files** — screens orchestrate; meaningful widgets live in `presentation/widgets/`
4. **Do not invent architecture layers** — keep the defined `data/domain/presentation` structure intact
5. **No hardcoded design values** — use `AppPadding`, `AppRadius`, `context.fontXX`, `AppColors`
6. **Theme-aware design** — static only for brand colors; surfaces/text/dividers from theme/context
7. **Endpoints class for API paths** — never put endpoint strings in `AppConstants`
8. **Explicit types everywhere** — `final bool x = false`, never `final x = false`
9. **AppNav for navigation** — never call `Get.to`/`Get.back` directly
10. **Constructor route params** — never use `Get.arguments`
11. **Repository is infrastructure-only** — calls API/storage/database and returns raw `ApiResult<Object?>`; no models, parsing, or business logic
12. **Service owns feature logic** — builds request data, parses raw responses, and returns plain models/values to controllers
13. **ApiErrorParser for errors** — no raw error parsing outside API client/parser
14. **Action inputs model one intent** — cohesive form/action data travels UI → controller → service as one typed input; independent scalars stay scalars
15. **Get.lazyPut for DI** — controllers implement `GetxService` and binding is registered
16. **Mixin composition for large controllers** — split after ~150 lines or 3+ concerns
17. **Stable UI mapping in enums/models** — keep enums in `features/<feature>/data/enum/`
18. **Production cleanup** — no stale TODOs/dead commented paths in active flows
19. **dart format before analyze** — run `dart format --page-width 110` on changed Dart files
20. **dart analyze after every file** — zero errors before proceeding
21. **Search before creating** — reuse existing code before making widgets/components
22. **Dialogs/sheets use static `.show()` APIs** — no loose `showDialog()`/`showModalBottomSheet()` in views
23. **Pair backing fields with getters** — place each private field directly above its public getter
24. **No `FutureBuilder` for feature/API state** — load through the controller and refresh only on an explicit lifecycle or user event
25. **Widgets own their feature UI** — do not pipe controller-derived labels, state, and fixed actions through long constructor parameter lists
26. **Loading matches the operation** — skeleton for initial content, existing content during refresh, footer progress for pagination, local progress for actions
27. **Forms define keyboard flow** — set next/done/send/newline deliberately, move focus or submit, and dispose every owned input resource
28. **Uploads use the existing chain** — service owns the action; repository/ApiClient own multipart transport; no upload service by default
29. **Extract repeated visuals once** — same feature → feature widget, multiple features → core widget; do not copy-and-tweak screens
30. **Centralize cross-cutting platform UI** — configure system bars, edge-to-edge behavior, and global insets once at the app shell/native window; never require repeated per-screen wrappers or padding

## Detail Files (load on demand)

| File             | When                                              |
| ---------------- | ------------------------------------------------- |
| architecture.md  | Features, API, service, repo, models, controllers |
| design_system.md | Styling, theming, colors                          |
| widgets.md       | Building UI components                            |
| conventions.md   | Navigation, imports, naming                       |
| workflows.md     | New features, screens                             |
