# startup_repo

A production-ready Flutter boilerplate with **Agent Brain** — a context engineering framework that gives AI coding tools memory, planning, codebase awareness, and the ability to push back on bad decisions.

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

Agent Brain fixes all of this using only **files + a local SQLite database + a CLI tool**. No paid service. No proprietary lock-in. No MCP required.

---

## Quick Start

### 1. Clone the boilerplate

```bash
git clone https://github.com/shafiquecbl/startup_repo.git my-project
cd my-project
```

### 2. Install the Brain CLI

```bash
cd .agent/brain/tools
npm install
cd ../../..
```

### 3. Index your codebase

```bash
node .agent/brain/tools/brain.js index
```

That's it. Open your project in any AI tool and start coding — it reads `AGENTS.md` automatically.

### Using with an existing project

```bash
# Copy the Agent Brain files into your project
cp -r path/to/startup_repo/.agent your-project/.agent
cp path/to/startup_repo/AGENTS.md your-project/
cp path/to/startup_repo/CLAUDE.md your-project/
cp -r path/to/startup_repo/.github your-project/

# Install and index
cd your-project/.agent/brain/tools && npm install
cd ../../.. && node .agent/brain/tools/brain.js index
```

---

## How It Works

Every AI tool reads `AGENTS.md` at the project root, which points to `.agent/brain/BRAIN.md` — the orchestrator that teaches the AI two things:

**Rules** — push back on bad requests, search before creating, follow skills, hand off at session end.

**Discipline** — every task follows the same lifecycle, regardless of size:

1. **Understand** — know what's correct before touching what's wrong
2. **Discover** — find every occurrence (scan, search, audit)
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
    │   ├── BRAIN.md                 ← The orchestrator (87 lines)
    │   ├── skills/flutter/          ← Flutter rules + conventions
    │   │   ├── SKILL.md             ← 10 cardinal rules (always loaded)
    │   │   ├── architecture.md      ← Feature structure, API layer
    │   │   ├── design_system.md     ← Colors, typography, theming
    │   │   ├── widgets.md           ← Reusable UI components
    │   │   ├── conventions.md       ← Naming, imports, navigation
    │   │   ├── workflows.md         ← How to build features & screens
    │   │   └── learning_log.md      ← Corrections (syncs to all projects)
    │   ├── tools/brain.js           ← CLI tool (search, scan, remember, index)
    │   ├── templates/               ← First-init templates
    │   └── sync.js                  ← Cross-project sync script
    │
    ├── context/registry.md          ← YOUR PROJECT's component map
    ├── memory/                      ← YOUR PROJECT's decisions & handoffs
    ├── plan/                        ← YOUR PROJECT's active plan & history
    │   └── checklists/              ← Execution tracking per task
    └── brain.db                     ← SQLite database (gitignored)
```

**Key separation:** `brain/` is the shared tool (same across all projects). `context/`, `memory/`, and `plan/` are your project's data (unique per project, never overwritten by sync).

---

## Usage Examples

These are real examples of how AI behavior changes with Agent Brain.

### Example 1: AI searches before creating

Without Agent Brain, asking "create a loading button" produces a brand new widget from scratch. With Agent Brain:

```
You: Create a loading button for the checkout screen

AI: Let me search for existing button components first.

> node .agent/brain/tools/brain.js search "button"

Found 3 results:
  [widget] PrimaryButton — lib/core/widgets/primary_button.dart
  [widget] PrimaryOutlineButton — outline button — lib/core/widgets/primary_button.dart
  [widget] _ControlButton — lib/features/food_detail/presentation/widgets/quantity_selector.dart

PrimaryButton already supports a loading state via the `isLoading` parameter.
I'll use that instead of creating a new widget:

  PrimaryButton(
    text: 'Checkout',
    isLoading: controller.isProcessing,
    onPressed: () => controller.checkout(),
  )
```

### Example 2: AI pushes back on rule violations

```
You: Use setState to toggle this loading state

AI: That violates Cardinal Rule #1 — no setState.
The project uses ValueNotifier + ValueListenableBuilder, or GetBuilder.

Here's the correct approach:

  // In controller
  final RxBool isLoading = false.obs;

  // In view
  Obx(() => controller.isLoading.value
    ? const LoadingWidget()
    : YourContent(),
  )

Want me to proceed with this approach, or override the rule?
```

### Example 3: AI pushes back on past decisions

```
You: Let's use SharedPreferences to store the auth token

