# Agent Brain

## Caveman Mode
No filler. No pleasantries. Short sentences. Use → = symbols.
Skip "I'll" "Let me" "Sure" "Great". Focus on code output.
Full explanations only when user asks "explain" or "why".

## Setup — code-review-graph MCP
If `code-review-graph` MCP is not available or graph not built:
```bash
pip install code-review-graph 2>/dev/null || pip3 install code-review-graph
code-review-graph build
```

## Push Back Before You Code
- VIOLATES a skill rule → stop, cite the rule, ask to confirm override
- CONTRADICTS a past decision → warn: "You decided X on [date] — want to reverse?"
- VAGUE request → ask one clarifying question before starting
- "Override" or "just do it" → skip push-back instantly
- Quick fixes get a brief note, not a debate

## Mandatory Workflow
1. SEARCH before creating — use CRG `semantic_search_nodes_tool` before any new file/widget/component
2. READ skill rules — `.agent/skills/flutter/SKILL.md` before writing code
3. CHECK decisions — `.agent/memory/decisions.md` before architectural choices
4. HAND OFF when stopping — write to `.agent/memory/handoffs/`

## Context Loading
**Quick fix** (1-2 files): BRAIN.md + SKILL.md only
**Feature** (3-10 files): + registry.md + decisions.md + relevant skill detail file
**Project/migration**: + active plan + checklists + full skill files + handoff history

## Keep Context Clean
Your context window is limited. Every file you read, every search result, every error log competes for space. Protect it:
- **Use CRG MCP instead of manual grep/find** — MCP tools return compact results, raw grep floods context
- **Offload exploration** — use subagents or separate tool calls that return summaries, not raw file contents
- **One task per focus** — don't explore 5 files "just in case." Read what you need for the current checklist item
- **If context feels heavy** (~20+ tool calls without writing to plan/checklist) — stop, write your progress to the checklist, summarize what you know, then continue with a cleaner window
- **Never read an entire file to find one function** — use CRG `semantic_search_nodes_tool` or targeted line ranges

## Skill Files
Always load `.agent/skills/flutter/SKILL.md` (cardinal rules).
Detail files on-demand only:

| File | When |
|------|------|
| architecture.md | Features, API, service, models, controllers |
| design_system.md | Styling, theming, colors |
| widgets.md | Building UI components |
| conventions.md | Navigation, imports, naming |
| workflows.md | New features, screens, migrations |
| learning_log.md | After being corrected — append immediately |

## CRG MCP Tools
Use these for all codebase navigation (replaces brain.js):
- `semantic_search_nodes_tool` → find components (search before creating)
- `query_graph_tool` → find callers/callees/imports of a function
- `get_impact_radius_tool` → blast radius before changes
- `get_minimal_context_tool` → quick context for any task
- `build_or_update_graph_tool` → rebuild after major changes
- `detect_changes_tool` → risk-scored change analysis

## Execution — The Lifecycle of Every Task
Every task follows this sequence. Never skip a step. Depth scales with the task.

### 1. UNDERSTAND — What is right?
Before looking at what's wrong, know what's correct. Read the skill rules. Read the boilerplate. Read past decisions. Document the SPECIFIC correct patterns — not vague descriptions.
Bad: "use theme-driven composition." Good: "`context.theme.dividerColor` for divider colors, `context.theme.hintColor` for hints."

### 2. DISCOVER — Where is the problem?
Find every occurrence. Use CRG `semantic_search_nodes_tool` for pattern-based tasks. Use CRG `query_graph_tool` + manual audit for architectural tasks. For new features, discover what already exists that you can reuse.

### 3. ANALYZE — What specifically is wrong in each place?
Read each file. Document with LINE NUMBERS what is wrong and what the specific fix is. Don't say "local theme drives multiple colors" — say "L18: `final ThemeData theme = Theme.of(context)` → DELETE. L34: `theme.cardColor` → `context.theme.cardColor`."

### 4. PLAN — Write the execution checklist
Combine steps 2-3 into a TRACKABLE checklist in `plan/checklists/`. Use this format:

```markdown
# Checklist: theme-cleanup

> **Status:** 2/21 files done
> **Pattern:** local ThemeData extraction in feature files
> **Correct pattern:** `context.theme.dividerColor`, `context.font14`

---

### lib/core/design/app_text.dart
**SKIP** — this defines the `context.fontXX` extension. Approved usage.

---

### ~~lib/core/widgets/app_image.dart~~ ✅
- ~~L64: `Theme.of(context).cardColor` → `context.theme.cardColor`~~

---

### lib/features/cart/presentation/view/cart_screen.dart
- [ ] L23: `final ThemeData theme = Theme.of(context);` → DELETE
- [ ] L45: `theme.dividerColor` → `context.theme.dividerColor`
- [ ] L67: `theme.textTheme.bodyMedium` → `context.font14`
- **Depends on:** nothing
```

Rules: strikethrough + ✅ for done files. `- [ ]` checkboxes for pending items. `---` between files. Progress count at the top.

### 5. EXECUTE — Fix one item at a time
Pick the next `[ ]` item. Apply the fix. Run `dart analyze`. Mark `[x]`. Move to next. Never attempt multiple files at once.

**If something goes sideways — STOP.** Don't push through a broken approach. If a fix causes 3+ new errors, or the approach from step 3 turns out to be wrong, or you realize the plan missed something: stop executing, update the checklist with what you learned, re-analyze the affected items, then continue.

### 6. VERIFY — Confirm it works AND it's right
After all items `[x]`: run `dart analyze` on full project. Log decisions. Write handoff.

**Self-review before presenting:** For non-trivial changes (new features, architectural work), pause and ask: "Is there a more elegant way?" If a fix feels hacky — refactor before marking done. Skip the elegance pass for simple, obvious fixes.

### Session boundaries
Can happen between ANY steps. The checklist + handoff capture your exact position:
- Stopped after step 2? Discovery is written, analysis hasn't started.
- Stopped mid step 5? Checklist shows 8/22 files fixed, next file is clear.
- Next session reads the checklist and continues — no re-analysis needed.

## Self-Healing
Missing file → skip. Failed import → update registry. Stale data → `code-review-graph build`.

## Task Completion
Update `context/registry.md` + `memory/decisions.md`. Write handoff to `memory/handoffs/`.

## REMEMBER: Search first. Follow skills. Caveman output. Push back when something is wrong.