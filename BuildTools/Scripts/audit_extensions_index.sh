#!/usr/bin/env bash
# Ensures EXTENSIONS_INDEX.md matches Swift/Extensions layout.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INDEX="$ROOT/docs/architecture/EXTENSIONS_INDEX.md"
EXTENSIONS="$ROOT/Sources/Xcore/Swift/Extensions"

live_domains="$(find "$EXTENSIONS" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
live_root="$(find "$EXTENSIONS" -maxdepth 1 -name '*.swift' | wc -l | tr -d ' ')"
doc_domains="$(rg -o 'Total: [0-9]+' "$INDEX" | head -1 | rg -o '[0-9]+' || true)"
doc_root="$(rg -o 'Root files: [0-9]+' "$INDEX" | head -1 | rg -o '[0-9]+' || true)"

if [[ -z "$doc_domains" || -z "$doc_root" ]]; then
  echo "Could not read Total / Root files from EXTENSIONS_INDEX.md"
  exit 1
fi

if [[ "$live_domains" != "$doc_domains" ]]; then
  echo "Extensions index out of date: $live_domains folder(s), index says $doc_domains"
  exit 1
fi

if [[ "$live_root" != "$doc_root" ]]; then
  echo "Extensions root file count out of date: $live_root file(s), index says $doc_root"
  exit 1
fi

table_rows="$(rg '^\| `[^`]+` \|' "$INDEX" | wc -l | tr -d ' ')"
if [[ "$table_rows" != "$doc_domains" ]]; then
  echo "EXTENSIONS_INDEX.md table has $table_rows rows, Total says $doc_domains"
  exit 1
fi

echo "Extensions index audit passed ($live_domains domains, $live_root root files)."