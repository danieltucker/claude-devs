# claude-devs

A roster of specialized AI dev personas for use with Claude. Each dev is a markdown file containing a focused role definition, responsibilities, behavioral guidelines, and example prompts. Reference a dev during a Claude session to get expert-mode behavior for that domain.

## The Team

| Dev | File | Purpose |
|---|---|---|
| Project Manager | `devs/pm.md` | Entry point, planning, triage, routing |
| Senior Dev | `devs/senior-dev.md` | Code guidance, debugging, architecture |
| Code Review | `devs/code-review.md` | Auditing existing code for quality and security |
| Security Architect | `devs/security.md` | Threat modeling, auth design, compliance |
| UI/UX Designer | `devs/ui.md` | Interface design and frontend implementation |
| QA / Testing | `devs/qa.md` | Test strategy, writing tests, coverage |
| DevOps Engineer | `devs/devops.md` | CI/CD, infrastructure, deployments |
| Database Architect | `devs/database.md` | Schema design, queries, migrations |
| API Designer | `devs/api.md` | REST/GraphQL design, OpenAPI specs |
| Docs & Writing | `devs/docs.md` | Technical docs, copy editing, changelogs |

**Not sure who to ask? Start with PM — it will route you.**

---

## Installation

Installing copies the dev files to `~/.claude/devs/` so they're available globally in Claude Code (CLI and VS Code).

### Automatic (via Claude)

Open this repo in Claude Code and say:

> Install the devs

Claude will run the install script for you.

### Manual — Windows (PowerShell)

```powershell
.\install.ps1
```

If you get an execution policy error, run this once first:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Manual — Mac / Linux (bash)

```bash
bash install.sh
```

---

## Where This Works

| Feature | Claude Code CLI | Claude Code VS Code | Claude.ai web | Claude.ai app |
|---|:---:|:---:|:---:|:---:|
| Slash commands (`/pm`, etc.) | ✓ | ✓ | ✗ | ✗ |
| `@` file references | ✓ | ✓ | ✗ | ✗ |
| Dev files via Project upload | ✗ | ✗ | ✓ | ✓ |

Slash commands and `@` references are **Claude Code features** — they work in both the CLI and the VS Code extension, but not on the web or mobile app. For Claude.ai, use the Project approach instead.

---

## Usage

### Claude Code (CLI or VS Code) — slash commands

After installing, invoke any dev with a slash command:

```
/pm I have a new project idea — where do I start?
/code-review Review the auth module in src/auth/
/security Threat model the user data flow in this app
/ui Here's my dashboard — what should be improved?
/senior-dev This function is returning undefined intermittently...
```

The slash command loads the full dev persona and passes your message to it. No path required.

You can also use `@` references directly if you prefer, or need to load a dev mid-conversation:

```
@~/.claude/devs/pm.md
```

### Claude.ai (web / app)

1. Create a **Project** in Claude.ai
2. Upload the relevant dev files from `devs/`, or paste their contents into the Project instructions
3. The devs will be available for all conversations in that Project

---

## Syncing Changes

After editing dev files in this repo, push the changes to your local Claude installation.

**Windows (PowerShell):**
```powershell
.\install.ps1
```

**Mac / Linux (bash):**
```bash
bash install.sh
```

This overwrites `~/.claude/devs/` and `~/.claude/commands/` with the current contents of the repo. Run it any time after making changes.

### Via Claude

You can also ask Claude to sync from within this repo:

> Sync my devs from the repo

Claude will run the appropriate script.

---

## Adding a New Dev

1. Create a new `.md` file in `devs/` using the structure of an existing dev as a template
2. Create a matching `.md` file in `commands/` following the same pattern as the existing command files
3. Add the new dev to the table in `devs/README.md`
4. Add the new dev to the table in this `README.md`
5. Sync: `.\install.ps1` (Windows) or `bash install.sh` (Mac/Linux)

---

## Structure of a Dev File

Each dev file follows this structure:

```
# [Dev Name]

## Role
Who this dev is and what makes them distinctive.

## Responsibilities
Bullet list of what they do.

## When to Use This Dev
Situations that call for this dev.

## How to Engage
What to provide when invoking this dev.

## [Approach / Principles]  ← varies by dev
Domain-specific methodology.

## Output Format
How output adapts to different request types.

## Constraints
What this dev will not do (important for keeping roles clean).

## Collaboration
When and where to route to other devs.

## Example Prompts
Concrete, realistic invocation examples.
```
