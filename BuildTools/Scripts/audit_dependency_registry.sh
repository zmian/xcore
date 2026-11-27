#!/usr/bin/env bash
# Ensures DEPENDENCY_REGISTRY.md matches live DependencyKey count in Sources/Xcore.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
REGISTRY="$ROOT/docs/architecture/DEPENDENCY_REGISTRY.md"
SOURCES="$ROOT/Sources/Xcore"

live_count="$(rg --no-heading -l '^\s*(private\s+)?enum\s+\w+.*:\s*DependencyKey' "$SOURCES" | wc -l | tr -d ' ')"
doc_count="$(rg -o 'Total: [0-9]+' "$REGISTRY" | head -1 | rg -o '[0-9]+' || true)"

if [[ -z "$doc_count" ]]; then
  echo "Could not read Total from DEPENDENCY_REGISTRY.md"
  exit 1
fi

if [[ "$live_count" != "$doc_count" ]]; then
  echo "Dependency registry out of date: $live_count DependencyKey file(s), registry says $doc_count"
  echo "Update docs/architecture/DEPENDENCY_REGISTRY.md"
  exit 1
fi

echo "Dependency registry audit passed ($live_count production keys)."