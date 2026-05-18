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
11. **Repository is API-only** — returns `ApiResult<Response>`, no parsing/business logic
12. **Service returns plain model** — controller never handles `ApiResult`/`Response`
13. **ApiErrorParser for errors** — no raw error parsing outside API client/parser
14. **Request models for 3+ params** — create `XxxRequestModel` instead of loose args
15. **Get.lazyPut for DI** — controllers implement `GetxService` and binding is registered
16. **Mixin composition for large controllers** — split after ~150 lines or 3+ concerns
17. **Stable UI mapping in enums/models** — keep enums in `features/<feature>/data/enum/`
18. **Production cleanup** — no stale TODOs/dead commented paths in active flows
19. **dart format before analyze** — format changed Dart files using `analysis_options.yaml` page width
20. **dart analyze after every file** — zero errors before proceeding
21. **Search before creating** — reuse existing code before making widgets/components
22. **Dialogs/sheets use static `.show()` APIs** — no loose `showDialog()`/`showModalBottomSheet()` in views
23. **Pair backing fields with getters** — place each private field directly above its public getter

## Detail Files (load on demand)

| File             | When                                              |
| ---------------- | ------------------------------------------------- |
| architecture.md  | Features, API, service, repo, models, controllers |
| design_system.md | Styling, theming, colors                          |
| widgets.md       | Building UI components                            |
| conventions.md   | Navigation, imports, naming                       |
| workflows.md     | New features, screens                             |
