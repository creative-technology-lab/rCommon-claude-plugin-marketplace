---
name: rcommon-plugin-creator
description: "Use this skill when asked to create, scaffold, or add a new plugin to the rCommon marketplace. Triggers on requests like 'create a new plugin', 'scaffold a plugin', 'add a plugin to the marketplace', 'new rCommon plugin', or 'make a plugin for X'. This skill MUST be followed exactly to ensure plugins conform to rCommon governance."
---

# rCommon Plugin Creator

Create new plugins for the rCommon marketplace that conform to all structural and naming conventions.

## When This Skill Applies

- User asks to create, scaffold, or add a new plugin
- User wants to add a new skill, command, hook, agent, or MCP server to the rCommon marketplace
- User mentions creating something that should be distributed via the marketplace

## Step 1: Gather Requirements

Before creating anything, ask the user for:

1. **Plugin name** — must be kebab-case with the `rcommon-` prefix (e.g., `rcommon-my-cool-tool`). This is the directory name and the `name` field in plugin.json.
2. **Plugin description** — one sentence describing what the plugin does.
3. **What the plugin contains** — which of the following does it need:
   - **Skills** — contextual knowledge and instructions Claude reads when matched (SKILL.md files)
   - **Commands** — slash commands users invoke explicitly (e.g., `/my-command`)
   - **Hooks** — shell commands that run automatically on events (pre/post tool use, notification, etc.)
   - **Agents** — custom agent configurations with specific models, tools, and instructions
   - **MCP Servers** — Model Context Protocol servers providing tools, resources, or prompts
   - **LSP Servers** — Language Server Protocol servers for code intelligence
4. **Category** — one of: `demo`, `branding`, `tooling`, `productivity`, `automation`, or suggest a new one.
5. **Inline or external?** — inline lives in this repo under `plugins/`; external lives in its own GitHub repo under `creative-technology-lab/`.

## Step 2: Create the Plugin Directory

All inline plugins live under `plugins/` in this marketplace repo. Create the full directory structure based on what the plugin contains:

```
plugins/<plugin-name>/
├── .claude-plugin/
│   └── plugin.json
├── skills/                     # Contextual knowledge and instructions
│   └── <skill-name>/
│       ├── SKILL.md
│       └── assets/             (only if needed)
├── commands/                   # Slash commands
│   └── <command-name>.md
├── hooks/                      # Event-driven shell commands
│   └── hooks.json
├── agents/                     # Custom agent configurations
│   └── <agent-name>.md
├── mcp-servers/                # MCP server definitions
│   └── <server-name>.json
└── lsp-servers/                # LSP server definitions
    └── <server-name>.json
```

Only create the directories the plugin actually needs — omit empty ones.

### Rules

- The plugin directory name MUST match the `name` field in plugin.json.
- The `.claude-plugin/` directory MUST contain `plugin.json` — **NEVER** `marketplace.json`. Using `marketplace.json` causes Claude to treat the plugin as another marketplace and the plugin will not be detected.
- All component directories (`skills/`, `commands/`, `hooks/`, `agents/`, `mcp-servers/`, `lsp-servers/`) sit directly under the plugin root.
- Skills MUST be at `skills/<skill-name>/SKILL.md` — never nested deeper.
- If the plugin has multiple skills, each gets its own directory: `skills/<skill-1>/SKILL.md`, `skills/<skill-2>/SKILL.md`, etc.

## Step 3: Write plugin.json

Create `.claude-plugin/plugin.json` with exactly this structure:

```json
{
  "name": "<plugin-name>",
  "description": "<one-sentence description of the plugin>",
  "version": "1.0.0"
}
```

### Rules

- `name` must be kebab-case and match the directory name.
- `description` should summarise the plugin as a whole (not individual components).
- `version` follows semver. Start at `1.0.0`.

## Step 4: Create Skills (if needed)

Create `skills/<skill-name>/SKILL.md` with YAML frontmatter and markdown body:

```markdown
---
name: <skill-name>
description: "<Detailed description of when to use this skill. Include specific trigger phrases the user might say. Be explicit — Claude matches skills based on this description.>"
---

# <Skill Title>

<Brief overview of what this skill does.>

## When This Skill Applies

<Bullet list of trigger conditions.>

## Instructions

<Step-by-step instructions for Claude to follow when this skill is triggered.>

## Assets

<Table of asset files if applicable, with relative paths from the SKILL.md location.>

| Asset | Path |
|-------|------|
| ... | `assets/...` |
```

