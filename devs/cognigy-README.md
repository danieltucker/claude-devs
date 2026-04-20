# Cognigy Dev Team — Overview

A team of AI personas specialized for developing, auditing, and documenting Cognigy conversational AI agents. Each dev has deep knowledge of the Cognigy platform, the project codebase (via VSCode), and relevant external references.

**Not sure who to ask? Start with `@~/.claude/devs/cognigy-pm.md`.**

---

## Resources Every Dev Uses

- **Cognigy documentation**: https://docs.cognigy.com
- **Project codebase**: loaded in the active VSCode workspace
- **Supporting libraries**: moment.js, JavaScript (ES6+), relevant external API docs

---

## The Team

| File | Dev | When to Use |
|---|---|---|
| `cognigy-pm.md` | Cognigy PM | Starting a new flow, planning, not sure who to ask, organizing requirements |
| `cognigy-senior-dev.md` | Cognigy Senior Dev | Building flows, implementing nodes, writing Code node JS, designing agent configs |
| `cognigy-code-review.md` | Cognigy Code Review | Auditing existing flows, nodes, and Code node JS for quality and correctness |
| `cognigy-prompt-analyst.md` | Cognigy Prompt Analyst | Diagnosing LLM behavior, detecting prompt conflicts, explaining why a prompt produces a given output |
| `cognigy-security.md` | Cognigy Security | Auditing agents for security vulnerabilities, PII exposure, prompt injection |
| `cognigy-api.md` | Cognigy API Designer | HTTP connection design, tool parameter schemas, external API integration |
| `cognigy-qa.md` | Cognigy QA | Testing flows, intent coverage, NLU accuracy, edge cases, tool calling |
| `cognigy-docs.md` | Cognigy Docs | Generating documentation from agent exports |

---

## Reference Files

Deep-reference files embedded in dev personas — load these directly for raw reference material.

| File | Contents |
|---|---|
| `cognigy-export-schema.md` | Export package structure, directory layout, cross-reference patterns |
| `cognigy-nodes.md` | All node types with config schemas and usage guidance |
| `cognigy-context-vars.md` | Context variable hierarchy, naming conventions, state patterns |
| `cognigy-patterns.md` | Common design patterns: RAG, tool calling, flow architecture, error handling |

---

## How to Invoke

**Claude Code (CLI / VS Code):**
```
@~/.claude/devs/cognigy-pm.md I want to build a new flow for account recovery...
@~/.claude/devs/cognigy-security.md Audit this agent export for security issues
@~/.claude/devs/cognigy-prompt-analyst.md Why does this prompt produce X when the user asks Y?
@~/.claude/devs/cognigy-docs.md Generate documentation for this agent
```

---

## Platform Architecture

A Cognigy agent is composed of:

| Component | Description |
|---|---|
| **Flows** | Conversational logic trees composed of nodes |
| **Nodes** | Individual actions: set context, call LLM, search knowledge, branch, call sub-flow |
| **Intents** | NLU classifiers that route user input to the correct flow |
| **Knowledge Stores** | RAG-indexed document collections for search |
| **AI Agents** | Agentic configurations that orchestrate tool calls |
| **Connections** | Encrypted credentials for external services |
| **LLM Providers** | Configured model deployments (Azure OpenAI, etc.) |
| **Endpoints** | Channel configurations (webchat, REST API, etc.) |

### Data Flow

```
User Input
  → Endpoint transformer (JavaScript)
  → Intent matching (NLU)
  → Flow execution (node by node)
      → addToContext       — set/update context variables
      → executeFlow        — call a sub-flow
      → llmPromptV2        — invoke LLM with custom prompt
      → searchExtractOutput — RAG search + LLM synthesis
      → aiAgentJobTool     — define tool available to AI agent
      → say / question     — output to user / gather input
      → code               — run JavaScript
  → Output
  → Endpoint transformer (JavaScript)
```

### Context Hierarchy

```
input.*           — current user message + NLU results (resets each turn)
context.*         — persistent conversation state (survives turns)
profile.*         — Cognigy Contact Profile data
```

Full reference: `cognigy-context-vars.md`

### Export Structure

Agent packages are exported as directories of JSON files organized by resource type. Full schema reference: `cognigy-export-schema.md`

---

## Typical Workflow

1. **PM** — turn requirements into a plan and recommend which devs to involve
2. **Senior Dev** — implement flows, nodes, and JS
3. **Prompt Analyst** — review and tune LLM prompts and tool descriptions
4. **Code Review** — audit the implementation
5. **Security** — audit for vulnerabilities before go-live
6. **QA** — validate intent coverage, edge cases, and tool behavior
7. **Docs** — generate documentation from the completed agent
