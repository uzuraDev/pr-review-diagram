# Granularity: match the example graph

Reference quality: `assets/example-acme-scm-allocation-sim.graph.json`
(fictional Acme SCM feature PR — allocation simulation). Target look:
Coldtea light-theme SVGs with green/amber/red delta cards, lanes, and an
animated data-flow.

## Title / summary

- **Title**: short feature name (例: `引当シミュレーション機能`), not a commit subject dump.
- **Summary**: one paragraph — what the user can do, what is read-only vs
  mutating, strategies/constraints that matter for review.

## Lanes (~3)

Container bands, not folders:

1. **Client / UI** — pages, panels, layout
2. **API** — schema, resolvers, operations, codegen, tests
3. **Database** — datastore + domain models touched by the path

Add a fourth lane only for a real external system or job runner.

## Nodes (~10–16)

One card per reviewable unit:

| Layer | Examples (from the sample graph) |
| --- | --- |
| UI | page (`allocation-sim.vue`), panel component, modified layout |
| API | schema, resolver, **new op** (`simulateAllocation`), related op, codegen, test |
| DB | `MongoDB` + models the op reads (Order, Product, Inventory, …) |

Rules:

- Prefer **page / panel / op / model** granularity over one blob per package.
- Include **unchanged** neighbors the change reads or sits beside (blast radius).
- Attach `files[].path` on changed nodes; empty `files` is OK for pure context
  datastores/models.
- Mark deltas honestly: new page/op = `added`; touched schema/resolver = `modified`.

## Edges

- Navigation / compose: `kind: "render"`
- HTTP/GraphQL: `kind: "http"`
- In-process call: `kind: "call"`
- DB read/write: `kind: "data"`
- Put `emphasis: "hero"` on the **main** cross-lane path only (e.g. page→schema,
  resolver→new op). Keep other edges `normal`.

## Data-flow (one primary)

When the PR moves data:

- One flow titled as the user request (例: `引当シミュレーションリクエスト`).
- Participants: UI → resolver → op → datastore (collapse many model reads into
  one DB participant in the **flow**; keep per-model nodes on the architecture
  graph).
- Messages: request → call op → read data → return report → display.
- Set `animated: true` on flow messages. Call out **read-only** behavior in
  labels/summary when the feature must not mutate stock/orders.

Skip the data-flow lens for docs-only / pure rename PRs.

## Views

- Architecture: single **コンテナビュー** / container view, `scope.kind: "all"`,
  `defaultOpen: true`.
- Data-flow: second root selecting the one flow; not nested under architecture.

## Language

If the PR is Japanese, use Japanese for `title`, `summary`, lane/node/edge/flow
labels and the PR comment caption. Keep code identifiers backticked in labels
(`\`GraphQL\``, `\`simulateAllocation\``).

## Size check

Ballpark for a medium feature PR: **3 lanes, ~12–16 nodes, ~8–12 edges, 1 flow
with ~5–7 messages, 2 views**. Far fewer → you may be too coarse; far more
without hierarchy → too noisy (split views or drop peripheral nodes).
