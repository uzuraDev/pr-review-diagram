# pr-review-diagram

Claude Code / Cursor skill: turn a PR diff into **Coldtea PR Lens–style architecture and data-flow SVGs**, then deliver them via an orphan branch + markdown image URLs in a PR comment.

- Agent authors a Coldtea `schemaVersion 0.2.0` `graph.json`
- Runtime: `npx @coldtea/pr-lens-cli@latest validate` → `render --theme light` (MIT © Coldtea AI)
- Default: **no canvas push** (private-friendly). **No GitHub App required**
- Look comes from the Coldtea renderer (Mermaid only if npm/Coldtea packages are forbidden)

This repository is the skill packaging and workflow docs only. It does **not** vend Coldtea source.

## Install

Cursor also reads `.claude/skills/`, so one copy covers both tools in a project:

```bash
# After cloning this repo
mkdir -p .claude/skills
cp -R pr-review-diagram .claude/skills/
```

Personal (global):

```bash
# Claude Code
mkdir -p ~/.claude/skills
cp -R pr-review-diagram ~/.claude/skills/

# Cursor-only alternate location
mkdir -p ~/.cursor/skills
cp -R pr-review-diagram ~/.cursor/skills/
```

## Usage

- Slash: `/pr-review-diagram`
- Natural language: “draw architecture for this PR”, 「このPRの構成図を」

Flow: read the diff → write `.pr-diagram/graph.json` → validate/render → push SVGs on orphan branch `pr-diagram-assets` → comment with raw image URLs. Details in `pr-review-diagram/SKILL.md`.

Granularity example (fictional Acme SCM feature PR):  
`pr-review-diagram/assets/example-acme-scm-allocation-sim.graph.json`

## Contents

| Path | Role |
| --- | --- |
| `pr-review-diagram/SKILL.md` | Operating manual |
| `references/graph-document.md` | Coldtea graph summary + common validate errors |
| `references/granularity.md` | Target lane/node/flow density |
| `assets/example-acme-scm-allocation-sim.graph.json` | Valid example graph (fictional) |
| `assets/comment-template.md` | Image comment markdown |
| `scripts/render-mermaid.sh` | **Optional** Mermaid→SVG fallback only |

## License

MIT © 2026 uzuraDev.

Graph schema and CLI/renderer: MIT © Coldtea AI (`@coldtea/pr-lens-schema`, `@coldtea/pr-lens-cli`).
