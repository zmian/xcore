#!/usr/bin/env bash
# Enforces ADR 0003 cross-layer import allowlists (see LAYER_IMPORTS.md).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DOC="$ROOT/docs/architecture/LAYER_IMPORTS.md"

check_allowlist() {
  local label="$1"
  local search_root="$2"
  local import_pattern="$3"
  local expected="$4"
  shift 4
  local -a allowlist=("$@")

  mapfile -t importers < <(rg -l "$import_pattern" "$search_root" --glob '*.swift' | sort)

  if [[ "${#importers[@]}" != "$expected" ]]; then
    echo "$label: found ${#importers[@]} importer(s), allowlist count $expected"
    printf '  %s\n' "${importers[@]}"
    exit 1
  fi

  for file in "${importers[@]}"; do
    local rel="${file#"$ROOT/"}"
    local allowed=false
    for path in "${allowlist[@]}"; do
      if [[ "$rel" == "$path" ]]; then
        allowed=true
        break
      fi
    done
    if ! $allowed; then
      echo "Undocumented $label import: $rel"
      exit 1
    fi
  done

  echo "$label import audit passed ($expected files)."
}

mapfile -t allowlist_counts < <(rg -o 'Allowlist count: [0-9]+' "$DOC" | rg -o '[0-9]+')
if [[ "${#allowlist_counts[@]}" != 2 ]]; then
  echo "LAYER_IMPORTS.md must declare two Allowlist count lines"
  exit 1
fi

check_allowlist \
  "Cocoa → SwiftUI" \
  "$ROOT/Sources/Xcore/Cocoa" \
  '^import SwiftUI' \
  "${allowlist_counts[0]}" \
  "Sources/Xcore/Cocoa/Components/HUD/UIHostingWindow.swift" \
  "Sources/Xcore/Cocoa/Components/UIImage/ImageView.swift" \
  "Sources/Xcore/Cocoa/Extensions/UIColor+Extensions.swift" \
  "Sources/Xcore/Cocoa/Extensions/UIFont/UIFont+Typeface.swift"

check_allowlist \
  "Swift/Components → UIKit" \
  "$ROOT/Sources/Xcore/Swift/Components" \
  '^import UIKit' \
  "${allowlist_counts[1]}" \
  "Sources/Xcore/Swift/Components/Assets/SystemAssetIdentifier.swift" \
  "Sources/Xcore/Swift/Components/Combine/Publishers.swift" \
  "Sources/Xcore/Swift/Components/Configuration/Configuration.swift"

echo "Layer import audits passed."