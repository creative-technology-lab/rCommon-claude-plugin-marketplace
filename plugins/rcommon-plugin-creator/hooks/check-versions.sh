#!/usr/bin/env bash
# check-versions.sh — Advisory hook for rcommon-plugin-creator
# Warns if plugin.json files were modified without updating marketplace.json.
# Only runs when the current directory is inside a marketplace repo.
# Always exits 0 (non-blocking).

set -euo pipefail

# Find the repo root
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || exit 0

# Only run if this is a marketplace repo (has .claude-plugin/marketplace.json at root)
if [ ! -f "$REPO_ROOT/.claude-plugin/marketplace.json" ]; then
  exit 0
fi

cd "$REPO_ROOT"

# Check for modified plugin.json files (staged or unstaged)
CHANGED_PLUGINS="$(git diff --name-only HEAD -- 'plugins/*/.claude-plugin/plugin.json' 2>/dev/null)"
if [ -z "$CHANGED_PLUGINS" ]; then
  CHANGED_PLUGINS="$(git diff --cached --name-only -- 'plugins/*/.claude-plugin/plugin.json' 2>/dev/null)"
fi

# If no plugin.json files changed, nothing to check
if [ -z "$CHANGED_PLUGINS" ]; then
  exit 0
fi

# Check if marketplace.json was also modified
MANIFEST_CHANGED="$(git diff --name-only HEAD -- '.claude-plugin/marketplace.json' 2>/dev/null)"
if [ -z "$MANIFEST_CHANGED" ]; then
  MANIFEST_CHANGED="$(git diff --cached --name-only -- '.claude-plugin/marketplace.json' 2>/dev/null)"
fi

if [ -z "$MANIFEST_CHANGED" ]; then
  echo "[rcommon-plugin-creator] Warning: plugin.json was modified but marketplace.json was not — remember to sync versions."
  echo "  Modified: $CHANGED_PLUGINS"
  echo "  Run /rcommon:validate-marketplace to check consistency."
fi

exit 0
