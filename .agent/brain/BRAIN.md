# Agent Brain

## Push Back Before You Code
- VIOLATES a skill rule → stop, cite the rule, ask to confirm override
- CONTRADICTS a past decision → warn: "You decided X on [date] — want to reverse?"
- VAGUE request → ask one clarifying question before starting
- "Override" or "just do it" → skip push-back instantly
- Quick fixes get a brief note, not a debate

## Mandatory Workflow
1. SEARCH before creating — `node .agent/brain/tools/brain.js search "<what>"` before any new file/widget/component
2. READ skill rules — `.agent/brain/skills/flutter/SKILL.md` before writing code
3. CHECK decisions — `.agent/memory/decisions.md` before architectural choices
4. HAND OFF when stopping — write to `.agent/memory/handoffs/`

## Context Loading
**Quick fix** (1-2 files): BRAIN.md + SKILL.md only
**Feature** (3-10 files): + registry.md + decisions.md + relevant skill detail file
**Project/migration**: + active plan + checklists + full skill files + handoff history

## Skill Files
Always load `.agent/brain/skills/flutter/SKILL.md` (cardinal rules).
Detail files on-demand only:

| File | When |
|------|------|
| architecture.md | Features, API, service layer |
| design_system.md | Styling, theming, colors |
| widgets.md | Building UI components |
| conventions.md | Navigation, imports, naming |
| workflows.md | New features, screens, migrations |

## Brain CLI
```
brain.js search "query"              # find components
brain.js search --type widget "q"    # filter by type
brain.js scan "pattern" --name x     # scan + generate checklist
brain.js remember "type" "text"      # save a memory
brain.js task add "title" "desc"     # quick task
brain.js task list                   # show tasks
brain.js task update "id" "done"     # mark complete
brain.js index --incremental         # update database
brain.js prune                       # remove stale nodes
brain.js status                      # db stats
```
(Prefix all commands with `node .agent/brain/tools/`)

## Execution — The Lifecycle of Every Task
Every task follows this sequence. Never skip a step. Depth scales with the task.

### 1. UNDERSTAND — What is right?
Before looking at what's wrong, know what's correct. Read the skill rules. Read the boilerplate. Read past decisions. Document the SPECIFIC correct patterns — not vague descriptions.
Bad: "use theme-driven composition." Good: "`context.theme.dividerColor` for divider colors, `context.theme.hintColor` for hints."

### 2. DISCOVER — Where is the problem?
Find every occurrence. Use `brain.js scan` for pattern-based tasks. Use `brain.js search` + manual audit for architectural tasks. For new features, discover what already exists that you can reuse.

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

### 6. VERIFY — Confirm everything works together
After all items `[x]`: run `dart analyze` on full project. Run `brain.js index --incremental`. Log decisions. Write handoff.

### Session boundaries
Can happen between ANY steps. The checklist + handoff capture your exact position:
- Stopped after step 2? Discovery is written, analysis hasn't started.
- Stopped mid step 5? Checklist shows 8/22 files fixed, next file is clear.
- Next session reads the checklist and continues — no re-analysis needed.

## Self-Healing
Missing file → skip. Failed import → update registry. Stale data → verify filesystem, update.

## Task Completion
Update `context/registry.md` + `memory/decisions.md`. Write handoff to `memory/handoffs/`.

## REMEMBER: Search first. Follow skills. Understand before fixing. Push back when something is wrong.
