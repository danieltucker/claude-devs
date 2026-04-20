# Cognigy Design Patterns

Common architectural patterns in Cognigy agents. Reference when designing, reviewing, or debugging flows.

---

## 1. RAG (Retrieval-Augmented Generation)

**Use for**: answering questions from a knowledge base without hardcoded responses.

**Node chain:**
```
searchExtractOutput
  ├── knowledgeStoreId = {{context.languageSettings.psSupportKnowledge}}
  ├── searchString = {{input.text}} or {{input.aiAgent.toolArgs.question}}
  ├── searchSourceTags = ["topic-tag"]
  ├── topK = 5
  ├── prompt = "Answer based on: @foundDocuments\nQuestion: @userInput\nOutput: Plain text."
  └── outputFallback = "I couldn't find an answer to that question."
```

**Best practices:**
- Store knowledge store IDs in `context.languageSettings.*` — never hardcode UUIDs in nodes
- Tag sources meaningfully so `searchSourceTags` can narrow retrieval (e.g., `["error-codes"]`, `["account"]`)
- Always set `outputFallback` — without it the LLM may hallucinate when no chunks are found
- `topK: 3–5` is the practical range; higher values add cost without improving quality in most cases
- Use `searchSourceTagsFilterOp: "and"` to require all tags; `"or"` to require any

---

## 2. AI Agent Tool Calling

**Use for**: agentic workflows where the LLM decides which tool to invoke based on conversation state.

**Node chain:**
```
aiAgent (system prompt + tool registry)
  ├── aiAgentJobTool (toolId: "search_knowledge")
  │     └── executeFlow → searchExtractOutput → aiAgentToolAnswer
  ├── aiAgentJobTool (toolId: "get_order_status")
  │     └── executeFlow → HTTP Request node → aiAgentToolAnswer
  └── say (final LLM response)
```

**Tool description structure** (the LLM reads this to decide when/how to invoke):
```markdown
# Purpose
One sentence: what this tool does.

# Use This Tool When
- Condition 1
- Condition 2

# Tool Rules
- Must-follow rule 1
- Must-follow rule 2
```

**Best practices:**
- Tool IDs must be unique within the agent — use snake_case
- `additionalProperties: false` prevents the LLM from inventing parameters
- Mark all truly required parameters in `required`; leave optional ones out unless they have clear defaults
- Tool descriptions are instructions to the LLM — write them prescriptively ("Use this tool when..."), not descriptively ("This tool retrieves...")
- The `aiAgent` system prompt should define role, scope, tone, and hard constraints on what the agent can and cannot do

---

## 3. LLM Classification

**Use for**: routing decisions based on intent that NLU alone can't handle.

**Node chain:**
```
llmPromptV2
  ├── temperature = 0.1
  ├── responseFormat = "json_object"
  ├── storeLocation = "input"
  ├── inputKey = "classification"
  └── prompt = "Classify the input as one of [A, B, C]. Output JSON: {\"class\": \"<value>\"}"

if: input.classification.class === "A"
  then → executeFlow: Flow A
  else → executeFlow: Flow B
```

**Best practices:**
- Always use `responseFormat: "json_object"` for classification — never parse prose for routing
- Temperature 0.1–0.2 for classification; 0.5–0.7 for generative responses
- Always handle the null/unexpected case after `llmPromptV2` — check before using in routing
- Use explicit class names in the prompt rather than numbers or codes

---

## 4. Flow Composition

**Use for**: breaking complex agents into manageable, reusable sub-flows.

**Pattern:**
```
Main Entry Flow
  → executeFlow: "Config - Initial Setup"   (sets context.languageSettings.*)
  → executeFlow: "Config - Auth Check"       (sets context.user.authenticated)
  → executeFlow: "Router - Main"
      ├── executeFlow: "API - Account Recovery"
      ├── executeFlow: "API - Billing"
      └── executeFlow: "LLM - General Support"
```