AI: You decided on 2026-03-18 to use FlutterSecureStorage for auth tokens.
Rationale: SharedPreferences is plaintext; FSS uses Keychain (iOS)
and EncryptedSharedPreferences (Android).

Want to reverse this decision, or keep using FlutterSecureStorage?
```

### Example 4: AI plans before building

```
You: Build the full cart feature with add/remove/checkout

AI: This touches 6+ files, so let me plan first.

## Plan: Cart Feature
- [ ] Create CartController (GetxController) with cart state
- [ ] Create CartService with API calls
- [ ] Create CartRepository interface + implementation
- [ ] Build CartScreen using existing AppCard, PrimaryButton, QuantitySelector
- [ ] Add CartBinding for dependency injection
- [ ] Connect checkout flow via AppNav
- [ ] Run dart analyze on all new files

I've checked the registry — QuantitySelector already exists at
lib/features/food_detail/presentation/widgets/quantity_selector.dart.
I'll reuse it.

Saving plan to .agent/plan/active.md. Starting with CartController...
```

### Example 5: Session handoff

```
You: I need to stop for today, let's pick this up tomorrow

AI: Writing session handoff.

## Handoff — March 18, 2026
**Done:** CartController, CartService, CartRepository, CartBinding
**Remaining:** CartScreen UI, checkout flow, dart analyze
**Files touched:** 4 new files in lib/features/cart/
**Key context:** Using existing QuantitySelector widget.
Cart total calculation is in controller, not view.

Saved to .agent/memory/handoffs/2026-03-18.md

Tomorrow's session will read this automatically and pick up
from CartScreen UI.
```

### Example 6: Searching the codebase

```
You: What image loading widgets do we have?

AI: > node .agent/brain/tools/brain.js search "image"

Found 2 results:
  [widget] AppImage — Unified image widget for network and asset images.
    Handles loading (shimmer), error states, and caching.
    → lib/core/widgets/app_image.dart

  [widget] CustomShimmer — Theme-aware shimmer wrapper.
    → lib/core/widgets/shimmer.dart

AppImage handles both network and asset images with built-in
shimmer loading. Use it like:

  AppImage(
    url: product.imageUrl,
    width: 120,
    height: 120,
    borderRadius: AppRadius.r12,
  )
```

### Example 7: Remembering decisions

```
You: We've decided to use Dio instead of http package for API calls

AI: Logging this decision.

> node .agent/brain/tools/brain.js remember decision "Use Dio instead of http package for API calls — better interceptor support, retry logic, and cancellation"

I've also updated .agent/memory/decisions.md so future sessions
know about this choice. Should I start migrating ApiClient to Dio?
```

### Example 8: Large task — the full lifecycle

Every task follows 6 steps: Understand → Discover → Analyze → Plan → Execute → Verify. Here's a real example from a migration project.

**The task:** "Remove the boilerplate-invalid `Theme.of(context)` local extraction pattern across the project."

**Step 1 — UNDERSTAND (what is right?):**
```
You: Remove the Theme.of(context) extraction pattern across the project

AI: Before I touch anything, let me understand the correct pattern.
Reading design_system.md and the boilerplate...

The boilerplate provides:
- context.font14, context.font16 etc. for text styles (AppText extension)
- AppColors.current.divider, AppColors.current.hint for theme colors
- Theme.of(context) IS correct inside core/design/ — that's where
  the extensions are defined

The BAD pattern is feature-level files doing this:
  final ThemeData theme = Theme.of(context);
  final Color textColor = theme.textTheme.titleMedium?.color;

Now I know what to fix and what to replace it with. Let me find every occurrence.
```

**Step 2 — DISCOVER (where is the problem?):**
```
AI: > node .agent/brain/tools/brain.js scan "Theme.of" --name theme-cleanup

Scan complete: 56 matches in 22 files
Checklist saved: .agent/plan/checklists/theme-cleanup.md
```

**Step 3 — ANALYZE (what is wrong in each place?):**
```
AI: Now I need to read each file to understand what specifically needs to change.
Not every file needs the same fix...

Analyzing lib/core/design/app_text.dart — 15 matches.
This IS the extension that provides context.fontXX. This is the
APPROVED pattern. Marking as SKIP.

Analyzing lib/core/widgets/app_image.dart — 1 match.
L64: Theme.of(context).cardColor used for shimmer placeholder.
Fix: replace with AppColors.current.card

