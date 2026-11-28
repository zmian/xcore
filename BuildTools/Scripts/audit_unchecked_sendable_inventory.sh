#!/usr/bin/env bash
# Ensures UNCHECKED_SENDABLE_INVENTORY.md stays in sync with @unchecked Sendable usage.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INVENTORY="$ROOT/docs/architecture/UNCHECKED_SENDABLE_INVENTORY.md"
SOURCES="$ROOT/Sources/Xcore"

if rg -q '@unchecked Sendable' "$SOURCES" --glob '*.swift' 2>/dev/null; then
  live_count="$(rg -c '@unchecked Sendable' "$SOURCES" --glob '*.swift' | awk -F: '{s+=$2} END {print s+0}')"
else
  live_count=0
fi
doc_count="$(rg -o 'Total: [0-9]+' "$INVENTORY" | head -1 | rg -o '[0-9]+' || true)"

if [[ -z "$doc_count" ]]; then
  echo "Could not read total from UNCHECKED_SENDABLE_INVENTORY.md"
  exit 1
fi

if [[ "$live_count" != "$doc_count" ]]; then
  echo "Unchecked Sendable inventory out of date: found $live_count, doc says $doc_count"
  echo "Update docs/architecture/UNCHECKED_SENDABLE_INVENTORY.md and GOVERNANCE_METRICS.md"
  exit 1
fi

echo "Unchecked Sendable inventory audit passed ($live_count annotations)."