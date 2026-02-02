---
name: marketplace-manager
description: "Use this skill when asked to maintain, update, validate, or sync the rCommon plugin marketplace. Triggers on requests like 'bump the plugin version', 'sync the marketplace manifest', 'check marketplace consistency', 'validate plugins', 'update the marketplace', 'marketplace maintenance', 'fix plugin versions', 'are all plugins in sync', or 'check plugin health'. This skill is for MAINTENANCE of existing plugins — for CREATING new plugins, use the rcommon-plugin-creator skill instead."
---

# Marketplace Manager

Maintain the rCommon plugin marketplace: version bumping, manifest sync, and consistency validation.

## When This Skill Applies

- User asks to bump a plugin version after making changes
- User asks to sync or update the marketplace manifest
- User asks to check consistency or validate plugins
- User asks to do general marketplace maintenance
- User mentions fixing version mismatches or stale manifest entries

## When This Skill Does NOT Apply

- User wants to **create a new plugin** — use the `rcommon-plugin-creator` skill instead
- User wants to install or uninstall a plugin — that is a Claude Code built-in (`/plugin install`)
- User wants to publish or push to GitHub — that is a git/GitHub operation, not a marketplace maintenance task

---

## Workflow 1: Version Bumping

Use this workflow when a plugin's files have been modified and its version needs to be updated.

### Step 1: Identify What Changed

Examine the git diff or the user's description to understand what changed in the plugin. Run:

```
git diff --name-only
```

Or if the user specifies a plugin name, look at recent changes in `plugins/<plugin-name>/`.

### Step 2: Determine the Version Bump Type

Apply these semver rules:

| Change Type | Bump | Examples |
|-------------|------|----------|
| **Breaking changes** to skill behavior, renamed skills/commands, removed components, changed trigger phrases in ways that break existing usage | **Major** (X.0.0) | Renaming a skill, removing a command, changing the fundamental behavior of what the skill does |
| **New features** — added skills, commands, agents, MCP tools, new capabilities, significant content additions | **Minor** (x.Y.0) | Adding a new command to a plugin, adding a new MCP tool, adding a new skill, substantial new content in SKILL.md |
| **Fixes and minor tweaks** — typo fixes, wording improvements, bug fixes, small content updates, asset updates | **Patch** (x.y.Z) | Fixing a typo in SKILL.md, updating an asset file, minor wording changes, fixing a broken command |

When in doubt, prefer **minor** over **patch** for content changes, and **patch** over **minor** for fixes.

### Step 3: Update plugin.json

Read the current version from `plugins/<plugin-name>/.claude-plugin/plugin.json` and bump it:

```json
{
  "name": "<plugin-name>",
  "description": "<unchanged>",
  "version": "<new-version>"
}
```

### Step 4: Update marketplace.json

Read `.claude-plugin/marketplace.json` at the repo root. Find the entry where `"name"` matches the plugin name and update its `"version"` field to match the new version from plugin.json.

**CRITICAL**: The version in marketplace.json MUST always match the version in plugin.json. These two are the only places versions are tracked.

### Step 5: Verify and Commit

After updating both files, verify:

- [ ] `plugin.json` version matches `marketplace.json` version for this plugin
- [ ] No other plugin entries were accidentally modified
- [ ] The version bump type makes sense for the changes

Commit with a message following the repo convention:

```
git add plugins/<plugin-name>/.claude-plugin/plugin.json .claude-plugin/marketplace.json
git commit -m "Bump <plugin-name> to <new-version>: <brief reason>"
```

---

## Workflow 2: Manifest Sync

Use this workflow after adding or removing plugin directories to ensure marketplace.json reflects what is on disk.

### Step 1: Inventory Plugins on Disk

List all plugin directories:

```
ls plugins/
```

Each directory under `plugins/` that contains `.claude-plugin/plugin.json` is a valid plugin.

### Step 2: Read the Current Manifest

Read `.claude-plugin/marketplace.json` and extract the list of plugin names from the `plugins` array.

### Step 3: Compare and Report

Identify:

1. **Plugins on disk but NOT in marketplace.json** — these need to be added
2. **Plugins in marketplace.json but NOT on disk** — these need to be removed (unless they are external plugins with a URL source)
3. **Plugins present in both** — these are fine (but check consistency in Workflow 3)

For inline plugins, the `source` field is a relative path like `"./plugins/<plugin-name>"`. For external plugins, `source` is an object with a `url` field. Only inline plugins should have a matching directory on disk.

### Step 4: Add Missing Entries

For each plugin on disk that is missing from marketplace.json, read its `plugin.json` and add an entry:

```json
{
  "name": "<from plugin.json name>",
  "description": "<from plugin.json description>",
  "source": "./plugins/<directory-name>",
  "version": "<from plugin.json version>",
  "category": "<ask the user or infer from the plugin's purpose>"
}
```

