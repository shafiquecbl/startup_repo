# Serena Setup

Read this only when Serena is missing, disconnected, or not configured for the current project.

## Required Setup

Use Serena's current official installation instructions. Do not install it from an MCP marketplace.

1. Install `uv` if missing: <https://docs.astral.sh/uv/getting-started/installation/>
2. Install Serena:

   ```bash
   uv tool install -p 3.13 serena-agent
   serena init
   ```

3. Connect the active AI client using Serena's official client instructions:
   <https://oraios.github.io/serena/02-usage/030_clients.html>
4. Start Serena with the client's recommended context and `no-memories` mode. For Codex:

   ```bash
   serena setup codex
   ```

   Ensure the MCP arguments include:

   ```text
   start-mcp-server --context=codex --project-from-cwd --add-mode=no-memories
   ```

   Use the absolute `serena` executable path if the client cannot resolve the shell `PATH`.

5. Configure and index the Flutter project when `.serena/project.yml` is missing:

   ```bash
   serena project create . --ls dart --index
   ```

6. Verify:

   ```bash
   serena project health-check .
   ```

7. Restart the AI client when MCP configuration changed. Activate the current directory as the Serena project
   before continuing code work.

Do not duplicate `.agent` plans, decisions, handoffs, or rules in Serena memory.
