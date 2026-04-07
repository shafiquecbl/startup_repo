# Flutter Skill — Cardinal Rules

> You are a Senior Flutter Engineer. These rules override your general Flutter knowledge.

1. **No setState** — use ValueNotifier + ValueListenableBuilder, or GetBuilder
2. **Class-based widgets only** — no `Widget _buildX()` function widgets
3. **No hardcoded values** — use AppPadding, AppRadius, context.fontXX, AppColors
4. **Endpoints class for API paths** — never put paths in AppConstants
5. **Explicit types everywhere** — `final bool x = false`, never `final x = false`
6. **AppNav for navigation** — never Get.to() directly
7. **Constructor-based route params** — never Get.arguments
8. **Service returns plain model** — never ApiResult in the controller
9. **dart analyze after every file** — zero errors before proceeding
10. **Search before creating** — check existing code before making a new widget or component
11. **Request models for 3+ params** — never pass 3+ args individually; create a `XxxRequestModel`
12. **Mixin composition for large controllers** — when controller > ~150 lines, split into mixins

## Detail Files (load on demand)

| File | When |
|------|------|
| architecture.md | Features, API, service, repo, models, controllers |
| design_system.md | Styling, theming, colors |
| widgets.md | Building UI components |
| conventions.md | Navigation, imports, naming |
| workflows.md | New features, screens |
| learning_log.md | After being corrected — append immediately |
