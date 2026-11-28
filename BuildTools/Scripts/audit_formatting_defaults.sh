#!/usr/bin/env bash
# Frozen formatting defaults in Constants.swift (no nonisolated(unsafe)).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CONSTANTS="$ROOT/Sources/Xcore/Swift/Helpers/Constants.swift"
DOC="$ROOT/docs/architecture/FORMATTING_DEFAULTS.md"

if rg -q 'nonisolated\\(unsafe\\).*(mask|defaultFractionDigits|maxFractionDigits|defaultRandomUpperBound)' "$CONSTANTS"; then
  echo "Formatting defaults must be frozen (static let), not nonisolated(unsafe)."
  rg -n 'nonisolated\\(unsafe\\).*(mask|defaultFractionDigits|maxFractionDigits|defaultRandomUpperBound)' "$CONSTANTS"
  exit 1
fi

for name in mask defaultFractionDigits maxFractionDigits; do
  if ! rg -q "public static let ${name}" "$CONSTANTS"; then
    echo "Missing public static let ${name} in Constants.swift"
    exit 1
  fi
done

if ! rg -q 'public static let defaultRandomUpperBound = 100$' "$CONSTANTS"; then
  echo "Int.defaultRandomUpperBound must be public static let = 100"
  exit 1
fi

if ! rg -q 'defaultRandomUpperBound = 100\.0' "$CONSTANTS"; then
  echo "Double.defaultRandomUpperBound must be public static let = 100.0"
  exit 1
fi

doc_rows="$(rg '^\| `[^`]+` \|' "$DOC" | wc -l | tr -d ' ')"
if [[ "$doc_rows" != "5" ]]; then
  echo "FORMATTING_DEFAULTS.md should list 5 symbols (found $doc_rows table rows)."
  exit 1
fi

echo "Formatting defaults audit passed (frozen SSOT)."