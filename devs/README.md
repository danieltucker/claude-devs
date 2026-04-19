# Dev Roster

A team of specialized AI devs available for any project. Reference any dev with `@~/.claude/devs/<name>.md` in Claude Code, or paste the file contents into your Claude.ai Project.

**Not sure who to ask? Start with `@pm.md` — it will triage and route.**

---

## The Team

| File | Dev | When to Use |
|---|---|---|
| `pm.md` | Project Manager | Starting a project, planning, not sure who to ask, organizing thoughts into action |
| `senior-dev.md` | Senior Dev | Writing new code, diagnosing bugs, architecture decisions, technical design |
| `code-review.md` | Code Review | Auditing existing code for quality, security, and performance |
| `ui.md` | UI/UX Designer | New UI design, reviewing current UI, improving user experience |
| `qa.md` | QA / Testing | Test strategy, writing tests, coverage gaps, edge cases |
| `devops.md` | DevOps Engineer | CI/CD, deployments, Docker, cloud infrastructure, monitoring |
| `database.md` | Database Architect | Schema design, query optimization, migrations, data modeling |
| `api.md` | API Designer | REST/GraphQL design, OpenAPI specs, versioning, API documentation |
| `security.md` | Security Architect | Threat modeling, auth/authz design, compliance, secure system design |
| `docs.md` | Docs & Writing | Technical documentation, README files, copy editing, changelogs |

---

## How to Invoke

**Claude Code (CLI / VS Code):**
```
@~/.claude/devs/pm.md I have a new project idea I need to plan out...
@~/.claude/devs/code-review.md Review the auth module in src/auth/
@~/.claude/devs/ui.md Here's my current dashboard — what should be improved?
```

**Claude.ai (web / app):**
Create a Project and upload the relevant dev files, or paste the contents of a dev file at the start of your message.

---

## Typical Workflow

1. **Start with PM** — turn your idea or request into a plan and get a recommended dev sequence
2. **Senior Dev** — guides implementation as you build
3. **Code Review** — audit before merging or shipping
4. **QA** — validate coverage and edge cases
5. **DevOps** — wire up deployment and infrastructure
6. **Docs & Writing** — document what was built

Devs can be combined in one session — invoke multiple if your task spans roles.
