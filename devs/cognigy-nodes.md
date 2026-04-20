# Cognigy Node Types Reference

Nodes are the building blocks of Cognigy flows. Each node is stored as a file in `nodeData/` with a `type` field. All nodes share the same outer schema — behavior is determined by `localizedData[].config`.

---

## Outer Schema (All Nodes)

```json
{
  "_id": "<objectId>",
  "referenceId": "<uuid>",
  "type": "<nodeType>",
  "label": "Human-readable label",
  "comment": "Optional dev note visible in flow editor",
  "isEntryPoint": false,
  "isDisabled": false,
  "localizedData": [{
    "config": { },
    "localeReference": "<locale_id>"
  }],
  "chartReference": "<chart_id>"
}
```

---

## Node Type Reference

### addToContext
Sets or updates a value in the conversation context.

```json
{
  "key": "user.lob",
  "value": "psSupport",
  "mode": "simple"
}
```

- `mode: "simple"` — assign value directly
- `mode: "complex"` — evaluate value as a JavaScript expression
- `key` uses dot-notation: `user.lob`, `session.isAuthenticated`, `languageSettings.storeId`
- Value can be a static string or a CognigyScript expression: `"{{input.slots.EMAIL[0].value}}"`

---

### say
Outputs a message to the user.

```json
{
  "type": "text",
  "text": "Hello, {{profile.firstName}}!"
}
```

Other types: `"gallery"`, `"list"`, `"buttons"`, `"audio"`, `"image"`, `"video"`

---

### question
Asks the user for input and waits for a response.

```json
{
  "type": "text",
  "text": "What is your order number?",
  "resultLocation": "input",
  "resultLocationKey": "orderNumber"
}
```

---

### llmPromptV2
Invokes an LLM with a custom prompt. The primary node for LLM calls.

```json
{
  "llmProviderReferenceId": "default",
  "prompt": "Your goal is to...\n\nUser input: {{input.text}}",
  "chatTranscriptSteps": 50,
  "usePromptMode": true,
  "samplingMethod": "temperature",
  "temperature": 0.2,
  "topP": 1,
  "maxTokens": 1000,
  "frequencyPenalty": 0,
  "presencePenalty": 0,
  "timeout": 8000,
  "storeLocation": "input",
  "inputKey": "promptResult",
  "responseFormat": "json_object",
  "errorHandling": "continue",
  "advancedLogging": false
}
```

Key fields:
- `llmProviderReferenceId`: UUID of the LLM provider, or `"default"` for the project default
- `storeLocation`: `"input"` or `"context"` — where to write the result
- `inputKey` / `contextKey`: key path within storeLocation (e.g., `"promptResult"` → `input.promptResult`)
- `responseFormat`: `"text"` for prose, `"json_object"` to force JSON output
- `temperature`: 0.1–0.2 for classification/extraction, 0.5–0.7 for generative
- `errorHandling: "continue"` — execution continues even if LLM call fails; always check result for null

**Access result**: `{{input.promptResult}}` or `{{context.promptResult}}`

---

### searchExtractOutput
Searches a knowledge store and uses an LLM to synthesize a response. The primary RAG node.

```json
{
  "mode": "s",
  "knowledgeStoreId": "{{context.languageSettings.psSupportKnowledge}}",
  "topK": 5,
  "searchString": "{{input.aiAgent.toolArgs.question}}",
  "searchSourceTags": ["error-codes"],
  "searchSourceTagsFilterOp": "and",
  "prompt": "You are a support agent. Answer based on the sources below.\n\nSources: @foundDocuments\nQuestion: @userInput\n\nOutput: Plain text answer.",
  "temperature": 0.7,
  "maxTokens": 1207,
  "outputMode": "text",
  "outputFallback": "Sorry, I could not find an answer to your question."
}
```

Key fields:
- `mode`: `"s"` = search only, `"e"` = extract only, `"se"` = both
- `searchSourceTags`: filter retrieval to sources with these tags; empty = all sources
- `@foundDocuments`: placeholder in `prompt` — replaced with retrieved chunks
- `@userInput`: placeholder replaced with the search string
- `outputFallback`: shown when no relevant chunks are found — always set this

---

### executeFlow
Calls another flow (sub-flow execution). Returns to the calling flow when complete.

