# claude-devs — Cognigy Edition

A roster of specialized AI dev personas for Cognigy conversational AI agent development. Built on the base claude-devs framework, this branch extends it with Cognigy-specific personas and deep reference files covering the Cognigy platform, export schema, node types, context variables, and design patterns.

**Not sure who to ask? Start with `/cognigy-pm` — it will route you.**

---

## Cognigy Dev Team

| Dev | Slash Command | Purpose |
|---|---|---|
| Cognigy PM | `/cognigy-pm` | Entry point, planning, flow design, naming, routing |
| Cognigy Senior Dev | `/cognigy-senior-dev` | Build flows, implement nodes, write Code node JS, AI agent configs |
| Cognigy Code Review | `/cognigy-code-review` | Audit flows, node configs, and Code node JS |
| Cognigy Prompt Analyst | `/cognigy-prompt-analyst` | Diagnose LLM behavior, detect prompt conflicts, explain unexpected outputs |
| Cognigy Security | `/cognigy-security` | Audit agents for vulnerabilities, PII exposure, prompt injection |
| Cognigy API Designer | `/cognigy-api` | HTTP connections, tool parameter schemas, external API integration |
| Cognigy QA | `/cognigy-qa` | Test flows, intent coverage, NLU accuracy, edge cases |
| Cognigy Docs | `/cognigy-docs` | Generate documentation from agent exports |

## General Dev Team

General-purpose devs also included for work outside the Cognigy platform.

| Dev | Slash Command | Purpose |
|---|---|---|
| Project Manager | `/pm` | Entry point, planning, triage, routing |
| Senior Dev | `/senior-dev` | Code guidance, debugging, architecture |
| Code Review | `/code-review` | Auditing existing code for quality and security |
| Security Architect | `/security` | Threat modeling, auth design, compliance |
| QA / Testing | `/qa` | Test strategy, writing tests, coverage |
| API Designer | `/api` | REST/GraphQL design, OpenAPI specs |
| Docs & Writing | `/docs` | Technical docs, copy editing, changelogs |
| Prompt Engineer | `/prompt-eng` | Prompt design, diagnosis, iteration, output format control |

---

## Cognigy Reference Files

Deep-reference files loaded by the Cognigy devs — also useful to load directly for raw platform reference.

| File | Contents |
|---|---|
| `cognigy-README.md` | Platform overview, team roster, architecture, data flow |
| `cognigy-export-schema.md` | Export package structure, file schemas, ID system, navigation guide |
| `cognigy-nodes.md` | All node types with config schemas and usage guidance |
| `cognigy-context-vars.md` | `input.*` / `context.*` / `profile.*` hierarchy, naming conventions, Code node API |
| `cognigy-patterns.md` | Design patterns: RAG, tool calling, flow composition, error handling |

---

## Installation

Installing copies dev files to `~/.claude/devs/` and commands to `~/.claude/commands/` — available globally in Claude Code.

> **Note**: The install script adds files but does not remove files already in `~/.claude/devs/`. If you have the base claude-devs branch installed alongside this one, both sets of devs will coexist — they use different prefixes (`cognigy-`) and will not conflict.

### Automatic (via Claude)

Open this repo in Claude Code and say:

> Install the devs

### Manual — Mac / Linux

```bash
bash install.sh
```

### Manual — Windows (PowerShell)

```powershell
.\install.ps1
```

If you get an execution policy error, run this once first:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## Where This Works

| Feature | Claude Code CLI | Claude Code VS Code | Claude.ai web | Claude.ai app |
|---|:---:|:---:|:---:|:---:|
| Slash commands (`/cognigy-pm`, etc.) | ✓ | ✓ | ✗ | ✗ |
| `@` file references | ✓ | ✓ | ✗ | ✗ |
| Via Claude.ai Project | ✗ | ✗ | ✓ | ✓ |

---

## Usage

### Claude Code (CLI or VS Code) — slash commands

```
/cognigy-pm I need to build a new account recovery flow
/cognigy-prompt-analyst Why does this prompt return the wrong output when the user asks X?
/cognigy-security Audit this agent export before it goes to production
/cognigy-docs Generate documentation for this agent
```

Load a dev or reference file mid-conversation with `@`:

```
@~/.claude/devs/cognigy-pm.md
@~/.claude/devs/cognigy-nodes.md
```

### Claude.ai (web / app)

1. Create a **Project** in Claude.ai
2. Upload the relevant dev files from `devs/`, or paste their contents into the Project instructions
3. The devs will be available for all conversations in that Project

---

## Syncing Changes

After editing files in this repo, re-run the install command — it overwrites `~/.claude/devs/` and `~/.claude/commands/` with the current repo contents.

```bash
bash install.sh
```

Or ask Claude from within this repo:

> Sync my devs

---

## Adding a New Dev

1. Create a `.md` file in `devs/` using an existing dev as a template
2. Create a matching `.md` file in `commands/` following the same one-liner pattern
3. Add the dev to the table in `devs/README.md`
4. Add the dev to the table in this `README.md`
5. Run `bash install.sh` to sync

For a Cognigy-specific dev, prefix the filename with `cognigy-` and reference the relevant Cognigy context files at the top of the Role section.

---

## Dev File Structure

```
# [Dev Name]

## Role
Who this dev is and what makes them distinctive.
(Cognigy devs: reference context files here)

## Responsibilities
Bullet list of what they do.

## When to Use This Dev
Situations that call for this dev.

## How to Engage
What to provide when invoking this dev.

## [Approach / Methodology]  ← varies by dev
Domain-specific method or checklist.

## Output Format
How output adapts to different request types.

## Constraints
What this dev will not do.

## Collaboration
When and where to route to other devs.

## Example Prompts
Concrete, realistic invocation examples.
```
