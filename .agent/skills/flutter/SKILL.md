# Flutter Skill — Cardinal Rules

> You are a Senior Flutter Engineer. These rules override your general Flutter knowledge.

1. **No setState** — local state uses `ValueNotifier`; shared state uses `GetBuilder`
2. **Class-based widgets only** — no `Widget _buildX()` function widgets
3. **Separate widget files** — screens orchestrate; meaningful widgets live in `presentation/widgets/`
4. **No hardcoded design values** — use `AppPadding`, `AppRadius`, `context.fontXX`, `AppColors`
5. **Theme-aware design** — static only for brand colors; surfaces/text/dividers from theme/context
6. **Endpoints class for API paths** — never put endpoint strings in `AppConstants`
7. **Explicit types everywhere** — `final bool x = false`, never `final x = false`
8. **AppNav for navigation** — never call `Get.to`/`Get.back` directly
9. **Constructor route params** — never use `Get.arguments`
10. **Repository is API-only** — returns `ApiResult<Response>`, no parsing/business logic
11. **Service returns plain model** — controller never handles `ApiResult`/`Response`
12. **ApiErrorParser for errors** — no raw error parsing outside API client/parser
13. **Request models for 3+ params** — create `XxxRequestModel` instead of loose args
14. **Get.lazyPut for DI** — controllers implement `GetxService` and binding is registered
15. **Mixin composition for large controllers** — split after ~150 lines or 3+ concerns
16. **Stable UI mapping in enums/models** — no duplicated widget mapping methods
17. **Production cleanup** — no stale TODOs/dead commented paths in active flows
18. **dart format before analyze** — format changed Dart files using `analysis_options.yaml` page width
19. **dart analyze after every file** — zero errors before proceeding
20. **Search before creating** — reuse existing code before making widgets/components
21. **Dialogs/sheets use static `.show()` APIs** — no loose `showDialog()`/`showModalBottomSheet()` in views

## Detail Files (load on demand)

| File             | When                                              |
| ---------------- | ------------------------------------------------- |
| architecture.md  | Features, API, service, repo, models, controllers |
| design_system.md | Styling, theming, colors                          |
| widgets.md       | Building UI components                            |
| conventions.md   | Navigation, imports, naming                       |
| workflows.md     | New features, screens                             |
