# Cognigy Export Schema

A Cognigy agent package is exported as a directory of JSON files organized by resource type. Each subdirectory contains one file per resource.

---

## Directory Structure

```
<package>/
├── index.json              # Package manifest
├── flow/                   # Flow definitions (~89 per agent)
├── chart/                  # Flow graphs — node connections and branching (one per flow)
├── nodeData/               # Individual flow nodes (thousands of files)
├── flowSettings/           # NLU and execution settings per flow
├── flowState/              # Default intent filter state per flow
├── intent/                 # Intent definitions (NLU classifiers)
├── intentSentence/         # Training examples per intent
├── intentRelation/         # Intent parent/child hierarchy
├── intentTrainGroup/       # Intent training parameters
├── intentDefaultReply/     # Fallback replies when no intent matches
├── locale/                 # Language definitions
├── endpoint/               # Channel configs (webchat, REST API, etc.)
├── connection/             # Encrypted credentials for external services
├── largeLanguageModel/     # LLM provider configurations
├── aiAgent/                # AI agent configurations
├── handoverProvider/       # Human agent escalation configs
├── knowledgeStore/         # Knowledge base containers
├── knowledgeSource/        # Individual knowledge documents
├── knowledgeChunk/         # Embedded text chunks with vectors
├── lexicon/                # NLU vocabulary containers
├── lexiconEntry/           # Vocabulary entries
├── lexiconKeyphrase/       # Keyphrase definitions
├── lexiconSlot/            # Slot type definitions
└── slotFiller/             # Slot filling strategy configs
```

---

## ID System

Cognigy uses two identifier types:

| Field | Format | Used For |
|---|---|---|
| `_id` | MongoDB ObjectId (24-char hex) | Internal references within an export |
| `referenceId` | UUID (hyphenated) | Stable cross-environment references used in flow execution config |

**Key rule**: `executeFlow` nodes reference target flows by `referenceId` (UUID). Most in-export cross-references use `_id`.

---

## File Schemas

### index.json — Package Manifest
```json
{
  "cognigyVersion": "2026.x.x",
  "type": "package",
  "name": "Package-<AgentName>_<timestamp>",
  "resourcesHash": "<integrity checksum>",
  "knowledgeData": [{
    "storeReferenceId": "<uuid>",
    "sources": [{ "sourceReferenceId": "<uuid>", "embeddedChunkCount": 161 }]
  }]
}
```

### flow/ — Flow Definitions
```json
{
  "_id": "<objectId>",
  "referenceId": "<uuid>",
  "name": "API - Account Recovery",
  "description": "",
  "context": {},
  "attachedFlows": [],
  "localizedData": [{ "attachedLexiconReferences": [], "localeReference": "<locale_id>" }],
  "chartReference": "<objectId>",
  "projectReference": "<objectId>",
  "createdAt": 1754690363,
  "lastChanged": 1775591277
}
```

### chart/ — Flow Graphs
```json
{
  "_id": "<objectId>",
  "relations": [{
    "node": "<nodeData_id>",
    "children": ["<nodeData_id>", "<nodeData_id>"],
    "next": "<nodeData_id>",
    "_id": "<edge_id>"
  }],
  "resourceReference": "<flow_id>"
}
```

`children` = conditional branches (if/then/else, case). `next` = sequential next node.

### nodeData/ — Individual Nodes
```json
{
  "_id": "<objectId>",
  "referenceId": "<uuid>",
  "type": "<nodeType>",
  "label": "Human-readable label",
  "comment": "Optional dev note",
  "isEntryPoint": false,
  "isDisabled": false,
  "localizedData": [{
    "config": { },
    "localeReference": "<locale_id>"
  }],
  "chartReference": "<chart_id>"
}
```

See `cognigy-nodes.md` for all `type` values and their `config` schemas.

### intent/ — Intent Definitions
```json
{
  "_id": "<objectId>",
  "name": "Accidental Purchase",
  "description": "What this intent captures",
  "intentType": "default",
  "localizedData": [{
    "rules": ["input.text.toLowerCase() === \"exact phrase\""],
    "confirmationSentences": [],
    "localeReference": "<locale_id>"
  }],
  "intentRelationReferences": ["<intentRelation_id>"],
  "flowReference": "<flow_id>",
  "analyticsLabel": "Accidental Purchase"
}
```

