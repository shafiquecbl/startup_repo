# startup_repo

A production-ready Flutter boilerplate with **Agent Brain** — a context engineering framework that gives AI coding tools memory, planning, codebase awareness, and the ability to push back on bad decisions.

Uses **[Serena](https://github.com/oraios/serena)** MCP for symbol-aware code navigation, reference lookup, and focused edits through the Dart language server.

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

Agent Brain fixes this using **portable files + Serena MCP**. `.agent/` remains the source of truth; Serena provides code intelligence.

---

## Quick Start

### 1. Clone the boilerplate

```bash
git clone https://github.com/shafiquecbl/startup_repo.git my-project
cd my-project
```

### 2. Install Serena

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install -p 3.13 serena-agent
serena init
serena setup codex
serena project create . --ls dart --index
```

The setup command above targets Codex. For another AI client, use Serena's
[official client instructions](https://oraios.github.io/serena/02-usage/030_clients.html).
Open the project after setup — the AI reads `AGENTS.md`, activates Serena, and starts working.

### Using with an existing project

```bash
# Copy the Agent Brain files into your project
cp -r path/to/startup_repo/.agent your-project/.agent
cp path/to/startup_repo/AGENTS.md your-project/
cp path/to/startup_repo/CLAUDE.md your-project/
cp -r path/to/startup_repo/.github your-project/

# Configure Serena for this project
cd your-project
serena project create . --ls dart --index
```

---

## How It Works

The client entrypoints route to [AGENTS.md](AGENTS.md), which loads [.agent/brain/BRAIN.md](.agent/brain/BRAIN.md).

- **AGENTS.md** → communication and core coding preferences.
- **BRAIN.md** → task-sized workflow, Serena, project state and shared learning.
- **Flutter SKILL.md** → implementation workflow and links to relevant references.
- **Flutter references** → detailed preferences and exceptions, read when their topic applies.

Small changes stay focused. Features and migrations use a concise plan when they span multiple stages or sessions. Existing code is inspected before changes; verification follows the affected flow and task risk. Handoffs describe meaningful unfinished work only.

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
    │   ├── SKILL.md                 ← Flutter workflow + reference routing
    │   └── references/
    │       ├── architecture.md      ← Layers, API, models, controllers, uploads
    │       ├── widgets.md           ← Extraction, ownership, states, forms
    │       ├── design_system.md     ← Geometry, themes, typography, assets
    │       ├── conventions.md       ← Imports, localization, resources
    │       └── verification.md      ← Format/analyze, performance, exact-path checks
    │
    ├── context/registry.md          ← YOUR PROJECT's component map
    ├── memory/                      ← YOUR PROJECT's learning log, decisions & handoffs
    └── plan/                        ← YOUR PROJECT's active plan & history
        └── checklists/              ← Execution tracking per task
```

**Key separation:** `brain/` and `skills/` are the shared tools (same across all projects). `context/`, `memory/`, and `plan/` are your project's data (unique per project, never overwritten by sync).

**Codebase navigation** is handled by Serena MCP. It uses the Dart language server to find symbols, references, diagnostics, and focused edit targets without reading entire files. Serena memory is disabled because `.agent/` owns project memory and workflow.

---

## Usage Examples

These are real examples of how AI behavior changes with Agent Brain.

### Example 1: AI searches before creating

Without Agent Brain, asking "create a loading button" produces a brand new widget from scratch. With Agent Brain:

```
You: Create a loading button for the checkout screen

AI: Searching existing components...
→ Serena symbol search: "button"

Found:
  PrimaryButton — lib/core/widgets/primary_button.dart
  PrimaryOutlineButton — lib/core/widgets/primary_button.dart

PrimaryButton already supports loading state via `isLoading` param.
Using that:

  PrimaryButton(
    text: 'checkout',
    isLoading: controller.isProcessing,
    onPressed: () => controller.checkout(),
  )
```

### Example 2: AI pushes back on rule violations

```
You: Use setState to toggle this loading state

AI: Violates AGENTS.md → no setState.
Project uses ValueNotifier + ValueListenableBuilder, or GetBuilder.

  // In controller
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool v) { _isLoading = v; update(); }

  // In view
  GetBuilder<Controller>(builder: (Controller controller) => ...)

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

AI: Feature spans several stages → concise plan first.

## Plan: Cart Feature
- [ ] Confirm contract and existing model/component ownership
- [ ] Models, repository interface + implementation
- [ ] Service parsing and feature logic
- [ ] Binding registration, then controller state
- [ ] Screen, justified widgets and AppNav flow
- [ ] Format/analyze each changed Dart file; relevant flow verification

→ Serena symbol search: QuantitySelector already exists at
  lib/features/food_detail/presentation/widgets/quantity_selector.dart
Reusing it.

Plan saved → .agent/plan/active.md. Starting with the contract and models...
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

---

## Flutter Instructions

Coding preferences are maintained in one place per topic:

- [Core preferences and communication](AGENTS.md)
- [Flutter workflow and reference routing](.agent/skills/flutter/SKILL.md)
- [Architecture](.agent/skills/flutter/references/architecture.md)
- [Widgets](.agent/skills/flutter/references/widgets.md)
- [Design system](.agent/skills/flutter/references/design_system.md)
- [Conventions](.agent/skills/flutter/references/conventions.md)
- [Verification](.agent/skills/flutter/references/verification.md)

The previous top-level detail files are replaced by these references. The former workflows content is consolidated into SKILL.md and the relevant topic reference.

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

The current sync script copies brain/ and skills/ only; it does not update root client entrypoints or delete removed source files. When upgrading an existing project to this structure, merge the updated AGENTS.md, CLAUDE.md and .github/copilot-instructions.md, and remove the five legacy Flutter detail files after updating their callers. Keep project-specific instructions and project data intact.

### Learning loop

When you correct the AI in a project:

1. AI records the correction in that project's `.agent/memory/learning_log.md`.
2. AI classifies it as project-specific or a possible global working rule.
3. For a possible global rule, AI proposes the smallest startup_repo skill change and asks for approval.
4. Only after approval, update and validate startup_repo, then push it.
5. Run `sync.js` in other projects → everyone gets the approved rule.

This keeps one reviewed source of truth. Product names, screens, client decisions, temporary bugs, and one-off design
choices remain inside their project.

---

## Adapting for Other Frameworks

Agent Brain is Flutter-first but framework-agnostic at its core. To add React, Python, or any other framework:

1. Create `.agent/skills/react/SKILL.md` with its workflow and relevant constraints
2. Add topic references when needed
3. Everything else (sync, planning, memory, Serena) works unchanged

---

## Architecture Overview

| Component | Purpose |
|-----------|---------|
| `BRAIN.md` | Orchestrator — workflow, project state, and Serena routing |
| `AGENTS.md` | Communication, core preferences and instruction entrypoint |
| `SKILL.md` | Flutter workflow and relevant-reference routing |
| `Serena` | MCP-based symbol navigation, references, diagnostics, and focused edits |
| `sync.js` | Cross-project sync script |

**Context use:** The Flutter skill routes to relevant topic references. Actual context size and token usage depend on the client and task; no fixed token budget is measured here.

---

## Requirements

- **uv + Serena** (for required code intelligence)
- **Flutter** 3.x (for the boilerplate itself)
- An MCP-capable AI coding tool (Codex, Claude Code, Copilot, Cursor, etc.)

---

## License

MIT
