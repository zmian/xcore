#!/usr/bin/env bash
# Enforces ADR 0004 composite init dedupe and add() duplicate guards.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

declare -a composites=(
  "Sources/Xcore/Cocoa/Components/UIImage/ImageFetcher/ImageFetcher+Composite.swift"
  "Sources/Xcore/Swift/Components/FeatureFlag/Core/Providers/FeatureFlagProvider+Composite.swift"
)

for rel in "${composites[@]}"; do
  path="$ROOT/$rel"
  if [[ ! -f "$path" ]]; then
    echo "Missing composite file: $rel"
    exit 1
  fi
  if ! rg -q 'uniqued\(\\\.id\)' "$path"; then
    echo "Missing init dedupe uniqued(\\.id) in $rel (ADR 0004)."
    exit 1
  fi
  if ! rg -q 'contains\(where:.*\.id' "$path"; then
    echo "Missing add() duplicate-id guard in $rel (ADR 0004)."
    exit 1
  fi
done

exception="$ROOT/Sources/Xcore/Cocoa/Components/UIImage/ImageTransform/ImageTransform+Composite.swift"
if [[ -f "$exception" ]] && rg -q 'uniqued\(\\\.id\)' "$exception"; then
  echo "CompositeImageTransform must not dedupe inits by id (ADR 0004 exception)."
  exit 1
fi

echo "Composite registration audit passed (ADR 0004)."