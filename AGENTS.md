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

---

<!-- code-review-graph MCP tools -->

## MCP Tools: code-review-graph

**IMPORTANT: This project has a knowledge graph. ALWAYS use the
code-review-graph MCP tools BEFORE using Grep/Glob/Read to explore
the codebase.** The graph is faster, cheaper (fewer tokens), and gives
you structural context (callers, dependents, test coverage) that file
scanning cannot.

### When to use graph tools FIRST

- **Exploring code**: `semantic_search_nodes` or `query_graph` instead of Grep
- **Understanding impact**: `get_impact_radius` instead of manually tracing imports
- **Code review**: `detect_changes` + `get_review_context` instead of reading entire files
- **Finding relationships**: `query_graph` with callers_of/callees_of/imports_of/tests_for
- **Architecture questions**: `get_architecture_overview` + `list_communities`

Fall back to Grep/Glob/Read **only** when the graph doesn't cover what you need.

### Key Tools

| Tool                        | Use when                                               |
| --------------------------- | ------------------------------------------------------ |
| `detect_changes`            | Reviewing code changes — gives risk-scored analysis    |
| `get_review_context`        | Need source snippets for review — token-efficient      |
| `get_impact_radius`         | Understanding blast radius of a change                 |
| `get_affected_flows`        | Finding which execution paths are impacted             |
| `query_graph`               | Tracing callers, callees, imports, tests, dependencies |
| `semantic_search_nodes`     | Finding functions/classes by name or keyword           |
| `get_architecture_overview` | Understanding high-level codebase structure            |
| `refactor_tool`             | Planning renames, finding dead code                    |

### Workflow

1. The graph auto-updates on file changes (via hooks).
2. Use `detect_changes` for code review.
3. Use `get_affected_flows` to understand impact.
4. Use `query_graph` pattern="tests_for" to check coverage.
