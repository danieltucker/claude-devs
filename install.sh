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
