#!/usr/bin/env bash
# Ensures GOVERNANCE_METRICS.md matches live inventory totals.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
METRICS="$ROOT/docs/architecture/GOVERNANCE_METRICS.md"
SOURCES="$ROOT/Sources/Xcore"

expected_metric() {
  local label="$1"
  awk -F'|' -v lbl="$label" 'index($2, lbl) > 0 {gsub(/^ +| +$/, "", $3); print $3; exit}' "$METRICS"
}

audit_scripts="$(rg -o 'audit_[a-z0-9_]+\.sh' "$ROOT/Makefile" | sort -u | wc -l | tr -d ' ')"
doc_audits="$(expected_metric "Architecture audit scripts")"
[[ "$audit_scripts" == "$doc_audits" ]] || {
  echo "Architecture audit scripts: Makefile $audit_scripts, GOVERNANCE_METRICS $doc_audits"
  exit 1
}

unsafe_live="$(rg -c 'nonisolated\(unsafe\)' "$SOURCES" --glob '*.swift' 2>/dev/null | awk -F: '{s+=$2} END {print s+0}')"
doc_unsafe="$(expected_metric 'nonisolated(unsafe) in Sources/Xcore')"
[[ "$unsafe_live" == "$doc_unsafe" ]] || {
  echo "nonisolated(unsafe): live $unsafe_live, GOVERNANCE_METRICS $doc_unsafe"
  exit 1
}

warning_live="$(rg -c '#warning' "$SOURCES" --glob '*.swift' 2>/dev/null | awk -F: '{s+=$2} END {print s+0}')"
doc_warning="$(expected_metric '#warning in Sources/Xcore')"
[[ "$warning_live" == "$doc_warning" ]] || {
  echo "#warning count: live $warning_live, GOVERNANCE_METRICS $doc_warning"
  exit 1
}

for pair in \
  "Production dependency keys:DEPENDENCY_REGISTRY.md:Total:" \
  "Swift/Components domains:COMPONENT_INDEX.md:Total:" \
  "SwiftUI/Components domains:SWIFTUI_COMPONENT_INDEX.md:Total:" \
  "Cocoa/Components domains:COCOA_COMPONENT_INDEX.md:Total:" \
  "Swift/Helpers files:HELPERS_INDEX.md:Total:" \
  "Swift/Extensions domains:EXTENSIONS_INDEX.md:Total:" \
  "Swift/Dependencies subfolders:DEPENDENCY_LAYOUT.md:Total subfolders:" \
  "Cocoa/Extensions folders:COCOA_EXTENSIONS_INDEX.md:Total:" \
  "SwiftUI/Extensions folders:SWIFTUI_EXTENSIONS_INDEX.md:Total:"; do
  IFS=':' read -r label file marker <<< "$pair"
  doc_path="$ROOT/docs/architecture/$file"
  if [[ "$marker" == "Total subfolders" ]]; then
    live="$(rg -o 'Total subfolders: [0-9]+' "$doc_path" | head -1 | rg -o '[0-9]+')"
  else
    live="$(rg -o 'Total: [0-9]+' "$doc_path" | head -1 | rg -o '[0-9]+')"
  fi
  doc="$(expected_metric "$label")"
  [[ "$live" == "$doc" ]] || {
    echo "$label: $file says $live, GOVERNANCE_METRICS $doc"
    exit 1
  }
done

ext_root_live="$(rg -o 'Root files: [0-9]+' "$ROOT/docs/architecture/EXTENSIONS_INDEX.md" | head -1 | rg -o '[0-9]+')"
ext_root_doc="$(expected_metric 'Swift/Extensions root files')"
[[ "$ext_root_live" == "$ext_root_doc" ]] || {
  echo "Swift/Extensions root files: EXTENSIONS_INDEX $ext_root_live, GOVERNANCE_METRICS $ext_root_doc"
  exit 1
}

for pair in \
  "Cocoa/Extensions root files:COCOA_EXTENSIONS_INDEX.md:Root" \
  "SwiftUI/Extensions root files:SWIFTUI_EXTENSIONS_INDEX.md:Root" \
  "Cocoa/Blocks files:COCOA_SUPPORTING_INDEX.md:Blocks" \
  "Cocoa/Protocols files:COCOA_SUPPORTING_INDEX.md:Protocols"; do
  IFS=':' read -r label file marker <<< "$pair"
  doc_path="$ROOT/docs/architecture/$file"
  if [[ "$marker" == "Blocks" ]]; then
    live="$(rg -o 'Blocks files: [0-9]+' "$doc_path" | head -1 | rg -o '[0-9]+')"
  elif [[ "$marker" == "Protocols" ]]; then
    live="$(rg -o 'Protocols files: [0-9]+' "$doc_path" | head -1 | rg -o '[0-9]+')"
  else
    live="$(rg -o 'Root files: [0-9]+' "$doc_path" | head -1 | rg -o '[0-9]+')"
  fi
  doc="$(expected_metric "$label")"
  [[ "$live" == "$doc" ]] || {
    echo "$label: $file says $live, GOVERNANCE_METRICS $doc"
    exit 1
  }
done

imports_doc="$ROOT/docs/architecture/LAYER_IMPORTS.md"
cocoa_allow="$(rg -o 'Allowlist count: [0-9]+' "$imports_doc" | sed -n '1p' | rg -o '[0-9]+')"
swift_allow="$(rg -o 'Allowlist count: [0-9]+' "$imports_doc" | sed -n '2p' | rg -o '[0-9]+')"
doc_cocoa="$(expected_metric 'Cocoa→SwiftUI allowlist')"
doc_swift="$(expected_metric 'Swift/Components→UIKit allowlist')"
[[ "$cocoa_allow" == "$doc_cocoa" && "$swift_allow" == "$doc_swift" ]] || {
  echo "Layer import allowlists out of sync with GOVERNANCE_METRICS.md"
  exit 1
}

echo "Governance metrics audit passed."