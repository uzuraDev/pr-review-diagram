#!/usr/bin/env bash
# OPTIONAL FALLBACK ONLY — when the user forbids npm Coldtea packages.
# Target look is Coldtea PR Lens SVGs via: npx @coldtea/pr-lens-cli@latest render
# Mermaid does not match that card/lane/delta style.
set -euo pipefail
in="${1:?usage: render-mermaid.sh diagram.mmd [out.svg]}"
out="${2:-${in%.mmd}.svg}"
npx --yes @mermaid-js/mermaid-cli@11 -i "$in" -o "$out" -b transparent
echo "wrote $out"
