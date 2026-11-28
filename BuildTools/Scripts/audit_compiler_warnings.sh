#!/usr/bin/env bash
# Ensures ENTROPY_INVENTORY.md #warning total matches the codebase.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INVENTORY="$ROOT/docs/architecture/ENTROPY_INVENTORY.md"
SOURCES="$ROOT/Sources/Xcore"

live_count=0
if rg -q '#warning' "$SOURCES" --glob '*.swift' 2>/dev/null; then
  live_count="$(rg -c '#warning' "$SOURCES" --glob '*.swift' | awk -F: '{s+=$2} END {print s+0}')"
fi
doc_count="$(rg -o 'Total: [0-9]+' "$INVENTORY" | head -1 | rg -o '[0-9]+' || true)"

if [[ -z "$doc_count" ]]; then
  echo "Could not read #warning total from ENTROPY_INVENTORY.md"
  exit 1
fi

if [[ "$live_count" != "$doc_count" ]]; then
  echo "Compiler warning inventory out of date: found $live_count #warning, doc says $doc_count"
  echo "Update docs/architecture/ENTROPY_INVENTORY.md"
  exit 1
fi

echo "Compiler warning inventory audit passed ($live_count warnings)."