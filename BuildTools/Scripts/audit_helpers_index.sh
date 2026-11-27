#!/usr/bin/env bash
# Ensures HELPERS_INDEX.md matches Swift/Helpers/*.swift count.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INDEX="$ROOT/docs/architecture/HELPERS_INDEX.md"
HELPERS="$ROOT/Sources/Xcore/Swift/Helpers"

live_count="$(find "$HELPERS" -maxdepth 1 -name '*.swift' | wc -l | tr -d ' ')"
doc_count="$(rg -o 'Total: [0-9]+' "$INDEX" | head -1 | rg -o '[0-9]+' || true)"

if [[ -z "$doc_count" ]]; then
  echo "Could not read Total from HELPERS_INDEX.md"
  exit 1
fi

if [[ "$live_count" != "$doc_count" ]]; then
  echo "Helpers index out of date: $live_count file(s), index says $doc_count"
  exit 1
fi

table_rows="$(rg '^\| `[^`]+` \|' "$INDEX" | wc -l | tr -d ' ')"
if [[ "$table_rows" != "$doc_count" ]]; then
  echo "HELPERS_INDEX.md table has $table_rows rows, Total says $doc_count"
  exit 1
fi

echo "Helpers index audit passed ($live_count files)."