**IMPORTANT**: The `category` field is not in plugin.json — it only exists in marketplace.json. If adding a new entry, ask the user what category to use. Existing categories in this marketplace: `demo`, `branding`, `tooling`, `productivity`.

### Step 5: Remove Stale Entries

For each inline plugin in marketplace.json that has no matching directory on disk, remove its entry from the `plugins` array.

**Do NOT remove entries with a URL-based source** — those are external plugins and do not have local directories.

### Step 6: Commit

```
git add .claude-plugin/marketplace.json
git commit -m "Sync marketplace.json with plugins on disk"
```

---

## Workflow 3: Consistency Validation

Use this workflow to audit the entire marketplace for correctness. Run all checks and report a summary.

### Check 1: Name Consistency

For each inline plugin, verify that these three values are identical:

1. The directory name under `plugins/`
2. The `name` field in `plugins/<dir>/.claude-plugin/plugin.json`
3. The `name` field in the corresponding entry in `.claude-plugin/marketplace.json`

Report any mismatches.

### Check 2: Version Consistency

For each inline plugin, verify:

1. The `version` in `plugins/<dir>/.claude-plugin/plugin.json`
2. The `version` in the corresponding entry in `.claude-plugin/marketplace.json`

These MUST match. Report any mismatches.

### Check 3: Source Path Consistency

For each inline plugin entry in marketplace.json, verify:

1. The `source` field equals `"./plugins/<plugin-name>"`
2. The directory `plugins/<plugin-name>/` actually exists on disk
3. The directory contains `.claude-plugin/plugin.json`

Report any broken paths or missing directories.

### Check 4: Description Sync (Advisory)

For each inline plugin, compare:

1. The `description` in plugin.json
2. The `description` in marketplace.json

These do NOT need to be identical (marketplace.json descriptions can be more detailed for discovery), but flag cases where they are wildly different or where one is empty.

### Check 5: Naming Conventions

Verify that all plugins follow rCommon conventions:

- [ ] All plugin names use the `rcommon-` prefix
- [ ] All plugin names are kebab-case
- [ ] All skill names in SKILL.md frontmatter are kebab-case
- [ ] All command names in command files use the `rcommon:` prefix in the `name` field

### Check 6: Structural Integrity

For each plugin directory, verify:

- [ ] `.claude-plugin/plugin.json` exists (not `marketplace.json`)
- [ ] `plugin.json` contains `name`, `description`, and `version` fields
- [ ] All `skills/*/SKILL.md` files have YAML frontmatter with `name` and `description`
- [ ] No empty component directories exist (no empty `skills/`, `commands/`, etc.)
- [ ] `README.md` exists in the plugin root

### Check 7: Orphan Detection

- Check for directories under `plugins/` that do NOT have `.claude-plugin/plugin.json` — these are not valid plugins
- Check for SKILL.md files that are missing YAML frontmatter — these will not be matched by Claude

### Output Format

Present the results as a summary table:

```
## Marketplace Health Report

| Check | Status | Details |
|-------|--------|---------|
| Name consistency | PASS/FAIL | <details if FAIL> |
| Version consistency | PASS/FAIL | <details if FAIL> |
| Source paths | PASS/FAIL | <details if FAIL> |
| Description sync | PASS/WARN | <details if WARN> |
| Naming conventions | PASS/FAIL | <details if FAIL> |
| Structural integrity | PASS/FAIL | <details if FAIL> |
| Orphan detection | PASS/WARN | <details if WARN> |

Total plugins: <N>
Plugins checked: <list>
```

Then offer to fix any issues found, using Workflow 1 (version bumping) or Workflow 2 (manifest sync) as appropriate.

---

## Reference: Marketplace Structure

### marketplace.json Location

```
.claude-plugin/marketplace.json    (repo root — the marketplace manifest)
```

### Plugin Location

```
plugins/<plugin-name>/.claude-plugin/plugin.json    (individual plugin metadata)
```

### Key Fields

**marketplace.json entry (inline plugin):**

```json
{
  "name": "<kebab-case, rcommon- prefix>",
  "description": "<discovery description>",
  "source": "./plugins/<plugin-name>",
  "version": "<semver, must match plugin.json>",
  "category": "<demo|branding|tooling|productivity|automation>"
}
```

**plugin.json:**

```json
{
  "name": "<kebab-case, must match directory name>",
  "description": "<plugin description>",
  "version": "<semver>"
}
```

### Version Is Tracked in Two Places Only

1. `plugins/<name>/.claude-plugin/plugin.json` — the source of truth
2. `.claude-plugin/marketplace.json` — must mirror the plugin.json version

There is no version field in SKILL.md frontmatter. Always treat plugin.json as the source of truth.