Analyzing lib/features/cart/presentation/view/cart_screen.dart — 2 matches.
L23: extracts full ThemeData into local variable
L45: uses theme.dividerColor, L67: uses theme.textTheme.bodyMedium
Fix: remove L23, replace L45 with AppColors.current.divider,
replace L67 with context.font14

Analyzing lib/features/food_detail/presentation/widgets/food_detail_info.dart
— 4 matches. Extracts ThemeData then derives textColor, bodyColor,
hintColor, dividerColor as locals. Used 8 times total.
Fix: remove extraction block, map each derived color to its
boilerplate-approved replacement.

[continues analyzing all 22 files, writing findings into checklist]

Analysis complete. 1 file skipped (core/design — approved usage).
21 files need fixes. All analysis written to the checklist.
```

**Step 4 — PLAN (the checklist, with context per file):**

The AI has already written this into `plan/checklists/theme-cleanup.md` during analysis:

```markdown
# Checklist: theme-cleanup

> Pattern: `Theme.of`
> Total: 21 files to fix (1 skipped — core/design is approved)
> Progress: 0/21 files done

## [skip] lib/core/design/app_text.dart
APPROVED — this defines the context.fontXX extension

## [ ] lib/core/widgets/app_image.dart
- L64: Theme.of(context).cardColor
- Fix: AppColors.current.card

## [ ] lib/features/cart/presentation/view/cart_screen.dart
- L23: full ThemeData extraction
- L45: theme.dividerColor → AppColors.current.divider
- L67: theme.textTheme.bodyMedium → context.font14

## [ ] lib/features/food_detail/presentation/widgets/food_detail_info.dart
- L12: ThemeData + 4 derived color locals
- textColor (4 uses) → context.font14.color
- bodyColor (2 uses) → context.font12.color
- hintColor (1 use) → AppColors.current.hint
- dividerColor (1 use) → AppColors.current.divider

... 17 more files with specific analysis ...
```

**Step 5 — EXECUTE (one file at a time):**
```
AI: Starting with app_image.dart (simplest — 1 match).

[fixes the file, runs dart analyze, passes]

Marked [x] in checklist. Progress: 1/21.
Next: cart_screen.dart...

[fixes cart_screen.dart, runs dart analyze, passes]

Marked [x]. Progress: 2/21.
```

**Session ends here.** AI writes handoff:
```
Theme cleanup: 2/21 files done.
Checklist: plan/checklists/theme-cleanup.md
All 21 files already analyzed with specific fixes documented.
Next: cart_item_card.dart
No blockers.
```

**Next session:**
```
You: Continue the theme cleanup

AI: Reading checklist at plan/checklists/theme-cleanup.md
Progress: 2/21 files done. All remaining files already analyzed.
Next: lib/features/cart/presentation/widgets/cart_item_card.dart

The analysis says: L18 extracts theme.dividerColor.
Fix: replace with AppColors.current.divider.

[applies fix, no re-reading or re-analyzing needed]
```

**Step 6 — VERIFY (after all 21 files done):**
```
AI: All 21 files fixed. Running full verification.

> dart analyze → 0 issues
> node .agent/brain/tools/brain.js scan "Theme.of" --name theme-verify
  Only matches in core/design/ (approved usage) — clean.
> node .agent/brain/tools/brain.js index --incremental

Logging decision: "Removed Theme.of(context) extraction pattern from all
feature files. Approved usage remains in core/design/app_text.dart."

Theme cleanup complete. Archiving checklist to plan/history.md.
```

The key insight: the analysis from Step 3 is written INTO the checklist. If the session dies after analyzing 15 files but fixing only 3, the next session doesn't re-analyze — it reads the checklist and picks up at file 4.

---

## Brain CLI Reference

The AI runs these commands via terminal. You can also run them manually.

```bash
# Search (most important — "search before creating")
node .agent/brain/tools/brain.js search "loading"
node .agent/brain/tools/brain.js search --type widget "button"
node .agent/brain/tools/brain.js search --type controller "cart"

# Scan & checklist (for large tasks)
node .agent/brain/tools/brain.js scan "Theme.of" --name theme-cleanup
node .agent/brain/tools/brain.js scan "setState" --name remove-setstate
node .agent/brain/tools/brain.js scan "EdgeInsets\." --name hardcoded-spacing
node .agent/brain/tools/brain.js scan "Colors\." --name hardcoded-colors

