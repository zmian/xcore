#!/usr/bin/env bash
# Associated-object key pattern (ADR 0006): UInt8 tokens, no nonisolated(unsafe).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SOURCES="$ROOT/Sources/Xcore"

if rg -q 'nonisolated\(unsafe\)' "$SOURCES" --glob '*.swift' 2>/dev/null; then
  echo "Sources/Xcore must not use nonisolated(unsafe) (ADR 0006)."
  rg -n 'nonisolated\(unsafe\)' "$SOURCES" --glob '*.swift'
  exit 1
fi

key_files=()
while IFS= read -r file; do
  [[ -n "$file" ]] && key_files+=("$file")
done < <(rg -l 'enum AssociatedKey' "$SOURCES" --glob '*.swift' 2>/dev/null || true)

for file in "${key_files[@]}"; do
  if rg -q 'static var [A-Za-z0-9_]+ = "' "$file" 2>/dev/null; then
    echo "Associated object keys must use AssociatedObjectKey (static let), not String literals:"
    rg -n 'static var [A-Za-z0-9_]+ = "' "$file"
    exit 1
  fi
  if rg -q 'static var [A-Za-z0-9_]+: UInt8' "$file" 2>/dev/null; then
    echo "Associated object keys must use static let AssociatedObjectKey(), not mutable UInt8:"
    rg -n 'static var [A-Za-z0-9_]+: UInt8' "$file"
    exit 1
  fi
  if rg -q 'nonisolated\(unsafe\).*AssociatedKey|AssociatedKey.*nonisolated\(unsafe\)' "$file" 2>/dev/null; then
    echo "AssociatedKey enums must not use nonisolated(unsafe): $file"
    exit 1
  fi
done

echo "Associated object key audit passed (ADR 0006)."