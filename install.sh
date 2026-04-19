#!/usr/bin/env bash
# install.sh — installs or syncs claude-devs to ~/.claude/devs/
#
# Run this after cloning the repo or after making changes to dev files.
# Safe to run multiple times — it overwrites with the current repo contents.

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$REPO_DIR/devs"
TARGET_DIR="$HOME/.claude/devs"

echo "claude-devs install"
echo "  source: $SOURCE_DIR"
echo "  target: $TARGET_DIR"
echo ""

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Copy all dev files
cp "$SOURCE_DIR"/*.md "$TARGET_DIR/"

# Report what was installed
echo "Installed:"
for f in "$SOURCE_DIR"/*.md; do
  echo "  $(basename "$f")"
done

echo ""
echo "Done. Dev files are available at $TARGET_DIR"
echo ""
echo "Usage in Claude Code:"
echo "  @~/.claude/devs/pm.md        <- start here if unsure"
echo "  @~/.claude/devs/<dev>.md     <- invoke any dev by name"
