---
name: pr-review-diagram
description: >-
  Use when the user wants PR architecture / data-flow diagrams, Coldtea PR Lens
  style SVG cards (green/amber/red deltas, lanes, animated flows), orphan-hosted
  images in a PR comment, or /pr-review-diagram. Agent authors a Coldtea
  schemaVersion 0.2.0 graph.json, validates and renders with @coldtea/pr-lens-cli,
  then delivers SVGs (default: no canvas push). Prefer Japanese labels when the
  PR or repo is Japanese. Mermaid only if the user forbids npm/Coldtea packages.
---

# PR review diagram (Coldtea render)

Produce **architecture** and **data-flow** images that match Coldtea PR Lens
look and granularity: lane cards, delta colors, hero edges, animated flow
steps. The look must come from the **Coldtea renderer**, not Mermaid.

Credit: graph contract + renderer are MIT © Coldtea AI (`@coldtea/pr-lens-schema`,
`@coldtea/pr-lens-cli`). This skill does **not** require the GitHub App or a
prlens.dev account. Default: **no canvas push** (private-friendly).

## When to run

- User asks for PR architecture / data-flow / 構成図 / データフロー
- User invokes `/pr-review-diagram`
- User wants SVG cards hosted on an orphan assets branch and linked from a PR comment

## Operating procedure

### 1. Read the PR diff

Resolve PR in order: explicit URL/number → current branch vs base → pasted diff.

```bash
gh pr view <n> --json number,url,title,body,baseRefName,headRefOid,files,additions,deletions
gh pr diff <n>
# or: git fetch && git diff <base>...<head>
```

Gather: title/body, file list with status, hunks for behavior-changing files
(skip lockfiles/generated noise unless central).

### 2. Write `.pr-diagram/graph.json`

Author a Coldtea **schemaVersion `0.2.0`** graph document yourself (preferred).
Do **not** call `pr-lens analyze` unless the user supplies their own model API
key and asks for it.

```bash
mkdir -p .pr-diagram
# write .pr-diagram/graph.json
```

Required shape (see `references/graph-document.md`):

| Field | Role |
| --- | --- |
| `schemaVersion` | `"0.2.0"` |
| `kind` | `"graph"` |
| `title` / `summary` | What the change does (1 short title + 1 paragraph) |
| `lenses` | `["architecture"]` or `["architecture","data-flow"]` |
| `provenance` | repo owner/name + base/head sha (+ PR number/url when known) |
| `lanes` | 1–16 containers (e.g. Client / API / DB) |
| `nodes` | per page/panel/op/model; each has `kind`, `delta`, `lane`, `files` |
| `edges` | relations; use `emphasis: "hero"` sparingly on the main path |
| `flows` | when sequence matters (required if `data-flow` lens) |
| `views` | C4-style: container architecture view + optional data-flow view |

**Granularity** must match `assets/example-acme-scm-allocation-sim.graph.json` and
`references/granularity.md`: ~3 lanes, ~10–16 nodes (include **unchanged**
neighbors for blast radius), file refs on changed nodes, one primary data-flow
when data moves.

Language: Japanese labels/captions when the PR title/body/UI is Japanese;
keep identifiers (`GraphQL`, `MongoDB`, paths) in original form.

### 3. Validate then render

```bash
npx --yes @coldtea/pr-lens-cli@latest validate .pr-diagram/graph.json
npx --yes @coldtea/pr-lens-cli@latest render .pr-diagram/graph.json \
  -o .pr-diagram/out --theme light
```

Renderer writes hashed filenames per view (e.g. `container-view-light-<hash>.svg`).
Copy/rename for delivery:

```bash
# map architecture lens SVG → architecture-light.svg
# map data-flow lens SVG → data-flow-light.svg
# use manifest.json "lens" / view titles to pick the right files
```

Fix validator errors (unknown keys, bad edge endpoints, flow participants,
missing `data-flow` lens when flows exist) before delivering.

### 4. Deliver SVGs (default path)

**Prefer orphan branch + markdown images**:

1. Branch name: **`pr-diagram-assets`** (orphan).  
   Avoid colliding with other long-lived asset or fixture branch prefixes in the
   same repo. Do not delete unrelated asset history unless asked.
2. Paths:
   - `pr/<n>/<headSha>/architecture-light.svg`
   - `pr/<n>/<headSha>/data-flow-light.svg`
3. Push carefully: update only these paths; keep other `pr/<…>` assets intact.
4. PR comment with raw image URLs (see `assets/comment-template.md`):

```markdown
![アーキテクチャ](https://github.com/<owner>/<repo>/raw/pr-diagram-assets/pr/<n>/<sha>/architecture-light.svg)
![データフロー](https://github.com/<owner>/<repo>/raw/pr-diagram-assets/pr/<n>/<sha>/data-flow-light.svg)
```

Optional: `gh pr comment <n> --body-file …`. If the CLI supports attachment for
your gh version, `--attach` is fine as a supplement; raw orphan URLs remain the
canonical delivery (GitHub renders them inline).

Other modes when the user asks: write files under `.pr-diagram/`, chat-only
preview, or append a section to the PR body (keep their original description).

**Canvas push** (`pr-lens canvas push`) only if the user explicitly asks.

### 5. Quality bar

- Look = Coldtea renderer output (lane cards, delta chips, hero edges, flow
  animation). Mermaid fenced blocks are **not** the target look.
- Every node/edge justifiable from the diff or necessary unchanged context.
- Caption matches the diagrams; one clear architecture figure; data-flow only
  when data moves.
- Tiny docs typo → say so; minimal architecture or skip data-flow.
- No GitHub App requirement; no uploading private source to unknown hosts.

### Mermaid fallback (only if forbidden)

If the user **forbids npm / Coldtea packages**, fall back to Mermaid in the PR
body/comment and optionally `scripts/render-mermaid.sh`. Say clearly that the
Coldtea card look is unavailable. Do not pretend Mermaid equals PR Lens SVGs.

## Anti-patterns

- Mermaid-first when Coldtea render is allowed
- Calling canvas / prlens.dev without an explicit ask
- Inventing services not evidenced by the diff
- Overwriting the user's PR description
- Naming the asset branch in a way that collides with existing fixture prefixes
- Force-pushing over unrelated branches or deleting fixture content

## References

- `references/graph-document.md` — deltas, lanes, nodes, edges, flows, views, common validator errors
- `references/granularity.md` — target density and labeling
- `assets/example-acme-scm-allocation-sim.graph.json` — full valid fictional example
- `assets/comment-template.md` — architecture + data-flow image comment
- `scripts/render-mermaid.sh` — optional Mermaid→SVG fallback only
