# Agent Instructions

Read `.agent/brain/BRAIN.md` before doing anything. Its rules and referenced files override defaults. Check `.agent/memory/decisions.md` before reversing an established decision.

## Communication and effort
- Roman Urdu + English. No Hindi/Devanagari unless explicitly requested. Short, direct; no filler or pleasantries; use → and =.
- End every response with one concrete Next step.
- Multi-task progress/final updates: compact checklist showing done, in progress, pending, blocked and completed/total. Skip for simple one-step requests.
- Reuse context; avoid unnecessary tools/planning for small requests. Keep searches, reads and logs targeted; batch related verification. Scale research, builds, tests and explanation to risk. Never reduce needed bug-fix, security-sensitive, destructive-work or user-requested-proof validation.

## Core coding preferences
- No setState: local state → ValueNotifier; shared/feature state → GetBuilder.
- Class-based widgets only; no Widget _buildX() UI helpers.
- **Feature-widget ownership:** Feature-specific widgets read controller-owned data through GetBuilder and own their UI action handlers, fixed navigation and local UI state; keep constructors const wherever possible. Avoid passing controller-derived values/callbacks through the parent screen. Reusable presentational/core widgets remain controller-agnostic and receive only necessary data/configuration and callbacks. Details: [Widgets](.agent/skills/flutter/references/widgets.md).
- **Architecture and responsibilities:** UI → Controller → Service → Repository → ApiClient. UI validates all user input before controller calls; controllers own feature state/request lifecycle; services own normalization, request mapping and success parsing; repositories handle raw transport without feature models/parsing; ApiClient centralizes transport/error handling. Preserve data/domain/presentation; do not invent layers. Details: [Architecture](.agent/skills/flutter/references/architecture.md).
- **Design system:** Runtime colors come from the active ThemeData/ColorScheme. TextTheme owns typography; AppText returns configured styles unchanged. Reuse existing components and tokens for repeated decisions; preserve approved exact one-off geometry and local style variations. Details: [Design system](.agent/skills/flutter/references/design_system.md).
- Explicit types for variables, parameters, fields and returns: final bool x = false.
- Navigate through AppNav; no direct Get.to/Get.back or route shortcuts in views. Pass runtime route data through constructors; never Get.arguments.
- No speculative packages, storage systems, databases, logging, config layers, generic services or docs unless the task or existing architecture requires them.

## Mandatory instructions
Before any code or architecture change, read `.agent/skills/flutter/SKILL.md` and its applicable references. New-feature/migration workflow is in that skill.

Skill rules are guardrails, not suggestions. Follow explicitly approved exceptions within their scope. Ask again only when the conflict or authorization remains unclear.

## Progress tracking
- Current task: `.agent/plan/active.md` → start/finish of any task.
- Feature migration: `.agent/plan/checklists/migrate_<feature>.md` or feature-specific checklist → after each phase.
- Roadmap: `.agent/plan/migration_tracker.md` → after status changes.
- Architectural decisions: `.agent/memory/decisions.md` → when choosing between approaches.
- Handoff: `.agent/memory/handoffs/` → when stopping mid-task.

BRAIN's existing workflow, routine-work exceptions, project-state, shared-learning, session-boundary and completion policies remain applicable.

## Code intelligence
Serena is mandatory. Activate the current project before code exploration or changes. Follow BRAIN's symbol-first workflow. If unavailable, stop and follow `.agent/brain/SERENA.md`; do not silently fall back.