### Rules

- `name` in frontmatter must be kebab-case and match the skill directory name.
- `description` in frontmatter is the primary mechanism Claude uses to decide when to invoke the skill. Make it detailed and include trigger phrases like "Use when the user asks to...", "Triggers on requests like '...'".
- The markdown body provides the detailed instructions Claude follows once the skill is matched.
- Reference assets using relative paths from the skill directory (e.g., `assets/logo.png`).

### Assets

If the skill needs assets (reference docs, images, templates, config files), place them in `skills/<skill-name>/assets/`:

```
skills/<skill-name>/
└── assets/
    ├── <file>.md
    ├── <file>.json
    └── images/
        └── <image>.png
```

## Step 5: Create Commands (if needed)

Commands are slash commands the user invokes explicitly (e.g., `/rcommon:deploy`, `/rcommon:lint`).

Create `commands/<command-name>.md`:

```markdown
---
name: rcommon:<command-name>
description: "<What this command does — shown in the command palette.>"
---

# /rcommon:<command-name>

<Instructions for Claude when this command is invoked.>
```

### Rules

- Command names are kebab-case without the leading `/`.
- **Commands MUST be namespaced** with the marketplace prefix `rcommon:` in the `name` field (e.g., `rcommon:submit-timesheet`). This prevents collisions with commands from other marketplaces.
- The filename does NOT include the namespace — use `commands/submit-timesheet.md`, not `commands/rcommon:submit-timesheet.md`.
- The `description` appears in the slash command palette, so keep it concise.
- Commands can accept arguments — document expected arguments in the body.

## Step 6: Create Hooks (if needed)

Hooks are shell commands that run automatically in response to events.

Create `hooks/hooks.json`:

```json
{
  "hooks": {
    "<event-name>": [
      {
        "command": "<shell command to run>",
        "description": "<what this hook does>"
      }
    ]
  }
}
```

### Available Events

| Event | When it fires |
|-------|---------------|
| `PreToolUse` | Before a tool is executed |
| `PostToolUse` | After a tool completes |
| `Notification` | When Claude produces a notification |
| `Stop` | When Claude finishes a response |
| `SubagentStop` | When a subagent finishes |

### Rules

- Hook commands run as shell processes — they must be executable.
- Hooks can block tool execution (PreToolUse) by returning a non-zero exit code.
- Keep hooks fast — they run synchronously and block Claude.
- Use `description` to explain what the hook does and why.

## Step 7: Create Agents (if needed)

Agents are custom agent configurations with specific models, tools, and system prompts.

Create `agents/<agent-name>.md`:

```markdown
---
name: <agent-name>
description: "<When to use this agent.>"
model: <model-id>
tools:
  - <tool-1>
  - <tool-2>
---

# <Agent Name>

<System prompt and instructions for this agent.>
```

### Rules

- Agent names are kebab-case.
- Specify the model if the agent needs a specific one (e.g., `claude-sonnet-4-20250514`).
- List the tools the agent should have access to.

## Step 8: Create MCP Servers (if needed)

MCP servers provide tools, resources, and prompts to Claude via the Model Context Protocol.

Create `mcp-servers/<server-name>.json`:

```json
{
  "name": "<server-name>",
  "type": "<stdio|sse>",
  "command": "<command to start the server>",
  "args": ["<arg1>", "<arg2>"],
  "env": {
    "<ENV_VAR>": "<value>"
  },
  "description": "<What this MCP server provides.>"
}
```

### Rules

- Use `stdio` type for local process-based servers.
- Use `sse` type for HTTP-based servers.
- Include all required environment variables.
- The `command` must be available on the user's PATH or be a full path.

## Step 9: Create LSP Servers (if needed)

LSP servers provide code intelligence (completions, diagnostics, hover info).

Create `lsp-servers/<server-name>.json`:

```json
{
  "name": "<server-name>",
  "command": "<command to start the LSP server>",
  "args": ["<arg1>", "<arg2>"],
  "languages": ["<language-id>"],
  "description": "<What this LSP server provides.>"
}
```

### Rules

- Specify which languages the server supports.
- The command must be installed on the user's system.

## Step 10: Register in marketplace.json

Read the current `.claude-plugin/marketplace.json` at the repo root and add a new entry to the `plugins` array.

### For inline plugins:

