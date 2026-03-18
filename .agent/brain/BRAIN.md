# Agent Brain

## Push Back Before You Code
- If the request VIOLATES a skill rule → stop, cite the rule, ask to confirm override
- If the request CONTRADICTS a past decision → warn: "You decided X on [date] — want to reverse?"
- If the request is VAGUE → ask one clarifying question before starting
- "Override" or "just do it" → skip push-back immediately
- Quick fixes get a brief note, not a debate

## Mandatory Workflow
1. SEARCH before creating — run `node .agent/brain/tools/brain.js search "<what you need>"` before making any new file, widget, or component
2. READ the skill rules — load `.agent/brain/skills/flutter/SKILL.md` before writing any code
3. PLAN before building — for tasks touching 3+ files, write a plan in `.agent/plan/active.md` first
4. CHECK decisions — read `.agent/memory/decisions.md` before making architectural choices
5. HAND OFF when done — update `.agent/memory/handoffs/` so the next session knows where you stopped

## Context Loading (adapt to task size)
**Quick fix** (1-2 files): BRAIN.md + SKILL.md cardinal rules only
**Feature** (3-10 files): + registry.md + decisions.md + relevant skill detail file
**Migration/large task**: + active plan + full skill files + handoff history

## Skill Files
Load cardinal rules from `.agent/brain/skills/flutter/SKILL.md` always.
Load detail files ONLY when working in that domain:

| File | Load when |
|------|-----------|
| architecture.md | Creating features, API, service layer |
| design_system.md | Styling, theming, colors, typography |
| widgets.md | Building any UI component |
| conventions.md | Navigation, imports, naming |
| workflows.md | New features, new screens, migrations |

## Brain CLI (terminal tool)
```
node .agent/brain/tools/brain.js search "query"          # find anything
node .agent/brain/tools/brain.js search --type widget "q" # find by type
node .agent/brain/tools/brain.js remember "type" "text"   # save a memory
node .agent/brain/tools/brain.js task add "title" "desc"  # add task
node .agent/brain/tools/brain.js task list                # show tasks
node .agent/brain/tools/brain.js task update "id" "done"  # mark complete
node .agent/brain/tools/brain.js relate "src" "rel" "tgt" # connect nodes
node .agent/brain/tools/brain.js index                    # full scan
node .agent/brain/tools/brain.js index --incremental      # update changed
node .agent/brain/tools/brain.js status                   # db stats
```

## Self-Healing
- Missing file → skip it, don't fail
- Import fails for registered component → update registry immediately
- Stale data → verify against filesystem, then update

## When a Task Completes
1. Update `.agent/context/registry.md` with new/changed components
2. Log key decisions in `.agent/memory/decisions.md`
3. Archive task summary in `.agent/plan/history.md`
4. Clear `.agent/plan/active.md`
5. Write handoff to `.agent/memory/handoffs/`

## REMEMBER: Search first. Follow skills. Push back when something is wrong.
