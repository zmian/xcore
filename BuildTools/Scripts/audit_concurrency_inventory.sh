#!/usr/bin/env bash
# Ensures CONCURRENCY_INVENTORY.md stays in sync with nonisolated(unsafe) usage count.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INVENTORY="$ROOT/docs/architecture/CONCURRENCY_INVENTORY.md"
SOURCES="$ROOT/Sources/Xcore"

if rg -q 'nonisolated\(unsafe\)' "$SOURCES" --glob '*.swift' 2>/dev/null; then
  live_count="$(rg -c 'nonisolated\(unsafe\)' "$SOURCES" --glob '*.swift' | awk -F: '{s+=$2} END {print s+0}')"
else
  live_count=0
fi
doc_count="$(rg -o 'Total: [0-9]+' "$INVENTORY" | head -1 | rg -o '[0-9]+' || true)"

if [[ -z "$doc_count" ]]; then
  echo "Could not read total from CONCURRENCY_INVENTORY.md"
  exit 1
fi

if [[ "$live_count" != "$doc_count" ]]; then
  echo "Concurrency inventory out of date: found $live_count nonisolated(unsafe), doc says $doc_count"
  echo "Update docs/architecture/CONCURRENCY_INVENTORY.md"
  exit 1
fi

echo "Concurrency inventory audit passed ($live_count annotations)."