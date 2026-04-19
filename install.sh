#!/usr/bin/env bash
# install.sh — installs or syncs claude-devs to ~/.claude/devs/ and ~/.claude/commands/
#
# Run this after cloning the repo or after making changes to dev files.
# Safe to run multiple times — it overwrites with the current repo contents.

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEVS_SOURCE="$REPO_DIR/devs"
DEVS_TARGET="$HOME/.claude/devs"
COMMANDS_SOURCE="$REPO_DIR/commands"
COMMANDS_TARGET="$HOME/.claude/commands"

echo "claude-devs install"
echo ""

# Install dev files
echo "Dev files: $DEVS_SOURCE -> $DEVS_TARGET"
mkdir -p "$DEVS_TARGET"
cp "$DEVS_SOURCE"/*.md "$DEVS_TARGET/"
for f in "$DEVS_SOURCE"/*.md; do
  echo "  ✓ $(basename "$f")"
done

echo ""

# Install slash commands
echo "Slash commands: $COMMANDS_SOURCE -> $COMMANDS_TARGET"
mkdir -p "$COMMANDS_TARGET"
cp "$COMMANDS_SOURCE"/*.md "$COMMANDS_TARGET/"
for f in "$COMMANDS_SOURCE"/*.md; do
  echo "  ✓ /$(basename "$f" .md)"
done

# Patch ~/.claude/settings.json to allow reading from ~/.claude/devs
SETTINGS_FILE="$HOME/.claude/settings.json"
DEVS_TARGET_JSON="$DEVS_TARGET"

echo "Settings: $SETTINGS_FILE"
if [ -f "$SETTINGS_FILE" ]; then
  # Check if additionalDirectories already contains the devs path
  if ! python3 -c "
import json, sys
data = json.load(open('$SETTINGS_FILE'))
dirs = data.get('permissions', {}).get('additionalDirectories', [])
sys.exit(0 if '$DEVS_TARGET_JSON' in dirs else 1)
" 2>/dev/null; then
    python3 -c "
import json
with open('$SETTINGS_FILE', 'r') as f:
    data = json.load(f)
data.setdefault('permissions', {}).setdefault('additionalDirectories', []).append('$DEVS_TARGET_JSON')
with open('$SETTINGS_FILE', 'w') as f:
    json.dump(data, f, indent=2)
print('  ✓ Added $DEVS_TARGET_JSON to permissions.additionalDirectories')
"
  else
    echo "  ✓ Already present in permissions.additionalDirectories"
  fi
else
  python3 -c "
import json
data = {'permissions': {'additionalDirectories': ['$DEVS_TARGET_JSON']}}
with open('$SETTINGS_FILE', 'w') as f:
    json.dump(data, f, indent=2)
print('  ✓ Created $SETTINGS_FILE with permissions.additionalDirectories')
"
fi

echo ""
echo "Done."
echo ""
echo "Usage in Claude Code:"
echo "  /pm                  <- start here if unsure"
echo "  /senior-dev          <- guide active development"
echo "  /code-review         <- audit existing code"
echo "  /security            <- threat modeling"
echo "  /ui                  <- design and UI review"
echo "  /qa                  <- tests and coverage"
echo "  /devops              <- CI/CD and infrastructure"
echo "  /database            <- schema and queries"
echo "  /api                 <- API design"
echo "  /docs                <- documentation and writing"
echo ""
echo "Pass your request as an argument: /pm I want to build a task app"
