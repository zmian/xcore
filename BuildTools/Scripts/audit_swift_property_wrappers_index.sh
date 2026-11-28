#!/usr/bin/env bash
# Ensures SWIFT_PROPERTY_WRAPPERS_INDEX.md matches Swift/PropertyWrappers/*.swift count.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INDEX="$ROOT/docs/architecture/SWIFT_PROPERTY_WRAPPERS_INDEX.md"
WRAPPERS="$ROOT/Sources/Xcore/Swift/PropertyWrappers"

live_count="$(find "$WRAPPERS" -maxdepth 1 -name '*.swift' | wc -l | tr -d ' ')"
doc_count="$(rg -o 'Total: [0-9]+' "$INDEX" | head -1 | rg -o '[0-9]+' || true)"

if [[ -z "$doc_count" ]]; then
  echo "Could not read Total from SWIFT_PROPERTY_WRAPPERS_INDEX.md"
  exit 1
fi

if [[ "$live_count" != "$doc_count" ]]; then
  echo "Swift property wrappers index out of date: $live_count file(s), index says $doc_count"
  exit 1
fi

table_rows="$(rg '^\| `[^`]+` \|' "$INDEX" | wc -l | tr -d ' ')"
if [[ "$table_rows" != "$doc_count" ]]; then
  echo "SWIFT_PROPERTY_WRAPPERS_INDEX table has $table_rows rows, Total says $doc_count"
  exit 1
fi

echo "Swift property wrappers index audit passed ($live_count files)."