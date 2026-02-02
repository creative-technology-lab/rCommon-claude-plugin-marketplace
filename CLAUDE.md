# rCommon Claude Plugin Marketplace

## Quick Reference

| Key | Value |
|-----|-------|
| Marketplace name | `rcommon-claude-plugins` |
| GitHub org | `creative-technology-lab` |
| Repo URL | `https://github.com/creative-technology-lab/rCommon-claude-plugin-marketplace.git` |
| Install pattern | `/plugin install <name>@rcommon-claude-plugins` |
| Update command | `/plugin marketplace update rcommon-claude-plugins` |
| Plugin prefix | `rcommon-` |
| Command prefix | `rcommon:` |

## Purpose

This marketplace holds **common plugins** shared across all Claude Code marketplaces (CTL, Grexr, Seeper, etc.). Plugins here are foundational tools that every marketplace needs — governance, utilities, and shared workflows.

## Critical Rules

1. **plugin.json, not marketplace.json** — plugins use `.claude-plugin/plugin.json`. Using `marketplace.json` inside a plugin causes Claude to treat it as another marketplace.
2. **Version consistency** — the `version` in `plugin.json` MUST match the `version` in the marketplace root `.claude-plugin/marketplace.json`.
3. **YAML frontmatter required** — all `SKILL.md` files need `---` delimited frontmatter with `name` and `description` (including trigger phrases).
4. **Name consistency** — the plugin directory name, `plugin.json` name, and `marketplace.json` entry name must all match.
5. **Semver versioning** — `major.minor.patch`. Major for breaking changes, minor for new features, patch for fixes.
6. **README required** — every plugin needs a `README.md` with install command and usage.
7. **No empty directories** — only create component directories the plugin actually uses.

## Versioning Rules

| Change Type | Bump | Examples |
|-------------|------|---------|
| Breaking changes | Major (X.0.0) | Renamed skills, removed commands, changed fundamental behavior |
| New features | Minor (x.Y.0) | Added skills, commands, agents, new capabilities |
| Fixes and tweaks | Patch (x.y.Z) | Typo fixes, wording improvements, bug fixes |

## Workflow

1. **Create** — `/rcommon:create-plugin` to scaffold a new plugin
2. **Validate** — `/rcommon:validate-marketplace` to check consistency
3. **Publish** — `/rcommon:plugin-publish` to validate, commit, and open a PR

## Current Plugins

| Plugin | Version | Category |
|--------|---------|----------|
| rcommon-plugin-creator | 1.0.0 | tooling |
