---
name: rcommon:create-plugin
description: "Create a new plugin for the rCommon marketplace with correct structure, naming, and governance."
---

# /rcommon:create-plugin

Create a new plugin for the rCommon marketplace. Follow the `rcommon-plugin-creator` skill instructions exactly — the full 11-step process.

## Prerequisites

Before starting, verify the current working directory is inside a clone of the marketplace repo. Check that `.claude-plugin/marketplace.json` exists at the git repo root. If it does not:

1. Tell the user they need to be inside the marketplace repo
2. Provide the clone command: `git clone https://github.com/creative-technology-lab/rCommon-claude-plugin-marketplace.git`
3. Stop — do not create files outside the marketplace repo

## Steps

1. **Gather requirements** — ask the user for: plugin name (kebab-case with `rcommon-` prefix), description, what components it needs (skills, commands, hooks, agents, MCP servers, LSP servers), category, and whether it is inline or external.

2. **Create the plugin directory** under `plugins/<plugin-name>/` with only the component directories the plugin actually needs.

3. **Write `.claude-plugin/plugin.json`** — with `name`, `description`, and `version` (start at `1.0.0`). The name MUST match the directory name. Never use `marketplace.json` inside a plugin.

4. **Create skills** (if needed) — `skills/<skill-name>/SKILL.md` with YAML frontmatter including detailed trigger phrases in `description`. Add assets under `skills/<skill-name>/assets/` if needed.

5. **Create commands** (if needed) — `commands/<command-name>.md` with YAML frontmatter. The `name` field MUST use the `rcommon:` prefix (e.g., `rcommon:my-command`). The filename omits the prefix.

6. **Create hooks** (if needed) — `hooks/hooks.json` with event-based shell commands. Available events: `PreToolUse`, `PostToolUse`, `Notification`, `Stop`, `SubagentStop`.

7. **Create agents** (if needed) — `agents/<agent-name>.md` with frontmatter specifying `model` and `tools`.

8. **Create MCP servers** (if needed) — `mcp-servers/<server-name>.json` with `type` (stdio/sse), `command`, `args`, and `env`.

9. **Create LSP servers** (if needed) — `lsp-servers/<server-name>.json` with `command`, `args`, and `languages`.

10. **Write README.md** — with title, install command (`/plugin install <name>@rcommon-claude-plugins`), usage examples, components table, and structure tree.

11. **Register in marketplace.json** — add an entry to `.claude-plugin/marketplace.json` at the repo root with `name`, `description`, `source`, `version`, and `category`.

12. **Commit** — stage the new plugin directory and marketplace.json, then commit with a descriptive message.

## Checklist

Before committing, verify:

- [ ] Plugin directory exists at `plugins/<name>/`
- [ ] `.claude-plugin/plugin.json` exists (NOT marketplace.json)
- [ ] `plugin.json` has `name`, `description`, and `version`
- [ ] Plugin name uses `rcommon-` prefix and kebab-case
- [ ] Command names use `rcommon:` prefix in frontmatter `name` field
- [ ] Skills have YAML frontmatter with `name` and `description` including trigger phrases
- [ ] No empty component directories
- [ ] README.md exists with install command
- [ ] Entry added to marketplace.json with matching name, version, and source path
- [ ] All names consistent: directory = plugin.json name = marketplace.json name