```json
{
  "flowNode": {
    "flow": "<target-flow-referenceId>",
    "node": "<entry-node-referenceId>"
  },
  "parseIntents": true,
  "parseKeyphrases": true,
  "absorbContext": ""
}
```

- `flow` and `node` are UUIDs (`referenceId` values, not `_id`)
- `absorbContext`: merge strategy for context from sub-flow back into parent

---

### goTo
Jumps to a specific node, bypassing sequential execution.

```json
{
  "node": "<target-node-referenceId>",
  "flow": "<flow-referenceId>"
}
```

---

### code
Executes custom JavaScript. Has full access to `input`, `context`, `profile`, and `actions`.

```json
{
  "script": "// JavaScript here\nconst result = context.user.lob === 'psSupport';\nactions.addToContext('session.eligible', result, 'simple');"
}
```

Available APIs in Code nodes:
- `input.*` — current user turn (read)
- `context.*` — conversation state (read/write)
- `profile.*` — contact profile (read/write)
- `actions.addToContext(key, value, mode)` — set a context variable
- `actions.output(text, data)` — send output to the user
- `actions.setNextNode(referenceId)` — redirect execution to a specific node
- `moment` — moment.js is available globally

---

### if / then / else
Conditional branching. The `if` node holds the condition; `then` and `else` are branch container nodes.

```json
// if node config
{
  "conditions": [{
    "type": "CognigyScript",
    "expression": "input.promptResult.unableToLogin === true"
  }]
}
```

Condition types: `"CognigyScript"` (JavaScript expression), `"IntentScore"`, `"Slot"`, `"Pattern"`

---

### case
Switch-style multi-branch logic. Each case is a child branch.

---

### once
Executes its child nodes only once per conversation session. Skipped on repeat visits.

---

### completeGoal
Marks a conversation goal as achieved for analytics.

```json
{
  "goalName": "Account Recovery Completed",
  "goalType": "positive"
}
```

---

### aiAgent
Top-level node that activates an AI agent. The agent reads tool descriptions from child `aiAgentJobTool` nodes and decides which tools to call.

```json
{
  "aiAgentReferenceId": "<aiAgent-referenceId>",
  "systemPrompt": "You are a PlayStation support agent. Help users resolve account and billing issues.",
  "tools": []
}
```

The `systemPrompt` is the primary instruction to the LLM. It should define role, scope, tone, and any hard constraints.

---

### aiAgentJobTool
Defines a tool the AI agent can call. The `description` is read by the LLM to decide when and how to use the tool — write it as instructions, not documentation.

```json
{
  "toolId": "error_codes",
  "description": "# Purpose\nUse this tool to find PlayStation's official answers for specific error codes.\n\n# Use This Tool When\n- The user provides a PlayStation error code.\n\n# Tool Rules\n- Use this tool when a specific error code is the focus.\n- Can look up code, explain cause, provide troubleshooting steps.",
  "useParameters": true,
  "parameters": {
    "type": "object",
    "properties": {
      "error_code": {
        "type": "string",
        "description": "The PlayStation error code provided by the user"
      },
      "question": {
        "type": "string",
        "description": "A summary of the user's question about the error code"
      }
    },
    "required": ["error_code", "question"],
    "additionalProperties": false
  }
}
```

- `toolId`: unique snake_case identifier within the agent
- `description`: structured markdown — the LLM reads this to decide when/how to invoke the tool
- `additionalProperties: false`: prevents the LLM from inventing parameters not in the schema

---

### aiAgentToolAnswer
Returns a tool result back to the AI agent after a tool flow executes.

```json
{
  "result": "{{context.toolResult}}",
  "toolCallId": "{{input.aiAgent.toolCallId}}"
}
```

Always paired with an `aiAgentJobTool` — placed at the end of the tool's flow branch.

---

## CognigyScript

Variables are accessed in node config using `{{expression}}` syntax.

```
{{input.text}}                          — current user message
{{context.user.lob}}                    — context variable
{{profile.email}}                       — contact profile field
{{input.aiAgent.toolArgs.error_code}}   — tool parameter from AI agent
{{moment().format('YYYY-MM-DD')}}       — moment.js expression
```

Full variable reference: `cognigy-context-vars.md`
