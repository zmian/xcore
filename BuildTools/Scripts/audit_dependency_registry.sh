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

missing=0
while IFS= read -r key; do
  [[ -z "$key" ]] && continue
  if ! rg -q "var ${key}:" "$SOURCES" --glob '*.swift'; then
    echo "DEPENDENCY_REGISTRY lists '\`${key}\`' but no DependencyValues property found"
    missing=1
  fi
done < <(rg '^\| `[^`]+` \|' "$REGISTRY" | sed -n 's/^| `\([^`]*\)`.*/\1/p')

if [[ "$missing" -ne 0 ]]; then
  exit 1
fi

path_errors=0
while IFS= read -r rel; do
  [[ -z "$rel" ]] && continue
  rel="${rel//\`/}"
  rel="${rel%% (*}"
  rel="${rel// /}"
  dir="$ROOT/Sources/Xcore/$rel"
  if [[ ! -d "$dir" ]]; then
    echo "DEPENDENCY_REGISTRY location missing on disk: Sources/Xcore/$rel"
    path_errors=1
  fi
done < <(rg '^\| `[^`]+` \|' "$REGISTRY" | awk -F'|' '{gsub(/^ +| +$/, "", $4); print $4}')

if [[ "$path_errors" -ne 0 ]]; then
  exit 1
fi

echo "Dependency registry audit passed ($live_count production keys)."