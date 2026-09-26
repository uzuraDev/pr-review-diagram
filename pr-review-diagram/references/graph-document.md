# Graph document (Coldtea schemaVersion 0.2.0)

Condensed from `@coldtea/pr-lens-schema` (MIT © Coldtea AI). Machine schema:
`https://unpkg.com/@coldtea/pr-lens-schema/json-schema/graph-doc.schema.json`.
Unknown keys are rejected. Prefer authoring JSON to match
`assets/example-acme-scm-allocation-sim.graph.json`.

## Skeleton

```json
{
  "schemaVersion": "0.2.0",
  "kind": "graph",
  "title": "…",
  "summary": "What does this change do?",
  "lenses": ["architecture", "data-flow"],
  "provenance": {
    "repo": { "owner": "…", "name": "…", "host": "github.com" },
    "base": { "sha": "<40-hex>" },
    "head": { "sha": "<40-hex>" },
    "pullRequest": { "number": 1, "url": "https://github.com/…/pull/1" }
  },
  "lanes": [],
  "nodes": [],
  "edges": [],
  "flows": [],
  "views": []
}
```

If `flows` is non-empty, `lenses` **must** include `"data-flow"`.

## Ids

`^[A-Za-z0-9][A-Za-z0-9._:/-]*$`, ≤128 chars, unique within their collection.
Readable kebab-case (`allocation-sim-page`), not `n1`.

## Deltas

Every node, edge, flow, and flow message: `added` | `modified` | `removed` | `unchanged`.

`unchanged` = blast-radius context (neighbors the change touches). Do not omit
them; an all-`added` graph has no place in the system.

## Lanes (1–16)

```json
{ "id": "client-ui", "label": "クライアントUI", "summary": "…" }
```

Every node belongs to exactly one lane. Typical: Client / API / DB (or
Frontend / Services / Data).

## Nodes (1–256)

```json
{
  "id": "graphql-api:allocation-simulation-op",
  "label": "`simulateAllocation`オペレーション",
  "kind": "function",
  "delta": "added",
  "lane": "graphql-api",
  "files": [{ "path": "server/src/operations/allocationSimulation.ts" }],
  "badges": []
}
```

`kind`: `service` `app` `module` `function` `route` `job` `queue` `datastore`
`cache` `external` `ui` `config` `test` `package` `other` (icons only).

`files`: repository-relative POSIX paths, no `..`, no absolutes. Delta badge is
drawn for you — do not restate it in `badges`.

## Edges (≤512)

```json
{
  "id": "page-to-schema",
  "from": "client-ui:allocation-sim-page",
  "to": "graphql-api:schema",
  "kind": "http",
  "delta": "added",
  "label": "`GraphQL`クエリ",
  "emphasis": "hero",
  "animated": false,
  "files": [{ "path": "client/pages/allocation-sim.vue" }]
}
```

`kind`: `call` `http` `rpc` `event` `queue` `data` `dependency` `render` `other`.  
`emphasis`: `normal` (default) | `hero` | `muted`. At most one or two heroes.

**Most common failure:** `from` / `to` not equal to declared node ids.

## Flows (≤16) — data-flow lens

```json
{
  "id": "allocation-simulation-flow",
  "title": "引当シミュレーションリクエスト",
  "summary": "…",
  "delta": "modified",
  "participants": [
    { "node": "client-ui:allocation-sim-page", "label": "ユーザーUI" },
    { "node": "graphql-api:resolver" },
    { "node": "graphql-api:allocation-simulation-op" },
    { "node": "database:mongodb" }
  ],
  "messages": [
    {
      "id": "flow-msg-1",
      "from": "client-ui:allocation-sim-page",
      "to": "graphql-api:resolver",
      "label": "クエリ `allocationSimulation(strategy)`",
      "kind": "sync",
      "delta": "added",
      "animated": true
    }
  ]
}
```

- 2–12 participants; endpoints of each message must be participants of **that** flow.
- Message `kind`: `sync` | `async` | `return` | `self` (`self` ⇒ `from === to`).
- Array order = animation order. Optional `payload` is for canvas; local SVG
  delivery can omit it.

## Views (C4-style)

```json
{
  "id": "container-view",
  "title": "コンテナビュー",
  "lens": "architecture",
  "summary": "…",
  "scope": { "kind": "all" },
  "defaultOpen": true,
  "children": []
}
```

- Architecture: prefer one **container** view (`defaultOpen: true`). Add
  component children only when internals matter. Skip empty/speculative levels.
- Data-flow: separate root with `scope: { "kind": "selection", "flows": ["…"] }`.
- `lens` must be declared in document `lenses`.

## Common validator errors

| Symptom | Fix |
| --- | --- |
| Unknown key | Strict schema — remove extra fields |
| Broken edge reference | `from`/`to` must match node `id`s exactly |
| Flow message endpoint | Both ends must be in that flow's `participants` |
| Flows without lens | Add `"data-flow"` to `lenses` |
| Bad file path | Repo-relative POSIX; no `..`, drive letters, or `\` |
| Bad id chars | Only `A-Za-z0-9._:/-`, must start alphanumeric |
| Unsupported schemaVersion | Use `0.2.0` (or supported 0.x minor ≤ package) |
| Duplicate ids | Ids unique within lanes/nodes/edges/flows/views |

Validate: `npx @coldtea/pr-lens-cli@latest validate graph.json`
