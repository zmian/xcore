#!/usr/bin/env bash
# Ensures COCOA_COMPONENT_INDEX.md matches domain folder count in Cocoa/Components.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INDEX="$ROOT/docs/architecture/COCOA_COMPONENT_INDEX.md"
COMPONENTS="$ROOT/Sources/Xcore/Cocoa/Components"

live_count="$(find "$COMPONENTS" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
doc_count="$(rg -o 'Total: [0-9]+' "$INDEX" | head -1 | rg -o '[0-9]+' || true)"

if [[ -z "$doc_count" ]]; then
  echo "Could not read Total from COCOA_COMPONENT_INDEX.md"
  exit 1
fi

if [[ "$live_count" != "$doc_count" ]]; then
  echo "Cocoa component index out of date: $live_count domain folder(s), index says $doc_count"
  echo "Update docs/architecture/COCOA_COMPONENT_INDEX.md"
  exit 1
fi

table_rows="$(rg '^\| `[^`]+` \|' "$INDEX" | wc -l | tr -d ' ')"
if [[ "$table_rows" != "$doc_count" ]]; then
  echo "COCOA_COMPONENT_INDEX.md table has $table_rows rows, Total says $doc_count"
  exit 1
fi

echo "Cocoa component index audit passed ($live_count domains)."