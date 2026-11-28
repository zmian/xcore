#!/usr/bin/env bash
# Ensures GOVERNANCE_METRICS.md matches live inventory totals.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
METRICS="$ROOT/docs/architecture/GOVERNANCE_METRICS.md"
POLICY="$ROOT/docs/architecture/TEST_CI_POLICY.md"
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

if rg -q 'nonisolated\(unsafe\)' "$SOURCES" --glob '*.swift' 2>/dev/null; then
  unsafe_live="$(rg -c 'nonisolated\(unsafe\)' "$SOURCES" --glob '*.swift' | awk -F: '{s+=$2} END {print s+0}')"
else
  unsafe_live=0
fi
doc_unsafe="$(expected_metric 'nonisolated(unsafe) in Sources/Xcore')"
[[ "$unsafe_live" == "$doc_unsafe" ]] || {
  echo "nonisolated(unsafe): live $unsafe_live, GOVERNANCE_METRICS $doc_unsafe"
  exit 1
}

if rg -q '@unchecked Sendable' "$SOURCES" --glob '*.swift' 2>/dev/null; then
  unchecked_live="$(rg -c '@unchecked Sendable' "$SOURCES" --glob '*.swift' | awk -F: '{s+=$2} END {print s+0}')"
else
  unchecked_live=0
fi
doc_unchecked="$(expected_metric '@unchecked Sendable in Sources/Xcore')"
[[ "$unchecked_live" == "$doc_unchecked" ]] || {
  echo "@unchecked Sendable: live $unchecked_live, GOVERNANCE_METRICS $doc_unchecked"
  exit 1
}

warning_live=0
if rg -q '#warning' "$SOURCES" --glob '*.swift' 2>/dev/null; then
  warning_live="$(rg -c '#warning' "$SOURCES" --glob '*.swift' | awk -F: '{s+=$2} END {print s+0}')"
fi
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
  "Swift/Protocols files:SWIFT_PROTOCOLS_INDEX.md:Total:" \
  "Swift/PropertyWrappers files:SWIFT_PROPERTY_WRAPPERS_INDEX.md:Total:" \
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

runtime_live="$(
  rg -c 'disabled\(if: TestEnvironment\.isCI' "$ROOT/Tests" --glob '*.swift' 2>/dev/null \
    | rg -v 'LiveAddressSearchClientTests\.swift' \
    | awk -F: '{s+=$2} END {print s+0}'
)"
doc_runtime="$(expected_metric 'Runtime CI test skips')"
policy_runtime="$(rg -o 'Runtime CI skips: [0-9]+' "$POLICY" | head -1 | rg -o '[0-9]+' || true)"
[[ "$runtime_live" == "$doc_runtime" && "$doc_runtime" == "$policy_runtime" ]] || {
  echo "Runtime CI skips: live $runtime_live, GOVERNANCE_METRICS $doc_runtime, TEST_CI_POLICY $policy_runtime"
  exit 1
}

serialized_live="$(
  rg -l '@Suite\(\.serialized\)' "$ROOT/Tests" --glob '*.swift' 2>/dev/null | wc -l | tr -d ' '
)"
doc_serialized="$(expected_metric 'Serialized Swift Testing suites')"
policy_serialized="$(rg -o 'Serialized suites: [0-9]+' "$POLICY" | head -1 | rg -o '[0-9]+' || true)"
[[ "$serialized_live" == "$doc_serialized" && "$doc_serialized" == "$policy_serialized" ]] || {
  echo "Serialized suites: live $serialized_live, GOVERNANCE_METRICS $doc_serialized, TEST_CI_POLICY $policy_serialized"
  exit 1
}

echo "Governance metrics audit passed."