# pr-review-diagram

[日本語](#日本語) · [English](#english)

Claude Code / Cursor 共用スキル。PR 差分から Coldtea PR Lens 相当の構成図・データフロー SVG を作り、orphan ブランチと PR コメント画像で届けます。

A Claude Code / Cursor skill that turns a PR diff into Coldtea PR Lens–style architecture and data-flow SVGs, delivered via an orphan branch and markdown images on the PR.

---

## 日本語

### できること

- エージェントが Coldtea `schemaVersion 0.2.0` の `graph.json` を書く
- 実行時: `npx @coldtea/pr-lens-cli@latest validate` → `render --theme light`（MIT © Coldtea AI）
- 既定: **canvas へは push しない**（プライベート向き）。**GitHub App は不要**
- 見た目は Coldtea renderer の SVG（npm / Coldtea が使えないときだけ Mermaid フォールバック）

このリポジトリはスキル一式と手順のドキュメントです。Coldtea のソースは同梱しません。

### インストール

Cursor は `.claude/skills/` も読むので、プロジェクトでは次のコピーだけで Claude Code と Cursor の両方に効きます。

```bash
# このリポを clone したあと
mkdir -p .claude/skills
cp -R pr-review-diagram .claude/skills/
```

個人グローバル:

```bash
# Claude Code
mkdir -p ~/.claude/skills
cp -R pr-review-diagram ~/.claude/skills/

# Cursor だけ別置きしたい場合
mkdir -p ~/.cursor/skills
cp -R pr-review-diagram ~/.cursor/skills/
```

### 使い方

- スラッシュ: `/pr-review-diagram`
- 自然言語: 「このPRの構成図を」「データフローを画像でコメントして」

流れ: 差分を読む → `.pr-diagram/graph.json` を書く → validate / render → orphan ブランチ `pr-diagram-assets` に SVG を置く → raw URL で PR コメント。詳細は `pr-review-diagram/SKILL.md`。

粒度の見本（架空の Acme SCM 機能 PR）:  
`pr-review-diagram/assets/example-acme-scm-allocation-sim.graph.json`

### 中身

| パス | 役割 |
| --- | --- |
| `pr-review-diagram/SKILL.md` | 操作手順 |
| `references/graph-document.md` | graph 要約とよくある validate エラー |
| `references/granularity.md` | レーン / ノード / フローの目安密度 |
| `assets/example-acme-scm-allocation-sim.graph.json` | 妥当な例示グラフ（架空） |
| `assets/comment-template.md` | 画像コメント用 Markdown |
| `scripts/render-mermaid.sh` | **任意** Mermaid→SVG フォールバックのみ |

### ライセンス

MIT © 2026 uzuraDev。

グラフ schema と CLI / renderer: MIT © Coldtea AI（`@coldtea/pr-lens-schema`, `@coldtea/pr-lens-cli`）。

---

## English

### What it does

- The agent authors a Coldtea `schemaVersion 0.2.0` `graph.json`
- Runtime: `npx @coldtea/pr-lens-cli@latest validate` → `render --theme light` (MIT © Coldtea AI)
- Default: **no canvas push** (private-friendly). **No GitHub App required**
- Look comes from the Coldtea renderer (Mermaid only if npm / Coldtea packages are forbidden)

This repository is skill packaging and workflow docs only. It does **not** vend Coldtea source.

### Install

Cursor also reads `.claude/skills/`, so one project copy covers both Claude Code and Cursor:

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

### Usage

- Slash: `/pr-review-diagram`
- Natural language: “draw architecture for this PR”, “comment data-flow SVGs on this PR”

Flow: read the diff → write `.pr-diagram/graph.json` → validate / render → push SVGs on orphan branch `pr-diagram-assets` → comment with raw image URLs. Details in `pr-review-diagram/SKILL.md`.

Granularity example (fictional Acme SCM feature PR):  
`pr-review-diagram/assets/example-acme-scm-allocation-sim.graph.json`

### Contents

| Path | Role |
| --- | --- |
| `pr-review-diagram/SKILL.md` | Operating manual |
| `references/graph-document.md` | Graph summary + common validate errors |
| `references/granularity.md` | Target lane / node / flow density |
| `assets/example-acme-scm-allocation-sim.graph.json` | Valid example graph (fictional) |
| `assets/comment-template.md` | Image comment markdown |
| `scripts/render-mermaid.sh` | **Optional** Mermaid→SVG fallback only |

### License

MIT © 2026 uzuraDev.

Graph schema and CLI / renderer: MIT © Coldtea AI (`@coldtea/pr-lens-schema`, `@coldtea/pr-lens-cli`).