**Flow naming conventions** (from this codebase):
- `API - <Name>` — flow that calls an external API
- `LLM - <Name>` — flow centered on LLM processing
- `Tool - <Name>` — AI agent tool handler flow
- `Config - <Name>` — initialization/configuration flow
- `Router - <Name>` — decision/routing flow

**Best practices:**
- Config flows (setting context variables) should always run first and be idempotent
- Keep sub-flows focused on one responsibility — avoid flows that both call APIs and handle LLM classification
- Use `absorbContext: ""` on `executeFlow` to merge sub-flow context back into the parent
- Entry points into sub-flows should be named consistently (`isEntryPoint: true` on the first node)

---

## 5. Context Initialization

**Use for**: setting up locale, environment config, and user state at conversation start.

**Pattern:**
```
Entry Flow (first node of the agent)
  → addToContext: context.languageSettings.psSupportKnowledge = "<store-uuid>"
  → addToContext: context.languageSettings.locale = "en-US"
  → addToContext: context.user.lob = "psSupport"
  → once: (run only on first turn)
      → executeFlow: Config - Session Init
  → executeFlow: Router - Main
```

**Best practices:**
- Use a dedicated Config flow for initialization — keep it separate from routing logic
- Store all environment-specific IDs (knowledge store UUIDs, LLM provider IDs, endpoint URLs) in context — never hardcode in individual nodes
- Use `once` nodes for initialization logic that should run only at conversation start
- Initialize all context keys your flows depend on — downstream flows may fail silently if they read `undefined`

---

## 6. Intent Routing

**Use for**: directing conversation to the correct flow using NLU.

**Pattern:**
```
User input arrives in main flow
  → Intent matched: "Accidental Purchase"
  → executeFlow: "API - Purchase Returns"
```

**Intent types:**
- `default`: standard NLU-trained intent
- `rules`: exact-match overrides — `input.text.toLowerCase() === "cancel"` — checked before NLU
- `confirmationSentences`: what the model recognizes as "yes" in confirmation flows

**Best practices:**
- Exact-match rules take priority over NLU — use only for critical, unambiguous phrases
- Keep training sentences varied: include typos, short forms, different phrasings — not just paraphrases
- Use `intentRelation` parent/child hierarchy to group related intents for threshold tuning
- `analyticsLabel` on each intent enables clean tracking in Cognigy Insights

---

## 7. Handover to Human Agent

**Use for**: escalating to a live agent with full context.

**Pattern:**
```
addToContext: context.escalationToolArgs = {
  reason: "User requested human agent",
  category: "billing",
  orderNumber: context.session.orderNumber
}
  → say: "Connecting you to an agent now..."
  → executeFlow: Handover Flow
      → handover node (configured with handoverProvider)
```

**Best practices:**
- Always capture structured context in `context.escalationToolArgs` before handover — the human agent platform receives this
- Confirm with the user before handing over — they may resolve the issue before connecting
- Log the reason for escalation via `completeGoal` with an appropriate `goalType`

---

## 8. Error Handling

**Use for**: gracefully handling LLM timeouts, API failures, and unexpected outputs.

**Pattern for LLM nodes:**
```
llmPromptV2
  └── errorHandling = "continue"

if: input.promptResult === null || input.promptResult === undefined
  then → say: "I'm having trouble processing that right now. Let me try a different approach."
  else → [use the result]
```

**Pattern for unexpected LLM output format:**
```
llmPromptV2 (responseFormat: "json_object")

code node:
  const result = input.promptResult;
  if (!result || typeof result.class === 'undefined') {
    actions.addToContext('session.classificationError', true, 'simple');
  }

if: context.session.classificationError === true
  then → fallback flow
```

**Best practices:**
- Always set `errorHandling: "continue"` on LLM and HTTP nodes — `"stop"` will silently end execution
- Always provide `outputFallback` on `searchExtractOutput` nodes
- Never route on `input.promptResult` without a null check
- Log unexpected failures via a `completeGoal` node with `goalType: "negative"` for Insights tracking
