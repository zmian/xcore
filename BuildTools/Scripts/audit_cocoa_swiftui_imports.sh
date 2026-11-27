#!/usr/bin/env bash
# Enforces ADR 0003: Cocoa may import SwiftUI only on the documented allowlist.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DOC="$ROOT/docs/architecture/LAYER_IMPORTS.md"
COCOA="$ROOT/Sources/Xcore/Cocoa"

ALLOWLIST=(
  "Sources/Xcore/Cocoa/Components/HUD/UIHostingWindow.swift"
  "Sources/Xcore/Cocoa/Components/UIImage/ImageView.swift"
  "Sources/Xcore/Cocoa/Extensions/UIColor+Extensions.swift"
  "Sources/Xcore/Cocoa/Extensions/UIFont/UIFont+Typeface.swift"
)

mapfile -t importers < <(rg -l '^import SwiftUI' "$COCOA" --glob '*.swift' | sort)

doc_count="$(rg -o 'Total: [0-9]+' "$DOC" | head -1 | rg -o '[0-9]+' || true)"
if [[ -z "$doc_count" ]]; then
  echo "Could not read Total from LAYER_IMPORTS.md"
  exit 1
fi

if [[ "${#importers[@]}" != "$doc_count" ]]; then
  echo "Cocoa SwiftUI importers: ${#importers[@]}, LAYER_IMPORTS.md Total: $doc_count"
  exit 1
fi

for file in "${importers[@]}"; do
  rel="${file#"$ROOT/"}"
  allowed=false
  for path in "${ALLOWLIST[@]}"; do
    if [[ "$rel" == "$path" ]]; then
      allowed=true
      break
    fi
  done
  if ! $allowed; then
    echo "Undocumented Cocoa SwiftUI import: $rel"
    echo "Update LAYER_IMPORTS.md, audit allowlist, and ADR 0003 if intentional."
    exit 1
  fi
done

table_rows="$(rg '^\| `Cocoa/' "$DOC" | wc -l | tr -d ' ')"
if [[ "$table_rows" != "$doc_count" ]]; then
  echo "LAYER_IMPORTS.md table has $table_rows Cocoa rows, Total says $doc_count"
  exit 1
fi

echo "Cocoa SwiftUI import audit passed ($doc_count allowed files)."