### intentSentence/ — Training Examples
```json
{
  "_id": "<objectId>",
  "text": "I want to cancel a pre-order",
  "slots": [],
  "intentReference": "<intent_id>",
  "localeReference": "<locale_id>",
  "flowReference": "<flow_id>"
}
```

### endpoint/ — Channel Configurations
```json
{
  "_id": "<objectId>",
  "channel": "webchat3",
  "flowId": "<flow-referenceId>",
  "settings": {
    "colors": {},
    "layout": {},
    "behavior": {},
    "startBehavior": {},
    "businessHours": {}
  },
  "transformer": {
    "transformer": "createSocketTransformer({...})",
    "handleInput": {},
    "handleOutput": {},
    "handleExecutionFinished": {},
    "handleInject": {},
    "handleNotify": {}
  },
  "nluConnectorId": "cognigy"
}
```

### connection/ — External Service Credentials
```json
{
  "_id": "<objectId>",
  "referenceId": "<uuid>",
  "name": "Azure GPT4o (new)",
  "type": "AzureOpenAIProviderV2",
  "extension": "@cognigy/generative-ai-provider",
  "fields": { "apiKey": "<encrypted>" },
  "resourceLevel": "project"
}
```

Note: `fields.apiKey` is encrypted in exports. The raw key is never exposed.

### largeLanguageModel/ — LLM Provider Configurations
```json
{
  "_id": "<objectId>",
  "referenceId": "<uuid>",
  "name": "Azure 4o-mini - Production",
  "modelType": "gpt-4o-mini",
  "modelGroup": "chat",
  "isCustomModel": false,
  "provider": "azureOpenAI",
  "azureOpenAI": {
    "baseCustomUrl": "https://<resource>.openai.azure.com/openai/deployments/<deployment>/chat/completions?api-version=<version>"
  },
  "fallbacks": [],
  "isDefault": false,
  "connectionId": "<connection_referenceId>"
}
```

### knowledgeStore/ — Knowledge Base Containers
```json
{
  "_id": "<objectId>",
  "referenceId": "<uuid>",
  "name": "JA-JP Support",
  "language": "en-US",
  "status": "ready"
}
```

### knowledgeSource/ — Knowledge Documents
```json
{
  "_id": "<objectId>",
  "referenceId": "<uuid>",
  "name": "account-ja-jp.ctxt",
  "type": "ctxt",
  "status": "ready",
  "chunkCount": 161,
  "metaData": {
    "fileName": "account-ja-jp.ctxt",
    "tags": ["account", "ja-jp"],
    "extractedChunks": 161
  },
  "data": { "url": "https://..." },
  "storeReference": "<knowledgeStore_id>"
}
```

### knowledgeChunk/ — Embedded Text Chunks
```json
{
  "_id": "<objectId>",
  "referenceId": "<uuid>",
  "order": 0,
  "text": "Actual chunk content...",
  "disabled": false,
  "data": { "url": "https://..." },
  "embedding": {
    "vector": [0.006993674, ...],
    "model": "text-embedding-ada-002"
  },
  "sourceReference": "<knowledgeSource_id>",
  "storeReference": "<knowledgeStore_id>"
}
```

---

## Navigating an Export

**Trace a flow end-to-end:**
1. Find the flow in `flow/` by name
2. Find its chart in `chart/` by matching `chartReference`
3. Follow `relations[].node` to find node files in `nodeData/`
4. For `executeFlow` nodes: `flowNode.flow` (UUID) → target flow's `referenceId`
5. For `searchExtractOutput` nodes: `knowledgeStoreId` → `knowledgeStore` referenceId
6. For `llmPromptV2` nodes: `llmProviderReferenceId` → `largeLanguageModel` referenceId (or "default")
7. For `connection` references: `connectionId` → `connection` referenceId

**Find all prompts in an agent:**
- Search `nodeData/` for files where `type` = `llmPromptV2` or `type` = `searchExtractOutput`
- Each has a `localizedData[0].config.prompt` field

**Find all tools in an agent:**
- Search `nodeData/` for files where `type` = `aiAgentJobTool`
- Each has a `localizedData[0].config.toolId` and `description`