# Add knowledge
node .agent/brain/tools/brain.js node add widget "AppPrice" "Formatted price display" --file lib/core/widgets/app_price.dart
node .agent/brain/tools/brain.js remember decision "Use Dio for HTTP"

# Task management
node .agent/brain/tools/brain.js task add "Build CartScreen" "Cart UI with checkout"
node .agent/brain/tools/brain.js task list
node .agent/brain/tools/brain.js task list --status active
node .agent/brain/tools/brain.js task update task_build_cartscreen done

# Relationships
node .agent/brain/tools/brain.js relate controller_cart uses service_cart "Constructor injection"

# Indexing
node .agent/brain/tools/brain.js index                # full codebase scan
node .agent/brain/tools/brain.js index --incremental  # only changed files

# Maintenance
node .agent/brain/tools/brain.js prune                # archive nodes with deleted files
node .agent/brain/tools/brain.js status               # database stats
node .agent/brain/tools/brain.js registry              # regenerate registry.md
```

### What the indexer finds

The indexer scans all `.dart` files under `lib/` and automatically detects:

| What | How it's detected |
|------|-------------------|
| Widgets | Extends `StatelessWidget`, `StatefulWidget`, `GetView`, etc. |
| Controllers | Extends `GetxController`, `ChangeNotifier`, or name ends with `Controller` |
| Services | Name ends with `Service` or in `/services/` directory |
| Repositories | Name ends with `Repository` or `Repo` |
| Models | Name ends with `Model` or `Entity` |
| Screens | Name ends with `Screen`, `Page`, or `View` |
| Bindings | Name ends with `Binding` |
| Enums | `enum` declarations |
| Extensions | `extension` declarations |

Types emerge naturally from your code — no configuration needed.

---

## Flutter Skill Rules

These 10 rules are always loaded. The AI follows them on every task:

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

Detailed rules for architecture, design system, widgets, conventions, and workflows are in separate files loaded on-demand when relevant.

---

## Syncing Across Projects

Agent Brain's `brain/` directory (the tool) is shared. When you improve skills or fix a rule in one project, sync it to all others:

```bash
# In any project using Agent Brain
node .agent/brain/sync.js
```

The sync script:
- Pulls latest from startup_repo
- Updates `brain/` (tool files, skills, templates)
- **Never touches** your project's `context/`, `memory/`, or `plan/`
- Creates data files from templates only if they don't exist
- Warns about pending learning log promotions
- Auto-archives handoffs older than 14 days

### Learning loop

When you correct the AI in a project:

1. AI adds the correction to `learning_log.md` immediately
2. If it applies to all projects → add to `memory/pending_promotions.md`
3. Open startup_repo → finalize the rule → push to GitHub
4. Run `sync.js` in other projects → everyone gets the fix

---

## Adapting for Other Frameworks

Agent Brain is Flutter-first but framework-agnostic at its core. To add React, Python, or any other framework:

1. Create `.agent/brain/skills/react/SKILL.md` with cardinal rules
2. Add detail files (architecture, conventions, etc.)
3. Update the indexer in `brain.js` to parse `.tsx`/`.py` files
4. Everything else (database, CLI, sync, planning, memory) works unchanged

---

## Architecture Overview

For the full technical design document, see [ARCHITECTURE.md](.agent/brain/ARCHITECTURE.md) or the generated Word document.

| Component | Purpose | Size |
|-----------|---------|------|
| `BRAIN.md` | Orchestrator — push-back rules, execution lifecycle, CLI reference | 87 lines |
| `SKILL.md` | Flutter cardinal rules (always loaded) | 25 lines |
| `brain.js` | CLI tool — search, scan, remember, task, index, prune | 533 lines |
| `sync.js` | Cross-project sync script | 238 lines |
| `brain.db` | SQLite database (auto-generated, gitignored) | ~76 KB |

**Token budget:** Always-loaded context is ~830 tokens. Maximum at any time is ~5,000 tokens. This is deliberately small — research shows that overloading AI context with instructions actually reduces performance.

---

## Requirements

- **Node.js** 18+ (for the Brain CLI)
- **Flutter** 3.x (for the boilerplate itself)
- Any AI coding tool with file access and terminal (Antigravity, Claude Code, Copilot, Cursor, etc.)

---

## License

MIT