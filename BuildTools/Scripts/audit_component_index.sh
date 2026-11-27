#!/usr/bin/env bash
# Ensures COMPONENT_INDEX.md matches domain folder count in Swift/Components.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INDEX="$ROOT/docs/architecture/COMPONENT_INDEX.md"
COMPONENTS="$ROOT/Sources/Xcore/Swift/Components"

live_count="$(find "$COMPONENTS" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
doc_count="$(rg -o 'Total: [0-9]+' "$INDEX" | head -1 | rg -o '[0-9]+' || true)"

if [[ -z "$doc_count" ]]; then
  echo "Could not read Total from COMPONENT_INDEX.md"
  exit 1
fi

if [[ "$live_count" != "$doc_count" ]]; then
  echo "Component index out of date: $live_count domain folder(s), index says $doc_count"
  echo "Update docs/architecture/COMPONENT_INDEX.md"
  exit 1
fi

table_rows="$(rg '^\| `[^`]+` \|' "$INDEX" | wc -l | tr -d ' ')"
if [[ "$table_rows" != "$doc_count" ]]; then
  echo "COMPONENT_INDEX.md table has $table_rows rows, Total says $doc_count"
  exit 1
fi

echo "Component index audit passed ($live_count domains)."