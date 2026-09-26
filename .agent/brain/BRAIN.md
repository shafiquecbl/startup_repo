# Agent Brain

## Purpose

This repository is a reusable Flutter starter.

- `skills/` = shared engineering rules that improve over time.
- `brain/` = shared agent workflow and bootstrap templates.
- `context/`, `memory/`, and `plan/` = project-local state. They start clean in this template and are never synced over existing project data.

## Communication

Use caveman mode → short, direct, no filler. Explain deeply only when asked.

## Source Of Truth

1. Read `.agent/skills/flutter/SKILL.md` before Flutter code or architecture changes.
2. Load only the relevant detail file referenced by the skill.
3. Check `.agent/memory/decisions.md` before reversing an established project decision.
4. User instructions override project preferences unless they conflict with a mandatory safety rule.

## Code Navigation

Serena MCP is mandatory for code exploration and symbol-aware edits.

1. Activate the current project with Serena before reading code.
2. Use symbol overview/search and reference lookup before opening whole files.
3. Use Serena's symbol editing/refactoring tools when they fit the change.
4. Use targeted `rg` for plain text, configuration, generated files, or gaps in language-server support.

If Serena is missing, disconnected, or the project is not configured, stop normal code work and follow
[`SERENA.md`](SERENA.md). Install, configure, activate, and verify it instead of silently falling back.

`.agent/` remains the source of truth for memory and workflow. Do not use Serena memories or onboarding.

## Workflow

Scale process to the task.

### Small change

1. Read the relevant rule and file.
2. Make the focused change.
3. Format and analyze the affected code.

### Feature or migration

1. Understand the requested outcome.
2. Inspect existing patterns and impact.
3. Record a concise checklist in `.agent/plan/active.md` when work spans multiple stages or sessions.
4. Implement in reviewable increments.
5. Format, analyze, and run relevant tests/builds.
6. Move only durable architectural choices to `.agent/memory/decisions.md`.

Do not create plans, decisions, learning entries, or handoffs for routine work that does not need them.

## Project State

- `context/registry.md` → verified current components only. Update when structural inventory changes.
- `memory/decisions.md` → active architectural decisions only. Supersede or remove stale decisions.
- `memory/learning_log.md` → project-specific corrections only.
- `memory/handoffs/` → unfinished cross-session work only. Delete obsolete handoffs.
- `plan/active.md` → current unfinished work only. Reset when complete.
- `plan/history.md` → optional concise outcomes, not command logs or temporary investigation.
- `plan/checklists/` → active detailed checklists only. Delete them after completion unless they remain operational documentation.

## Shared Learning

When the user corrects a pattern:

1. Fix the current project.
2. Keep product-specific lessons local.
3. For a reusable rule, propose the smallest canonical `startup_repo/.agent/skills/` change.
4. Edit the shared skill only after explicit approval.
5. Validate it, then let the sync flow distribute it.

Never promote product names, screens, client decisions, temporary bugs, or one-off examples into shared skills.

## Session Boundaries

Write a handoff only when stopping with meaningful unfinished work. Include completed work, next action, blockers, and relevant files. Completed work needs no handoff.

## Completion

Return the result, verification performed, and any real remaining blocker. Keep `.agent` state smaller than the work it describes.
