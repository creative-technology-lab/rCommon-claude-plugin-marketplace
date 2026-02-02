# rCommon Claude Plugin Marketplace

Common plugins shared across all Claude Code marketplaces. Contains foundational tools like plugin governance, marketplace management, and other reusable utilities.

## Setup

### 1. Add the marketplace

```
/plugin marketplace add https://github.com/creative-technology-lab/rCommon-claude-plugin-marketplace.git
```

### 2. Install plugins

```
/plugin install rcommon-plugin-creator@rcommon-claude-plugins
```

### 3. Update

```
/plugin marketplace update rcommon-claude-plugins
```

## Plugins

| Plugin | Version | Category | Description |
|--------|---------|----------|-------------|
| rcommon-plugin-creator | 1.0.0 | tooling | Marketplace governance: create, validate, and publish plugins |

## Naming Conventions

| Aspect | Convention | Example |
|--------|-----------|---------|
| Plugin names | `rcommon-` prefix, kebab-case | `rcommon-plugin-creator` |
| Skill names | kebab-case | `rcommon-plugin-creator` |
| Command names | `rcommon:` prefix | `rcommon:create-plugin` |
| Directory names | kebab-case | `plugins/rcommon-plugin-creator/` |

## Structure

```
rCommon-claude-plugin-marketplace/
├── .claude-plugin/
│   └── marketplace.json          # Central plugin registry
├── plugins/
│   └── rcommon-plugin-creator/   # Governance plugin
├── README.md
└── CLAUDE.md
```

## Contributing

1. Clone the repo
2. Use `/rcommon:create-plugin` to scaffold a new plugin
3. Use `/rcommon:validate-marketplace` to check consistency
4. Use `/rcommon:plugin-publish` to validate, commit, and open a PR

## Authentication

This is a private repository. Ensure you have access via:

- **GitHub CLI**: `gh auth login`
- **SSH**: Use the `github-ctl` SSH alias configured in `~/.ssh/config`