```json
{
  "name": "<plugin-name>",
  "description": "<description matching or summarising the plugin>",
  "source": "./plugins/<plugin-name>",
  "version": "1.0.0",
  "category": "<category>"
}
```

### For external plugins:

```json
{
  "name": "<plugin-name>",
  "description": "<description>",
  "source": {
    "source": "url",
    "url": "https://github.com/creative-technology-lab/<repo-name>.git"
  },
  "homepage": "https://github.com/creative-technology-lab/<repo-name>"
}
```

### Rules

- The `name` must match the plugin directory name and the `name` in plugin.json.
- Use full HTTPS git URLs for external plugins (not GitHub shorthand like `owner/repo`).
- External plugin repos are always under the `creative-technology-lab` GitHub org.
- Include `category` for inline plugins to aid discovery.

## Step 11: Commit

After creating all files, commit the changes with a descriptive message:

```
git add plugins/<plugin-name>/ .claude-plugin/marketplace.json
git commit -m "Add <plugin-name> plugin: <short description>"
```

## Common Mistakes to Avoid

| Mistake | Consequence | Fix |
|---------|-------------|-----|
| Using `marketplace.json` instead of `plugin.json` in the plugin | Claude treats the plugin as another marketplace; skills are not detected | Always use `.claude-plugin/plugin.json` |
| Nesting skills under `plugins/<name>/plugins/<name>/skills/` | Claude cannot find the skills | Skills go directly under the plugin root: `plugins/<name>/skills/` |
| Using GitHub shorthand (`owner/repo`) for external sources | Private repos fail to authenticate | Use full HTTPS URL: `https://github.com/creative-technology-lab/<repo>.git` |
| Forgetting YAML frontmatter in SKILL.md | Claude cannot match or invoke the skill | Always include `---` delimited frontmatter with `name` and `description` |
| Mismatched names between directory, plugin.json, and marketplace.json | Plugin registration breaks | All three must use the exact same kebab-case name |
| Plugin name missing `rcommon-` prefix | Collides with plugins from other marketplaces | Always prefix plugin names with `rcommon-` |
| Adding version to SKILL.md frontmatter but not plugin.json | Inconsistent versioning | Keep version in plugin.json as the source of truth |
| Creating empty directories for unused components | Unnecessary clutter | Only create directories the plugin actually uses |
| Command name missing `rcommon:` prefix | Collides with commands from other marketplaces | Always use `rcommon:<command-name>` in the `name` field |

## rCommon Conventions

- **Marketplace name**: `rcommon-claude-plugins`
- **GitHub org**: `creative-technology-lab`
- **Marketplace repo**: `https://github.com/creative-technology-lab/rCommon-claude-plugin-marketplace.git`
- **Install command pattern**: `/plugin install <plugin-name>@rcommon-claude-plugins`
- **Update command**: `/plugin marketplace update rcommon-claude-plugins`
- **Plugin namespace**: All plugin names MUST use the `rcommon-` hyphen prefix (e.g., `rcommon-hello-world`). This prevents collisions with plugins from other marketplaces.
- **Command namespace**: All commands MUST use the `rcommon:` colon prefix (e.g., `rcommon:submit-timesheet`). The filename omits the prefix.
- **Naming**: Always kebab-case for plugin names, skill names, command names, and directory names
- **Versioning**: Semver (`major.minor.patch`), start at `1.0.0`

## Checklist

Before committing, verify:

- [ ] Plugin directory exists at `plugins/<name>/`
- [ ] `.claude-plugin/plugin.json` exists (NOT marketplace.json)
- [ ] `plugin.json` has `name`, `description`, and `version`
- [ ] Only directories for components the plugin actually uses are created
- [ ] Skills: `skills/<skill-name>/SKILL.md` with YAML frontmatter including trigger phrases
- [ ] Commands: `commands/<command-name>.md` with YAML frontmatter and `rcommon:` namespace prefix in `name`
- [ ] Hooks: `hooks/hooks.json` with valid event names
- [ ] Agents: `agents/<agent-name>.md` with model and tools specified
- [ ] MCP Servers: `mcp-servers/<server-name>.json` with type and command
- [ ] LSP Servers: `lsp-servers/<server-name>.json` with languages
- [ ] Entry added to `.claude-plugin/marketplace.json`
- [ ] All names are kebab-case and consistent across files
- [ ] No `marketplace.json` inside the plugin directory
- [ ] No empty directories
