# rcommon-plugin-creator

rCommon marketplace governance plugin — create new plugins and maintain existing ones with correct structure, naming, versioning, and conventions.

## Install

```
/plugin install rcommon-plugin-creator@rcommon-claude-plugins
```

## Usage

### Creating plugins

Use `/rcommon:create-plugin` or ask Claude naturally to create a new plugin. It will follow the rCommon plugin governance rules — gathering requirements, creating the correct directory structure, writing all required files, registering in the marketplace, and committing.

Example prompts:
- "Create a new plugin"
- "Scaffold a plugin for X"
- "Add a plugin to the marketplace"

### Maintaining the marketplace

Use `/rcommon:validate-marketplace` to run a full health check, or ask Claude to perform maintenance — version bumping, manifest sync, or consistency validation.

Example prompts:
- "Bump the version for rcommon-hello-world"
- "Sync the marketplace manifest"
- "Check marketplace consistency"
- "Validate all plugins"

### Publishing

Use `/rcommon:plugin-publish` to validate, commit, and open a pull request. It runs all consistency checks first and only publishes if everything passes. Contributors don't need direct push access — the PR workflow handles review and merging.

## What It Enforces

- Kebab-case naming for all plugins, skills, commands, and directories
- `rcommon-` namespace prefix on all plugin names
- `rcommon:` namespace prefix on all command names
- Correct use of `.claude-plugin/plugin.json` (never `marketplace.json`)
- Full directory structure for all component types (skills, commands, hooks, agents, MCP servers, LSP servers)
- YAML frontmatter with trigger phrases in SKILL.md files
- Registration in the marketplace manifest
- Semver versioning starting at 1.0.0
- Version consistency between plugin.json and marketplace.json

## Components

| Type | Name | Description |
|------|------|-------------|
| Skill | `rcommon-plugin-creator` | Step-by-step instructions for creating correctly-structured plugins |
| Skill | `marketplace-manager` | Version bumping, manifest sync, and consistency validation workflows |
| Command | `/rcommon:create-plugin` | Explicit entry point for the plugin creation workflow |
| Command | `/rcommon:validate-marketplace` | Run all consistency checks and produce a health report |
| Command | `/rcommon:plugin-publish` | Validate, commit, and open a PR to publish changes |
| Hook | `Stop` | Warns if plugin.json was modified without updating marketplace.json |

## Structure

```
rcommon-plugin-creator/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   ├── rcommon-plugin-creator/
│   │   └── SKILL.md
│   └── marketplace-manager/
│       └── SKILL.md
├── commands/
│   ├── create-plugin.md
│   ├── validate-marketplace.md
│   └── plugin-publish.md
└── hooks/
    ├── hooks.json
    └── check-versions.sh
```
