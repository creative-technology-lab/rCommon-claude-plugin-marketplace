---
name: rcommon:validate-marketplace
description: "Run consistency checks on the rCommon marketplace and produce a health report."
---

# /rcommon:validate-marketplace

Audit the entire rCommon marketplace for correctness. Run all checks below and present a summary health report.

## Prerequisites

Verify the current working directory is inside a clone of the marketplace repo. Check that `.claude-plugin/marketplace.json` exists at the git repo root. If it does not, tell the user they need to be inside the marketplace repo and stop.

## Check 1: Name Consistency

For each inline plugin, verify these three values are identical:

1. The directory name under `plugins/`
2. The `name` field in `plugins/<dir>/.claude-plugin/plugin.json`
3. The `name` field in the matching entry in `.claude-plugin/marketplace.json`

## Check 2: Version Consistency

For each inline plugin, verify that the `version` in `plugin.json` matches the `version` in `marketplace.json`. These MUST be identical.

## Check 3: Source Path Consistency

For each inline plugin entry in marketplace.json, verify:

1. The `source` field equals `"./plugins/<plugin-name>"`
2. The directory actually exists on disk
3. The directory contains `.claude-plugin/plugin.json`

## Check 4: Description Sync (Advisory)

Compare `description` in plugin.json with `description` in marketplace.json. These are allowed to differ (marketplace descriptions can be richer), but flag cases where one is empty or they are wildly different.

## Check 5: Naming Conventions

- [ ] All plugin names use the `rcommon-` prefix
- [ ] All plugin names are kebab-case
- [ ] All skill names in SKILL.md frontmatter are kebab-case
- [ ] All command names use the `rcommon:` prefix in the `name` field

## Check 6: Structural Integrity

For each plugin directory:

- [ ] `.claude-plugin/plugin.json` exists (not `marketplace.json`)
- [ ] `plugin.json` contains `name`, `description`, and `version` fields
- [ ] All `skills/*/SKILL.md` files have YAML frontmatter with `name` and `description`
- [ ] No empty component directories
- [ ] `README.md` exists

## Check 7: Portable Path References

For each plugin that has hooks, MCP servers, or LSP servers:

- [ ] All `hooks.json` commands that reference files within the plugin use `${CLAUDE_PLUGIN_ROOT}` (not relative or hardcoded paths)
- [ ] All MCP server configs that reference plugin-local scripts/files use `${CLAUDE_PLUGIN_ROOT}` in `command` or `args`
- [ ] All LSP server configs that reference plugin-local scripts/files use `${CLAUDE_PLUGIN_ROOT}` in `command` or `args`

Flag any hardcoded absolute paths or bare relative paths (e.g., `./hooks/script.sh`, `hooks/script.sh`) as FAIL.

## Check 8: Orphan Detection

- Directories under `plugins/` without `.claude-plugin/plugin.json`
- SKILL.md files missing YAML frontmatter
- Entries in marketplace.json with no matching directory (for inline plugins)

## Output

Present results as:

```
## Marketplace Health Report

| Check | Status | Details |
|-------|--------|---------|
| Name consistency | PASS/FAIL | ... |
| Version consistency | PASS/FAIL | ... |
| Source paths | PASS/FAIL | ... |
| Description sync | PASS/WARN | ... |
| Naming conventions | PASS/FAIL | ... |
| Structural integrity | PASS/FAIL | ... |
| Portable paths | PASS/FAIL | ... |
| Orphan detection | PASS/WARN | ... |

Total plugins: N
Plugins checked: list
```

Then offer to fix any issues found using the `marketplace-manager` skill workflows (version bumping, manifest sync).
