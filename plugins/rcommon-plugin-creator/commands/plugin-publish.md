---
name: rcommon:plugin-publish
description: "Validate the marketplace, commit changes, and push to publish plugins."
---

# /rcommon:plugin-publish

Validate, commit, and push changes to the rCommon plugin marketplace.

## Prerequisites

Verify the current working directory is inside a clone of the marketplace repo. Check that `.claude-plugin/marketplace.json` exists at the git repo root. If it does not, tell the user they need to be inside the marketplace repo and stop.

## Step 1: Run Validation

Run all 7 consistency checks from `/rcommon:validate-marketplace`:

1. Name consistency (directory = plugin.json = marketplace.json)
2. Version consistency (plugin.json version = marketplace.json version)
3. Source path consistency
4. Description sync (advisory)
5. Naming conventions (`rcommon-` prefix, `rcommon:` command prefix, kebab-case)
6. Structural integrity (plugin.json exists, SKILL.md has frontmatter, README exists, no empty dirs)
7. Orphan detection

Present the health report table.

## Step 2: Stop on Failure

If ANY check has status **FAIL**, stop here. Show the failures and offer to fix them. Do NOT proceed to commit or push.

If all checks are PASS (WARN is acceptable), continue.

## Step 3: Check for Changes

Run `git status`. If there are no uncommitted changes and the branch is up to date with the remote, inform the user there is nothing to publish and stop.

## Step 4: Commit

If there are uncommitted changes:

1. Run `git diff --staged` and `git diff` to review what will be committed
2. Show the user a summary of changes (which plugins were added, modified, or removed)
3. Stage all relevant files: plugin directories and marketplace.json
4. Commit with a descriptive message summarising the changes

## Step 5: Create a Branch and Push

Create a feature branch and push it:

```
git checkout -b <branch-name>
git push -u origin <branch-name>
```

Use a descriptive branch name based on the changes, e.g.:
- `add-rcommon-my-new-plugin` for new plugins
- `update-rcommon-hello-world` for plugin updates
- `marketplace-maintenance` for general fixes

If the user is already on a feature branch (not `main`), skip branch creation and just push.

## Step 6: Open a Pull Request

Use `gh pr create` to open a pull request against `main`:

```
gh pr create --title "<title>" --body "<body>"
```

The PR body should include:
- Summary of what changed (plugins added, updated, or removed)
- The health report table from Step 1
- Install commands for any new plugins

## Step 7: Confirm

Report success with the PR URL:

```
Pull request created: <PR URL>

Once merged, users can update with:
  /plugin marketplace update rcommon-claude-plugins

New plugins can be installed with:
  /plugin install <plugin-name>@rcommon-claude-plugins
```
