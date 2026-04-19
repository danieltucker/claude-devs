# claude-devs

This repo contains the canonical source for the claude-devs roster — specialized AI dev personas used in Claude sessions.

## Key commands

**Install / sync everything:**
```bash
bash install.sh
```

This copies `devs/` to `~/.claude/devs/` and `commands/` to `~/.claude/commands/`.

**When the user says "install the devs" or "sync my devs":** run `bash install.sh`.

**When the user edits a dev file in `devs/`:** remind them to run `bash install.sh` to push changes to their local Claude installation.

## Structure

- `devs/` — the dev persona markdown files (canonical source)
- `commands/` — global slash command wrappers (`/pm`, `/senior-dev`, etc.)
- `install.sh` — copies both to `~/.claude/`
- `README.md` — usage and installation instructions

## Adding or editing devs

1. Edit or create the `.md` file in `devs/`
2. Update `devs/README.md` (the roster index) if adding a new dev
3. Update the table in `README.md` if adding a new dev
4. Run `bash install.sh` to sync
