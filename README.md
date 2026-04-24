# startup_repo

A production-ready Flutter boilerplate with **Agent Brain** — a context engineering framework that gives AI coding tools memory, planning, codebase awareness, and the ability to push back on bad decisions.

Uses **[code-review-graph](https://github.com/tirth8205/code-review-graph)** MCP for codebase indexing and navigation — Tree-sitter AST parsing, blast-radius analysis, and semantic search with **6.8× fewer tokens** on reviews.

Works with **Google Antigravity**, **Claude Code**, **GitHub Copilot**, and any AI tool with file + terminal access.

---

## The Problem

AI coding tools are stateless. Every session starts blank. This means:

- AI **forgets** what it was doing mid-session
- AI **repeats** the same mistakes you already corrected
- AI **doesn't know** what widgets, services, or patterns exist in your project
- AI **creates duplicates** instead of reusing your themed components
- AI **ignores** your architecture rules and conventions
- AI **never pushes back** when you ask for something that contradicts past decisions

Agent Brain fixes all of this using **files + code-review-graph MCP**. No paid service. No proprietary lock-in.

---

## Quick Start

### 1. Clone the boilerplate

```bash
git clone https://github.com/shafiquecbl/startup_repo.git my-project
cd my-project
```

### 2. Install code-review-graph

```bash
pip install code-review-graph
code-review-graph build
```

That's it. Open your project in any AI tool and start coding — it reads `AGENTS.md` automatically.

### Using with an existing project

```bash
# Copy the Agent Brain files into your project
cp -r path/to/startup_repo/.agent your-project/.agent
cp path/to/startup_repo/AGENTS.md your-project/
cp path/to/startup_repo/CLAUDE.md your-project/
cp -r path/to/startup_repo/.github your-project/

# Build the code graph
cd your-project
pip install code-review-graph
code-review-graph build
```

---

## How It Works

Every AI tool reads `AGENTS.md` at the project root, which points to `.agent/brain/BRAIN.md` — the orchestrator that teaches the AI two things:

**Rules** — push back on bad requests, search before creating, follow skills, hand off at session end.

**Discipline** — every task follows the same lifecycle, regardless of size:

1. **Understand** — know what's correct before touching what's wrong
2. **Discover** — find every occurrence (CRG search, scan, audit)
3. **Analyze** — read each case, document what's wrong AND what the fix is
4. **Plan** — write a checklist with context per item (not flat `[ ] file.dart`)
5. **Execute** — fix one item at a time, mark done, never batch
6. **Verify** — full project check after everything is fixed

The analysis is written into the checklist, so if a session ends after analyzing 15 files but fixing only 3, the next session picks up at file 4 without re-analyzing.

### Directory Structure

```
your-project/
├── AGENTS.md                        ← AI reads this first (all tools)
├── CLAUDE.md                        ← Claude Code entry point
├── .github/copilot-instructions.md  ← GitHub Copilot entry point
│
└── .agent/
    ├── brain/                       ← TOOL (shared, syncs across projects)
    │   ├── BRAIN.md                 ← The orchestrator
    │   ├── sync.js                  ← Cross-project sync script
    │   └── templates/               ← First-init templates
    │
    ├── skills/flutter/              ← Flutter rules + conventions
    │   ├── SKILL.md                 ← 12 cardinal rules (always loaded)
    │   ├── architecture.md          ← Feature structure, API, models, controllers
    │   ├── design_system.md         ← Colors, typography, theming
    │   ├── widgets.md               ← Reusable UI components
    │   ├── conventions.md           ← Naming, imports, navigation
    │   ├── workflows.md             ← How to build features & screens
    │   └── learning_log.md          ← Corrections (syncs to all projects)
    │
    ├── context/registry.md          ← YOUR PROJECT's component map
    ├── memory/                      ← YOUR PROJECT's decisions & handoffs
    └── plan/                        ← YOUR PROJECT's active plan & history
        └── checklists/              ← Execution tracking per task
```

**Key separation:** `brain/` and `skills/` are the shared tools (same across all projects). `context/`, `memory/`, and `plan/` are your project's data (unique per project, never overwritten by sync).

**Codebase navigation** is handled by code-review-graph MCP — no custom DB needed. CRG builds a Tree-sitter AST graph of your codebase and provides semantic search, impact analysis, and blast-radius computation via MCP tools.

---

## Usage Examples

These are real examples of how AI behavior changes with Agent Brain.

### Example 1: AI searches before creating

Without Agent Brain, asking "create a loading button" produces a brand new widget from scratch. With Agent Brain:

```
You: Create a loading button for the checkout screen

AI: Searching existing components...
→ CRG semantic_search_nodes_tool "button"

Found:
  PrimaryButton — lib/core/widgets/primary_button.dart
  PrimaryOutlineButton — lib/core/widgets/primary_button.dart

PrimaryButton already supports loading state via `isLoading` param.
Using that:

  PrimaryButton(
    text: 'Checkout',
    isLoading: controller.isProcessing,
    onPressed: () => controller.checkout(),
  )
```

### Example 2: AI pushes back on rule violations

```
You: Use setState to toggle this loading state

AI: Violates Cardinal Rule #1 — no setState.
Project uses ValueNotifier + ValueListenableBuilder, or GetBuilder.

  // In controller
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool v) { _isLoading = v; update(); }

  // In view
  GetBuilder<Controller>(builder: (_) => ...)

Override?
```

### Example 3: AI pushes back on past decisions

```
You: Let's use SharedPreferences to store the auth token

AI: You decided on 2026-03-18 → FlutterSecureStorage for auth tokens.
Rationale: SharedPreferences = plaintext. FSS = Keychain (iOS) + EncryptedSharedPreferences (Android).

Reverse?
```

### Example 4: AI plans before building

```
You: Build the full cart feature with add/remove/checkout

AI: 6+ files → planning first.

## Plan: Cart Feature
- [ ] CartController (GetxController) with cart state
- [ ] CartService with API calls
- [ ] CartRepository interface + impl
- [ ] CartScreen using existing AppCard, PrimaryButton, QuantitySelector
- [ ] CartBinding for DI
- [ ] Checkout flow via AppNav
- [ ] dart analyze on all new files

→ CRG search: QuantitySelector already exists at
  lib/features/food_detail/presentation/widgets/quantity_selector.dart
Reusing it.

Plan saved → .agent/plan/active.md. Starting CartController...
```

### Example 5: Session handoff

```
You: I need to stop for today

AI: Writing handoff.

## Handoff — March 18, 2026
**Done:** CartController, CartService, CartRepository, CartBinding
**Remaining:** CartScreen UI, checkout flow, dart analyze
**Key context:** Using existing QuantitySelector. Cart total in controller, not view.

→ .agent/memory/handoffs/2026-03-18.md

Next session picks up from CartScreen UI.
```

### Example 6: Large task — the full lifecycle

Every task follows 6 steps: Understand → Discover → Analyze → Plan → Execute → Verify.

**The task:** "Remove the `Theme.of(context)` local extraction pattern across the project."

**Step 1 — UNDERSTAND:** Read design_system.md. The correct pattern is `context.theme.dividerColor`, `context.font14` — not local `ThemeData` variables.

**Step 2 — DISCOVER:** CRG `semantic_search_nodes_tool` + grep for `Theme.of` → 56 matches in 22 files.

**Step 3 — ANALYZE:** Read each file. Document with LINE NUMBERS what's wrong and the exact replacement. Write into checklist.

**Step 4 — PLAN:** Checklist in `plan/checklists/theme-cleanup.md`:

```markdown
# Checklist: theme-cleanup

> **Status:** 0/21 files done
> **Pattern:** local ThemeData extraction in feature files
> **Correct pattern:** `context.theme.dividerColor`, `context.font14`

---

### lib/core/design/app_text.dart
**SKIP** — defines the `context.fontXX` extension. Approved usage.

---

### lib/core/widgets/app_image.dart
- [ ] L64: `Theme.of(context).cardColor` → `context.theme.cardColor`

---

### lib/features/cart/presentation/view/cart_screen.dart
- [ ] L23: `final ThemeData theme = Theme.of(context);` → DELETE
- [ ] L45: `theme.dividerColor` → `context.theme.dividerColor`
- [ ] L67: `theme.textTheme.bodyMedium` → `context.font14`
```

**Step 5 — EXECUTE:** Fix one file → `dart analyze` → mark ✅ → next file.

**Session ends at 2/21?** Handoff written. Next session reads checklist, picks up at file 3. No re-analysis.

**Step 6 — VERIFY:** All 21 done → `dart analyze` → 0 issues. Log decision. Archive checklist.

---

## Flutter Skill Rules

These 12 rules are always loaded. The AI follows them on every task:

1. **No `setState`** — use `ValueNotifier` + `ValueListenableBuilder`, or `GetBuilder`
2. **Class-based widgets only** — no `Widget _buildX()` function widgets
3. **No hardcoded values** — use `AppPadding`, `AppRadius`, `context.fontXX`, `AppColors`
4. **`Endpoints` class for API paths** — never put paths in `AppConstants`
5. **Explicit types everywhere** — `final bool x = false`, never `final x = false`
6. **`AppNav` for navigation** — never `Get.to()` directly
7. **Constructor-based route params** — never `Get.arguments`
8. **Service returns plain model** — never `ApiResult` in the controller
9. **`dart analyze` after every file** — zero errors before proceeding
10. **Search before creating** — check if a component exists before making a new one
11. **Request models for 3+ params** — create typed `XxxRequestModel` instead
12. **Mixin composition for large controllers** — split into mixins when > ~150 lines

Detailed rules for architecture, design system, widgets, conventions, and workflows are in separate files loaded on-demand when relevant.

---

## Syncing Across Projects

Agent Brain's `brain/` and `skills/` directories are shared. When you improve skills or fix a rule in one project, sync it to all others:

```bash
node .agent/brain/sync.js
```

The sync script:
- Pulls latest from startup_repo
- Updates `brain/` and `skills/` (tool files, skills, templates)
- **Never touches** your project's `context/`, `memory/`, or `plan/`
- Creates data files from templates only if they don't exist

### Learning loop

When you correct the AI in a project:

1. AI adds the correction to `learning_log.md` immediately
2. If it applies to all projects → add to `memory/pending_promotions.md`
3. Open startup_repo → finalize the rule → push to GitHub
4. Run `sync.js` in other projects → everyone gets the fix

---

## Adapting for Other Frameworks

Agent Brain is Flutter-first but framework-agnostic at its core. To add React, Python, or any other framework:

1. Create `.agent/skills/react/SKILL.md` with cardinal rules
2. Add detail files (architecture, conventions, etc.)
3. Everything else (sync, planning, memory, CRG) works unchanged

---

## Architecture Overview

| Component | Purpose |
|-----------|---------|
| `BRAIN.md` | Orchestrator — push-back rules, execution lifecycle, CRG reference |
| `SKILL.md` | Flutter cardinal rules (always loaded) |
| `code-review-graph` | MCP-based codebase indexing, search, and impact analysis |
| `sync.js` | Cross-project sync script |

**Token budget:** Always-loaded context is ~830 tokens. Maximum at any time is ~5,000 tokens. Caveman mode reduces output by ~60-75%.

---

## Requirements

- **Python** 3.10+ (for code-review-graph)
- **Flutter** 3.x (for the boilerplate itself)
- Any AI coding tool with file access and terminal (Antigravity, Claude Code, Copilot, Cursor, etc.)

---

## License

MIT