# Cognigy Context Variables Reference

Cognigy flows use three top-level variable namespaces, accessible everywhere: `{{...}}` CognigyScript expressions in node config, and as plain JavaScript objects in Code nodes.

---

## input.*

Set by the platform on each user turn. Resets every turn — do not use `input.*` to persist data across turns.

| Variable | Type | Description |
|---|---|---|
| `input.text` | string | Raw user input text |
| `input.type` | string | Input type: `"text"`, `"data"`, etc. |
| `input.data` | object | Structured data payload (non-text inputs) |
| `input.intent` | string | Name of the matched intent |
| `input.intentScore` | number | NLU confidence score (0–1) |
| `input.slots.*` | object | Extracted slot values, keyed by slot name |
| `input.nlu.intentMapperResults` | array | Full NLU results with all scored intents |
| `input.promptResult` | any | Result of the most recent `llmPromptV2` node (when `storeLocation = "input"`) |
| `input.aiAgent.toolArgs.*` | object | Parameters passed to the current tool by the AI agent |
| `input.aiAgent.toolCallId` | string | Unique ID of the current tool call — required by `aiAgentToolAnswer` |

---

## context.*

Persists for the lifetime of the conversation. Read/write via `addToContext` nodes or Code nodes.

### Standard Patterns

| Variable | Type | Description |
|---|---|---|
| `context.user.lob` | string | Line of business / routing category (e.g., `"psSupport"`) |
| `context.user.name` | string | User's display name |
| `context.user.authenticated` | boolean | Whether the user has authenticated in this session |
| `context.session.*` | object | Session-scoped flags and state |
| `context.languageSettings.*` | object | Locale-specific resource IDs (see below) |
| `context.escalationToolArgs` | object | Structured data captured before human handover |

### languageSettings Pattern

Used to swap locale-specific resources at runtime without branching. Set once in an initialization flow:

```json
{
  "context.languageSettings.psSupportKnowledge": "<knowledgeStore-referenceId-EN>",
  "context.languageSettings.locale": "en-US",
  "context.languageSettings.timezone": "America/New_York"
}
```

Then reference in node config:
```
{{context.languageSettings.psSupportKnowledge}}
```

This avoids hardcoding knowledge store IDs in individual nodes and makes locale switching a single context update.

### Naming Conventions

- `context.user.*` — user identity, authentication state, and preference data
- `context.session.*` — flags and state that apply to the current session
- `context.<featureName>.*` — feature-specific state (e.g., `context.orderLookup.orderId`)
- Keys use **camelCase**
- Boolean flags: `context.session.isAuthenticated`, `context.session.hasConsented`
- IDs / references: `context.languageSettings.knowledgeStoreId`

---

## profile.*

Cognigy Contact Profile — user data persisted across sessions. Read/write.

| Variable | Type | Description |
|---|---|---|
| `profile.email` | string | User's email address |
| `profile.firstName` | string | First name |
| `profile.lastName` | string | Last name |
| `profile.goals` | array | List of completed goal names |
| `profile.gender` | string | Gender (if captured) |

---

## System / Channel Variables

| Variable | Description |
|---|---|
| `ci.userId` | Unique Cognigy Contact ID |
| `ci.sessionId` | Current session ID |
| `ci.channel` | Channel name: `"webchat3"`, `"rest"`, etc. |
| `ci.source` | Source endpoint identifier |

---

## Code Node API

In Code nodes, all variables are plain JavaScript — no `{{}}` wrapper.

```javascript
// Read
const userLob = context.user.lob;
const userText = input.text;
const toolQuestion = input.aiAgent.toolArgs.question;

// Write context
actions.addToContext('user.authenticated', true, 'simple');
actions.addToContext('session.lastIntent', input.intent, 'simple');

// Write with evaluated expression
actions.addToContext('session.timestamp', new Date().toISOString(), 'simple');

// Output to user
actions.output('Hello, ' + profile.firstName, {});

// Redirect execution
actions.setNextNode('<node-referenceId>');

// moment.js is available globally
const formatted = moment().tz('America/New_York').format('MMMM Do YYYY');
```

---

## Anti-Patterns

| Anti-Pattern | Why It's a Problem | Correct Approach |
|---|---|---|
| Using `input.*` to store data across turns | `input.*` resets every turn — data is lost | Write to `context.*` with `addToContext` |
| Deep nesting: `context.a.b.c.d.e` | Hard to trace, hard to debug | Flatten when possible; max 3 levels |
| Hardcoding knowledge store IDs in nodes | Breaks when environments change | Store IDs in `context.languageSettings.*` |
| Setting context in a later flow without initialization | Downstream flows may read undefined values | Initialize all expected keys in a Config flow at conversation start |
| Overwriting `input.aiAgent.toolArgs.*` | These are set by the AI agent — modifying them causes tool answer mismatch | Read tool args into context; don't overwrite originals |
