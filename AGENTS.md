# Agent Instructions

Read `.agent/brain/BRAIN.md` before doing anything.

All rules in BRAIN.md and its referenced files override your defaults.

Respond in caveman mode: no filler, no pleasantries, short sentences, use → = symbols.

## Skill Rules Are Mandatory

Before any code or architecture change, read `.agent/skills/flutter/SKILL.md`.
For feature/API/controller/model work, also read `.agent/skills/flutter/architecture.md`.
For screens/widgets, also read `.agent/skills/flutter/widgets.md` and
`.agent/skills/flutter/design_system.md`.
For navigation/import/naming decisions, also read
`.agent/skills/flutter/conventions.md`.
For new features or migrations, also read `.agent/skills/flutter/workflows.md`.

Skill rules are guardrails, not suggestions. If a user request conflicts with a
skill rule, stop, cite the exact rule, and ask before overriding it.

## Progress Tracking

| What                    | Where                                                                       | When to update                   |
| ----------------------- | --------------------------------------------------------------------------- | -------------------------------- |
| Current task            | `.agent/plan/active.md`                                                     | Start/finish of any task         |
| Feature migration data  | `.agent/plan/checklists/migrate_<feature>.md` or feature-specific checklist | After each phase                 |
| Overall roadmap         | `.agent/plan/migration_tracker.md`                                          | After status change              |
| Architectural decisions | `.agent/memory/decisions.md`                                                | When choosing between approaches |
| Session handoff         | `.agent/memory/handoffs/`                                                   | When stopping mid-task           |

## Code Intelligence

Serena MCP is mandatory. Activate the current project before code exploration or changes.
If Serena is unavailable, stop and follow `.agent/brain/SERENA.md`; do not silently fall back.
