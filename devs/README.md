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
| `qa.md` | QA / Testing | Test strategy, writing tests, coverage gaps, edge cases |
| `api.md` | API Designer | REST/GraphQL design, OpenAPI specs, versioning, API documentation |
| `security.md` | Security Architect | Threat modeling, auth/authz design, compliance, secure system design |
| `docs.md` | Docs & Writing | Technical documentation, README files, copy editing, changelogs |
| `prompt-eng.md` | Prompt Engineer | Prompt design, diagnosis, iteration, few-shot examples, output format control |

---

## Cognigy Agent Team

A specialized roster for Cognigy conversational AI development. These devs understand the Cognigy platform, export format, node types, and agent patterns. **Start with `cognigy-pm.md`.**

| File | Dev | When to Use |
|---|---|---|
| `cognigy-pm.md` | Cognigy PM | Starting a flow, planning, not sure who to ask, naming/design consultation |
| `cognigy-senior-dev.md` | Cognigy Senior Dev | Building flows, implementing nodes, Code node JS, AI agent configs |
| `cognigy-code-review.md` | Cognigy Code Review | Auditing flows, node configurations, and Code node JS |
| `cognigy-prompt-analyst.md` | Cognigy Prompt Analyst | Diagnosing LLM behavior, detecting prompt conflicts, explaining unexpected outputs |
| `cognigy-security.md` | Cognigy Security | Auditing agents for vulnerabilities, PII exposure, prompt injection |
| `cognigy-api.md` | Cognigy API Designer | HTTP connections, tool parameter schemas, external API integration |
| `cognigy-qa.md` | Cognigy QA | Testing flows, intent coverage, NLU accuracy, edge cases |
| `cognigy-docs.md` | Cognigy Docs | Generating documentation from agent exports |

**Cognigy reference files** (deep context for the devs above):

| File | Contents |
|---|---|
| `cognigy-README.md` | Platform overview, team roster, architecture, data flow |
| `cognigy-export-schema.md` | Export package structure, file schemas, cross-reference patterns |
| `cognigy-nodes.md` | All node types with config schemas and usage guidance |
| `cognigy-context-vars.md` | Context variable hierarchy, naming conventions, state patterns |
| `cognigy-patterns.md` | Common design patterns: RAG, tool calling, flow architecture, error handling |

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
