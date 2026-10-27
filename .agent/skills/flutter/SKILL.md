---
name: flutter
description: Build and maintain Flutter features using this repository's architecture, GetX state, design tokens and app-owned widgets.
---

# Flutter Workflow
Act as a Senior Flutter Engineer. These project rules override general Flutter knowledge.

## Load applicable references
- Feature/API/service/repository/controller/model work → [Architecture](references/architecture.md).
- Screens/widgets → [Widgets](references/widgets.md) + [Design system](references/design_system.md) + applicable [Conventions](references/conventions.md). Feature state/data flow also requires [Architecture](references/architecture.md).
- Styling/theming/colors → [Design system](references/design_system.md).
- Navigation/imports/naming/code conventions → [Conventions](references/conventions.md).
- Formatting, analysis, cleanup, performance or delivery verification → [Verification](references/verification.md).

Load relevant references only; additional references when the task touches their topic.

## Before implementation
- Establish the requested outcome. Trace the relevant end-to-end path to an evidenced root cause before changing code; do not patch assumptions.
- Research/opinion on an unresolved product decision → present evidence, options and a recommendation before implementation. A suggestion remains unapproved until the owner explicitly chooses it.
- Search existing widgets, components, models and services before creating replacements.

## Screens, features and migrations
- Before screen code: inventory screens; identify meaningful repeated cards/tiles/badges/states; check matching tokens and exact approved values; plan justified widgets.
- Build justified widgets before screen composition. Keep readable, cohesive UI inline; follow Widgets for extraction and ownership.
- Build order: contract → model → repository → service → binding → controller → UI.
- Plan applicable initial, loading, refreshing, paginating, error, empty and content states.
- Review shared helpers/local geometry, themed colors and consistent Scaffold structure.
- Before sign-off, follow Verification. Use BRAIN's task-sized planning and relevant tests/builds.
